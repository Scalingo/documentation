---
title: Deploying a RAG with OpenSearch®
logo: opensearch
category: ai
products:
  - Scalingo for OpenSearch®
  - OpenSearch® Dashboards
permalink: /tutorials/opensearch-rag
modified_at: 2026-03-06
---

OpenSearch® is an open-source search and analytics engine that supports
vector search through its **k-NN plugin**. This makes it possible to build
AI applications such as semantic search or Retrieval-Augmented Generation (RAG).

In this tutorial, we will build a simple **RAG pipeline** using OpenSearch® on
Scalingo and a HuggingFace model.

## Planning your Deployment

Before deploying your RAG pipeline, you need the following components:

- A **Scalingo for OpenSearch® addon** to store vector embeddings and run
  similarity searches.

- An **OpenSearch® Dashboards application** to interact with your cluster and
  execute API requests through Dev Tools.

- A **vector embedding model**, such as
  `huggingface/sentence-transformers/all-MiniLM-L6-v2`.

OpenSearch® on Scalingo already includes the **k-NN plugin**, which enables
vector search capabilities required for RAG applications.

## Deploying and Updating

To install or update OpenSearch Dashboard on Scalingo using the CLI or Terraform, you can check our documentation [here][opensearch-dashboard-scalingo]

## Setting Up Machine Learning in OpenSearch®

To use embedding models, OpenSearch® must allow model downloads and execution. Open Dev Tools in OpenSearch® Dashboards and configure the cluster to:

- allow external model downloads
- enable model execution on all nodes
- remove memory limits
- enable access control

~~~json
PUT _cluster/settings
{
  "persistent": {
    "plugins.ml_commons.only_run_on_ml_node": "false",
    "plugins.ml_commons.model_access_control_enabled": "true",
    "plugins.ml_commons.native_memory_threshold": "99"
  }
}
~~~

These parameters ensure the model can be correctly loaded and executed across
the cluster.




### Create a Model Group

Create a model group to organize your models.

~~~json
POST /_plugins/_ml/model_groups/_register
{
  "name": "rag-model-group",
  "description": "Model group for RAG embeddings"
}
~~~

The response will return a **model_group_id**. Keep this value for the next step.

~~~json
{
  "model_group_id": "<MODEL_GROUP_ID>"
}
~~~

### Register the Embedding Model

Next, register the embedding model. In this tutorial we use this model ( you can find other models on [OpenSearch Documentation](https://docs.opensearch.org/latest/ml-commons-plugin/pretrained-models)) : 

~~~
huggingface/sentence-transformers/all-MiniLM-L6-v2
~~~

Run the following request:

~~~json
POST /_plugins/_ml/models/_register
{
  "name": "huggingface/sentence-transformers/all-MiniLM-L6-v2",
  "version": "1.0.2",
  "model_group_id": "<MODEL_GROUP_ID>",
  "model_format": "TORCH_SCRIPT"
}
~~~

OpenSearch® will start downloading and registering the model. You can monitor the registration status with:

~~~json
GET /_plugins/_ml/tasks/<TASK_ID>
~~~

Once the task is completed, The response will contain the **model_id**, which will be required to build your ingestion pipeline.

Example:

~~~json
{
  "model_id": "<MODEL_ID>"
}
~~~

Keep this **model_id** for the next step.

### Creating an Ingestion Pipeline

Next, create an ingestion pipeline that will automatically generate embeddings
when documents are indexed.

~~~json
PUT _ingest/pipeline/rag-pipeline
{
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
}
~~~

### Creating a Vector Index

Create an index configured for vector search.

Make sure the `dimension` matches the output size of your embedding model
(384 for `all-MiniLM-L6-v2`).

~~~json
PUT my-nlp-index
{
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
}
~~~

### Ingesting Documents

You can now ingest documents into the index.

~~~json
PUT /my-nlp-index/_doc/1
{
  "passage_text": "OpenSearch is a powerful search engine for building AI applications."
}
~~~

The ingestion pipeline will automatically generate embeddings for the `passage_text` field.You can repeat this operation as many times as needed by changing the document ID in the endpoint.

## Querying the Vector Index

You can now perform a search query on your vector index.

The following request performs a **hybrid search** by combining:

- a **vector search** using the embedding model
- a **text search** using a traditional `match` query

The results are then re-ranked using `script_score`.

~~~json
GET /my-nlp-index/_search
{
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
}
~~~

This query returns the most relevant documents by combining semantic similarity
and keyword matching.

## Conclusion

You now have everything you need to build a basic RAG using OpenSearch® on Scalingo. From here, you can extend this setup by connecting it to an application or an
LLM to generate answers based on the retrieved context.


[dashboard]: https://dashboard.scalingo.com
[opensearch-dashboard-github]: https://github.com/Scalingo/opensearch-dashboards-scalingo
[opensearch-dashboard-scalingo]: https://doc.scalingo.com/databases/opensearch/guides/ingesting-logs/opensearch-dashboards
