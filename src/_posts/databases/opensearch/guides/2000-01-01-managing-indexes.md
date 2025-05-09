---
title: Managing Indexes
nav: Managing Indexes
modified_at: 2025-05-05 12:00:00
tags: database addon opensearch
index: 20
---


OpenSearch® is a database engine designed to handle massive amount of data. To
do so, it relies on important concepts such as **indexes**, **shards** and
**replicas**. Understanding what they are and how they work together is crucial
to manage indexes efficiently, which is key to maintaining the performance and
scalability of your addon.\
OpenSearch® also comes with powerful features that help managing indexes and
keeping them in control. Leveraging them allows to ease maintenance work while
ensuring compliance with technical or legal requirements.\
Here are a few insights and options that might be worth considering.


## Understanding Indexes, Shards and Replicas

In OpenSearch®, an **index** designates a *thing* that holds all the documents
and data you want to analyze and search. It can be viewed as an organizational
container that stores documents.

**Shards** are the building blocks of an OpenSearch® index, each containing a
subset of the documents stored in the index. Splitting indexes this way, in
several shards, allows OpenSearch® to distribute data horizontally across the
different nodes of the cluster. An index is therefore a collection of shards
spread on multiple nodes.

This design gives OpenSearch® three major benefits:
- It allows OpenSearch® to handle enormous volumes of data that would not fit
  on a single server (scalability)
- It improves performances by processing search and indexing operations in
  parallel
- It adds fault tolerance, thanks to replicas.

There are two types of shards:
- **Primary** shards hold the original data. This is were data are written.
- **Replica** shards are read-only copies of the primary shards. Each replica
  shard is always located on a different node of the cluster, ensuring
  redundancy and high availability in case of a node failure.

Technically speaking, shards are Apache Lucene indexes. Theorically, each one
can contain a maximum of about 2.1 billion documents. OpenSearch® itself can
handle up to 4000 shards per cluster node!

### Choosing the Number of Shards

Choosing an appropriate number of shards **before** creating an index is
primordial for multiple reasons:
- It's quite hard to modify the number of primary shards of an index once it
  has been created
- The size of the shards has an impact on the database performances:
  - Splitting data into too many small shards causes resource waste and can
    cause performance issue, as well as out of memory errors.
  - On the other side, too large shards are simply inefficient
    performances-wise and are hard to recover in case of a failure.

Setting the number of shards also depends on your usecase. AWS officially
advises to stick to the following guidelines:
- Keep shard size between 10-30GiB when search latency is a key performance
  goal.
- Keep shard size between 30-50GiB for write intensive workflows such as
  log analytics.

Finally, all these considerations can be summarized by the following formula,
suggested by AWS. It allows to estimate the appropriate number of primary
shards:

```text
approximate number of primary shards = (source data + room to grow) × 1.1 / desired shard size
```

Make sure that the result doesn't create unnecessarily small shards. That would
be counter-productive!

The default configuration deployed with each Scalingo for OpenSearch® addon
asks the database to divide each index into three primary shards and to create
one replica of each shards, resulting in a theoric total of six shards being
used.

### Choosing the Number of Replicas

#### With Starter Plans

Since Starter plans only feature a single node, OpenSearch® is not able to
fulfill the **default** replica configuration. This results in OpenSearch®
returning a `yellow` health status for all user-created indexes: the data are
stored in three shards instead of six.

We are keeping these defaults on purpose for two main reasons:
- To emphasize the fact that your data are not replicated with Starter plans.
- To make your indexes ready for a possible future plan upgrade (switching
  to a Business plan).

If you don't plan on moving to a Business plan, or if you don't care about
replication, there is no benefit in setting the number of replicas to a value
above `0`.

#### With Business Plans

Business plans, on the other hand, are indeed able to replicate the data over
the cluster nodes. Therefore, user-created indexes should always all be
`green`.

Since OpenSearch® clusters provided by Scalingo feature three nodes, the number
of replicas should most probably be set between `0` and `3`, depending on the
replication level you want.


Here is an example request creating an index named `my-index` with two primary
shards and three replicas:

```json
PUT my-index
{
  "settings": {
    "index": {
      "number_of_shards": 2,
      "number_of_replicas": 3
    }
  }
}
```


## Using Index Templates

Index templates allows to initialize new indexes with predefined values for
settings, mappings, analyzers, shards, replicas, etc. If the name of the new
index matches one of the patterns of one of the templates, OpenSearch® applies
the template to the newly created index.

Leveraging this feature allows to prevent duplication of settings and therefore
avoids inconsistencies.

The following example creates an index template named `logs_template` and
applies it to any new index whose name matches the pattern `logs-*`. The newly
created index will use two primary shards and two replicas. It will also have
a mapping configured by default.

Here is an example request creating an index template named `logs_template`,
setting the number of shards and replicas to `2` for all new indexes which
name matches `logs-*`. The newly created index will also have a mapping.

```json
PUT _index_template/logs_template
{
  "index_patterns": ["logs-*"],
  "template": {
    "settings": {
      "number_of_shards": 2,
      "number_of_replicas": 2
    },
    "mappings": {
      "properties": {
        "timestamp": {
          "type": "date",
          "format": "yyyy-MM-dd HH:mm:ss"
        }
      }
    }
  }
}
```


## Using Time-Based Indexes

When dealing with time-based data such as logs, metrics, economic indicators or
even orders, a good practice generally consists in using time-based indexes,
like `something-2025.05.06`. The granularity of the name pattern is up to you:
it can be hours, days, weeks, or even months, depending on your usecase and the
amount of data you plan to ingest.

Using such a pattern to name indexes has multiple benefits:

- Capacity planning becomes more precise and easier. For example, if you know
  the average size of a document, and the number of documents you are
  ingesting per unit of time (e.g. 250 per hour), it becomes quite easy to
  estimate the size of the index for any unit of time. It also becomes easier
  to track the growth rate of the indexes over time.
- When using [index templates](#using-index-templates), it allows to update the
  number of primary shards of an index without having to reindex all data. For
  instance, if you are using a day-wise index created via an index template,
  any change applied to this template becomes effective the next day. Existing
  indexes on their side are left untouched.
- Deleting old data also becomes easier: time-based name allows to quickly
  identify which indexes are to be kept, and which are to be removed.
- It makes implementing [lifecycle policies](#implementing-index-state-management)
  easier. Here again, the naming convention makes things clear and pretty
  straightforward.


## Using Aliases

In OpenSearch®, an alias is like a nickname or a shortcut that points to one or
more indexes. It's a flexible and powerful way to manage how applications or
users access the documents stored in your database. By obfuscating the
underlying indexes, aliases create a simpler experience. For instance, instead
of querying a time-based index named `something-2025.05.06`, an application
could use an alias like `something-today` pointing to `something-2025.05.06`.

Since they abstract index names, aliases avoid downtime when transitioning
from an index to another. For example, if your application queries the database
via an alias named `something` pointing to `something-a`, switching to querying
`something-b` only consists in updating the alias. The queried name remains the
same and there is no need to update the application code. Moreover, the
operation is be completely transparent for the application. This logic also
applies when rotating time-based indexes.

Because an alias can point to multiple indexes, it can be used as an
aggregate of multiple indexes. For instance, an alias named `something-2024`
could point to `something-2024.01`, `something-2024.02`, `something-2024.03`,
etc. This allows to easily create sliding windows of data from the *n* previous
unit of time (e.g. `last-6-months`).

An alias can also be configured to be read-only or read-write, which can be
convenient to prevent data loss due to wrong processing.

Finally, an alias can be filtered based on multiple criterias (terms, dates,
time ranges, ...) to only expose a subset of the underlying indexes.

Here is an example of a request creating an alias named `logs-2-weeks`
aggregating the indexes `logs-week-32` and `logs-week-33`. This alias is
read-only (by default):

```json
POST _aliases
{
  "actions": [
    { "add": { "index": "logs-week-32", "alias": "logs-2-weeks" } },
    { "add": { "index": "logs-week-33", "alias": "logs-2-weeks" } }
  ]
}
```


## Implementing Index State Management

Index State Management (ISM) is a plugin that helps **automate routine
administrative tasks** by triggering actions based on conditions like index
age, size, or document count. ISM allows to create policies to automatically
manage actions such as index rollovers or deletions, tailored to your specific
needs.

Leveraging such a feature allows to keep indexes size under limits and avoids
keeping useless old data in your database. It's generally a good way to keep
your data under control and prevents indexes from growing indefinitely.

The following requests shows an example leveraging the
[rollover][opensearch-rollover-api] API to create a rollover policy for an
alias. This policy automatically creates a new index once the current one
contains at least one document. The new index is automatically named after the
first one (in this example, `log-001`, `log-002`, `log-003`, etc.). The new
index is also added to the alias and is set to be the one writable, so that
adding a new document to the alias actually adds it to the newly created index.
The previous index is updated to be marked as non-writable for the alias.

```json
# Creates the policy:

PUT _plugins/_ism/policies/rollover_policy
{
  "policy": {
    "description": "Example rollover.",
    "default_state": "rollover",
    "states": [
      {
        "name": "rollover",
        "actions": [
          {
            "rollover": {
              "min_doc_count": "1"
            }
          }
        ],
        "transitions": []
      }
    ],
    "ism_template": {
      "index_patterns": ["log*"],
      "priority": 100
    }
  }
}


# Creates an index template and link the policy:

PUT _index_template/ism_rollover
{
  "index_patterns": ["log*"],
  "template": {
    "settings": {
      "plugins.index_state_management.rollover_alias": "log"
    }
  }
}


# Creates the first index and the `log` alias:

PUT log-001
{
  "aliases": [
    "log": {
      "is_write_index": true
    }
  ]
}
```

## Optimizing Mappings and Data Types

- Avoids dynamic mappings (unless necessary)
- Use appropriate types (such as `text` or `date`. Full list available here: FIXME)
- Flatten deeply nested structures when possible


## Reindexing Data When Needed

- When settings or mappings are updated
- Reindex into a new index with updated templates and structure


[opensearch-rollover-api]: https://docs.opensearch.org/docs/latest/api-reference/index-apis/rollover/
