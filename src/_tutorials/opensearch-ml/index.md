---
title: Building a RAG with OpenSearch®
logo: opensearch
category: ai
products:
  - Scalingo for OpenSearch®
permalink: /tutorials/opensearch-rag
modified_at: 2026-03-06
---

RAG (Retrieval-Augmented Generation) is an AI architecture where a Large Language Model (LLM) generates answers using external knowledge retrieved at query time, instead of relying only on its training data. This approach improves accuracy and freshness, since the answer is based on context-related documents that can be updated anytime.

OpenSearch® is particularly well suited for building RAG systems because it provides the core capabilities for the retrieval layer:

- It supports vector databases and [k-NN search][knn-search], allowing similarity search between embeddings and queries.
- It can combine semantic search (vectors) with keyword search, which improves retrieval quality.
- It is built for large-scale indexing and querying, making it ideal for knowledge bases with tons of documents.
- It integrates machine learning features.
- It's known for its low-latency search, which enables fast context retrieval.

## Planning your Deployment

Before deploying your RAG pipeline, you need the following components:

- A **Scalingo for OpenSearch® addon** to store embeddings and run
  similarity searches (you can find the documentaion [here][opensearch-doc]).

- The **Scalingo CLI** to execute commands on your application (see the [CLI documentation][cli-doc]).

- A **embedding model**, such as
  `huggingface/sentence-transformers/all-MiniLM-L6-v2`. This model converts text into numerical vectors (embeddings) that represent the semantic meaning of the text.

The tutorial can work with other models, you can find more information [here][opensearch-doc]. Since a RAG typically leverages vector search, we will use OpenSearch®'s **k-NN plugin**, which is already included in all Scalingo for OpenSearch® databases.

Vector search can require additional memory and CPU resources, depending on the number and size of stored embeddings. Each document embedding is stored as a vector, which increases index size and memory usage. 

For small datasets, a modest instance is usually sufficient, but larger knowledge bases may require more RAM to store vector indices efficiently and additional CPU resources to handle similarity searches and embedding generation.

## Setting Up the RAG in OpenSearch®

To use embedding models, OpenSearch® must allow model downloads and execution. Call the API of your OpenSearch® database and configure the cluster to:

- Allow external model downloads
- Enable model execution on all nodes
- Remove default memory limits memory limits
- Enable access control

We set `"only_run_on_ml_node": "false"` to allow the model to run on any node in the cluster, which is useful for local setups without dedicated ML nodes.

`"model_access_control_enabled": "true"` enables model access control, allowing administrators to restrict which users can access deployed models.

Finally, `"native_memory_threshold": "99"` increases the allowed native memory usage for ML tasks so that memory limits do not block model execution during development or testing.

~~~bash
scalingo --app my-app run curl -X PUT $SCALINGO_OPENSEARCH_URL/_cluster/settings \
  -H "Content-Type: application/json" \
  -d '{
    "persistent": {
      "plugins.ml_commons.only_run_on_ml_node": "false",
      "plugins.ml_commons.model_access_control_enabled": "true",
      "plugins.ml_commons.native_memory_threshold": "99"
    }
  }'
~~~

### Creating a Model Group

In OpenSearch®, a model group is a logical container used to organize and manage related machine learning models. It is commonly used to:

- Group multiple versions of the same ML model together (e.g. v1, v2, v3).
- Manage models lifecycle.
- Grant access to ML models for specific users or teams, by managing permissions and visibility.

The following request creates a model group named `rag-model-group`. We will use it to store the models related to the RAG we are building:

~~~bash
MODEL_GROUP_ID=$(scalingo --app my-app run curl -X POST $SCALINGO_OPENSEARCH_URL/_plugins/_ml/model_groups/_register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "rag-model-group",
    "description": "Model group for RAG embeddings"
  }' | jq -r '.model_group_id')
~~~

The response returns a **`model_group_id`** which is exported in our terminal. Keep its value for the next step.

### Registering the Embedding Model

Model registering designates the process of adding a machine learning model to the OpenSearch® ML framework, so the cluster can store, manage, and use it for inference. This process mostly consists in:

- Downloading the model.
- Importing it into OpenSearch®'s model registry.
- Storing the model's metadata, configuration, and artifacts in the cluster.
- Making it known to the ML plugin, so it can be used.

In this tutorial, we use a model named `huggingface/sentence-transformers/all-MiniLM-L6-v2`. [OpenSearch® Documentation][opensearch-doc] references other models that can be used.

~~~bash
TASK_ID=$(scalingo --app my-app run curl -X POST $SCALINGO_OPENSEARCH_URL/_plugins/_ml/models/_register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "huggingface/sentence-transformers/all-MiniLM-L6-v2",
    "version": "1.0.2",
    "model_group_id": "'$MODEL_GROUP_ID'",
    "model_format": "TORCH_SCRIPT"
  }' | jq -r '.task_id')
~~~

OpenSearch® answers with a **`task_id`** which is exported in our terminal, that can be used to monitor the registration process:

~~~bash
scalingo --app my-app run curl $SCALINGO_OPENSEARCH_URL/_plugins/_ml/tasks/$TASK_ID
~~~

Once the task is completed, retrieve the model ID:

~~~bash
MODEL_ID=$(scalingo --app my-app run curl $SCALINGO_OPENSEARCH_URL/_plugins/_ml/tasks/$TASK_ID | jq -r '.model_id')
~~~

OpenSearch® answers with a **`MODEL_ID`** which is exported in our terminal.

### Creating an Ingestion Pipeline

In OpenSearch®, an ingestion pipeline is a sequence of processing steps automatically applied to documents before they are indexed into OpenSearch®.

In the context of a RAG, the ingestion pipeline prepares raw data so it can be efficiently retrieved and used by a LLM.

In the following example, we create an ingestion pipeline that automatically generates embeddings from the `passage_text` field using the registered model and stores them in `passage_embedding` field. This enables OpenSearch® to perform semantic similarity searches on the indexed documents.

~~~bash
scalingo --app my-app run curl -X PUT $SCALINGO_OPENSEARCH_URL/_ingest/pipeline/rag-pipeline \
  -H "Content-Type: application/json" \
  -d '{
    "description": "Pipeline to generate embeddings",
    "processors": [
      {
        "text_embedding": {
          "model_id": "<MODEL_ID>",
          "field_map": {
            "passage_text": "passage_embedding"
          }
        }
      }
    ]
  }'
~~~

### Creating a Vector Index

A **vector index** stores embeddings generated from documents. These vectors represent the semantic meaning of the text. OpenSearch® can then compare vectors to retrieve the most similar documents.

{% note %}
Make sure the `dimension` matches the output size of your embedding model (384 for `all-MiniLM-L6-v2`).
{% endnote %}

~~~bash
scalingo --app my-app run curl -X PUT $SCALINGO_OPENSEARCH_URL/my-nlp-index \
  -H "Content-Type: application/json" \
  -d '{
    "settings": {
      "index": {
        "knn": true,
        "default_pipeline": "rag-pipeline"
      }
    },
    "mappings": {
      "properties": {
        "passage_text": {
          "type": "text"
        },
        "passage_embedding": {
          "type": "knn_vector",
          "dimension": 384
        }
      }
    }
  }'
~~~

### Ingesting Documents

You can now ingest documents into the index.

~~~bash
scalingo --app my-app run curl -X PUT $SCALINGO_OPENSEARCH_URL/my-nlp-index/_doc/1 \
  -H "Content-Type: application/json" \
  -d '{
    "passage_text": "OpenSearch is a powerful search engine for building AI applications."
  }'
~~~

The ingestion pipeline automatically generates embeddings for the `passage_text` field. Repeat this operation as many times as needed by changing the document ID in the endpoint URL.

## Querying the Vector Index

You can now perform a search query on your vector index.

The following request performs a **hybrid search** by combining:

- A **vector search** using the embedding model
- A **text search** using a traditional `match` query

Hybrid search combines semantic understanding and keyword matching. Vector search retrieves documents whose meaning is similar to the query, even if they do not contain the same words. The match query complements this by retrieving documents that contain the exact terms used in the query.

Each search query is wrapped in a `script_score` query to adjust its importance. This allows both semantic similarity and keyword relevance to influence the final ranking.

~~~bash
scalingo --app my-app run curl -X GET $SCALINGO_OPENSEARCH_URL/my-nlp-index/_search \
  -H "Content-Type: application/json" \
  -d '{
    "_source": {
      "excludes": [
        "passage_embedding"
      ]
    },
    "query": {
      "bool": {
        "filter": {
          "wildcard": {
            "id": "*1"
          }
        },
        "should": [
          {
            "script_score": {
              "query": {
                "neural": {
                  "passage_embedding": {
                    "query_text": "Hi world",
                    "model_id": "<MODEL_ID>",
                    "k": 100
                  }
                }
              },
              "script": {
                "source": "_score * 1.5"
              }
            }
          },
          {
            "script_score": {
              "query": {
                "match": {
                  "passage_text": "Hi world"
                }
              },
              "script": {
                "source": "_score * 1.7"
              }
            }
          }
        ]
      }
    }
  }'
~~~

This query returns the most relevant documents by combining semantic similarity
and keyword matching.

## Conclusion

You now have everything you need to build a basic RAG using OpenSearch® on Scalingo. From here, you can extend this setup by connecting it to an application or an
LLM to generate answers based on the retrieved context.

[opensearch-doc]: https://docs.opensearch.org/latest/ml-commons-plugin/pretrained-models
[cli-doc]: https://doc.scalingo.com/cli
[knn-search]: https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm
*[AI]: Artificial Intelligence
*[LLM]: Large Language Model
*[ML]: Machine Learning
*[RAG]: Retrieval-Augmented Generation 