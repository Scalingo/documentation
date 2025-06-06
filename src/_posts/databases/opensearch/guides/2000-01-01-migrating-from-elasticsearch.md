---
title: Migrating From Elasticsearch®
nav: Migrating From Elasticsearch®
modified_at: 2025-06-06 12:00:00
tags: addon database opensearch elasticsearch migration migrate migrating
index: 40
---


## Planning the Migration

The OpenSearch® project started as a fork of Elasticsearch `7.10.2`. As such,
one goal of the project is to provide wire compatibility with the latest
open-source version of Elasticsearch® (`7.10.2`). This backwards compatibility
eases the migration process from Elasticsearch® to OpenSearch®: existing
clients, connectors, libraries and APIs should work the same way.

{% note %}
While this layer of compatibility is ensured between Elasticsearch® `7.10.2`
and OpenSearch `2.19.x`, we can't guarantee it will still exist in future
releases of OpenSearch®, such as `3.x`.
{% endnote %}

The following table shows the different migration paths to Scalingo for
OpenSearch® `2.19.x`. **The goal is to first upgrade to Elasticsearch®
`7.10.2`, and then to migrate to OpenSearch®**. This step is required to ensure
the highest level of compatibility and avoid bad surprises. Depending on your
case, you may need to follow multiple steps before reaching the last one.

Depending on the amount of data to migrate, each step can take significant time
to complete. Make sure to proceed with care, preferably when your app is less
prone to high traffic, or during a planned downtime.

| Elasticsearch® Version | Migration Path                                     |
| ---------------------- | -------------------------------------------------- |
| < `6.8.23`             | Upgrade to `6.8.23`                                |
| = `6.8.23`             | [Reindex indexes in version 5](#reindexing-5x-indexes). Then upgrade to `7.10.2` |
| < `7.10.2`             | [Reindex indexes in version 5](#reindexing-5x-indexes). Then upgrade to `7.10.2` |
| = `7.10.2`             | [Dump and restore](#dumping-and-restoring) indexes |


## Reindexing 5.x Indexes

Elastisearch® databases usually offer a good level of backwards compatibility,
allowing indexes created with a major version `x` to still be readable with
version `x+1`. For instance, Elasticsearch® 6 can read indexes created in
version 5.

Scalingo for OpenSearch® addons being based on Elasticsearch 7, [they are
only compatible with Elasticsearch® indexes version 6.0 and
above][elastic-breaking-changes-6-7].

Consequently, if your Elasticsearch® database contains indexes version 5 or
below, you will have to first reindex them to a more recent version.

### Identifying Old Indexes

The following command lists the existing indexes, along with their version,
thus allowing to identify old indexes:

```bash
curl --silent -X GET "<elasticsearch_url>/_all/_settings?human" \
    | jq -r 'to_entries[] \ | "\(.key) - \(.value.settings.index.version.created_string)"'
```
With `elasticsearch_url` being the URL of the source Elasticsearch® database
you want to migrate from.

The output should look like this:

```text
logs-2025.05 - 7.10.2
logs-2025.04 - 7.10.2
logs-2025.03 - 7.10.2
logs-2025.02 - 7.10.2
logs-2025.01 - 7.10.2
logs-2024.12 - 6.8.23
...
logs-2022.12 - 5.6.16
...
```

### Reindexing

Reindexing from Elasticsearch® 5.x to 6.x requires careful planning because
Elasticsearch® 6 introduced [breaking changes][elastic-breaking-changes-5-6]
and strict index compatibility rules. There are also some breaking changes from
`6.0` to `6.8`.

To reindex an old index, we suggest to leverage the [**`reindex`**
API][elastic-reindex], like so:

```json
POST _reindex
{
  "source": {
    "index": "old-index"
  },
  "dest": {
    "index": "new-index"
  }
}
```

Here are a few suggestions and advises before you proceed:

- Read the changelogs provided by Elastic®, identify the (breaking) changes
  that apply to your case and plan how to handle them.
- Create your new indexes with updated mappings, analyzers, tokenizers, etc. to
  ensure compatibility with version 6.x indexes (see [Breaking
  Changes][elastic-breaking-changes] for further details).
- Use the `script` option of the [`reindex` API][elastic-reindex] to transform
  your existing indexes into something compatible with Elasticsearch® 6
  indexes. Scripts allow to add or remove fields, and they also allow to change
  documents' metadata, such as `_type`, `_index` or `_id`.

  The following basic example uses such a script to store the original `_type`
  of the document to `_source.type`, and then update the type of the document
  to `_doc`.

  ```json
  POST _reindex
  {
    "source": {
      "index": "old-index"
    },
    "dest": {
      "index": "new-index"
    },
    "script": {
      "lang": "painless",
      "source": """
        ctx._source.type = ctx._type;
        ctx._type = '_doc';
      """
    }
  }
  ```
- Make sure you have enough storage space, as indexes are duplicated during the
  process.
- Test your changes, ideally in a staging environment. Make sure to validate
  your applications are still able to query the new updated indexes.


## Dumping and Restoring

Once your Elasticsearch® database is running version `7.10.2`, and that all
your indexes have been successfully migrated to at least version `6.x`, all the
prerequisites are fulfilled.

1. (optional) Make the indexes you want to migrate read-only to prevent any
   additional writes:
   ```json
   PUT <index_name>/_settings
   {
     "index.blocks.write" : "false"
   }
   ```
   When doing so, please keep in mind that the dumped settings contain
   instructions to make the restored index read-only. This will likely prevent
   the restoration process to inject the data back in your index!

2. [Dump the indexes][opensearch-dump] you want to migrate. Depending on your
   plans, you may use `elasticdump` to migrate indexes one by one or
   `multielasticdump` for a batch process.

3. (optional) Adjust the dumps or create the destination indexes to suit your
   needs. For example, you may want to change some index settings such as the
   number of primary shards or replicas. You may also want to setup some new
   mappings, etc.

4. [Restore the indexes][opensearch-restore] to the destination OpenSearch®
   database, using `elasticdump` or `multielasticdump`.

5. (optional) If your source indexes ingested data during the process, you may
   want to give the whole process another go until the gap is filled.

6. (optional) If you have imported indexes in version 6, they are read-only.
   You may want to reindex them to version 7 to make them writable. The process
   and logic are the same than the one described
   [above](#reindexing-5x-indexes).


[elastic-breaking-changes-6-7]: https://www.elastic.co/guide/en/elasticsearch/reference/7.10/breaking-changes-7.0.html#_indices_created_before_7_0
[elastic-breaking-changes-5-6]: https://www.elastic.co/guide/en/elasticsearch/reference/6.8/breaking-changes-6.0.html
[elastic-reindex]: https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-reindex

[opensearch-dump]: {% post_url databases/opensearch/guides/2000-01-01-backing-up %}#dumping-indexes
[opensearch-restore]: {% post_url databases/opensearch/guides/2000-01-01-restoring %}#restoring-a-dump

