---
title: Restoring Your Scalingo for OpenSearch® Addon
nav: Restoring
modified_at: 2025-05-05 12:00:00
tags: databases opensearch addon
index: 6
---


{% note %}
Please carefully read our [backup policies]({% post_url databases/2000-01-01-backup-policies %})
for details about backups retention and important considerations regarding
backups and restorations.
{% endnote %}


## Understanding the Restoration Process

Even if the platform uses OpenSearch's [Snapshot APIs][opensearch-api-snapshot]
internally to create backups and restore them, please remember that these APIs
are not exposed to users.

Here are a few facts that might be worth having in mind when restoring a
Scheduled or a Manual backup:
- OpenSearch® recreates the indexes as they existed at the time of the backup,
  which means restored indexes overwrite their current state (content,
  mappings) with the state recorded in the backup.
- Indexes created after the backup are kept untouched by the restore process.
- If an index already exists and is open, and if its internal UUID does not
  match the backup's index UUID, the restore process fails with an error.
- In the specific case where the existing index matches the backup (same UUID),
  the data and mappings are replaced without errors.

These behaviors are expected and correspond to OpenSearch® nominal operations.
They are not specifics of Scalingo for OpenSearch®.


## Restoring a Scheduled Backup

{% note %}
Restoring a Scheduled backup is only available from the database dashboard.
{% endnote %}

1. From your web browser, open your [database dashboard][db-dashboard]
2. Click the Backups tab
3. Locate the Backups block
4. In the list of available backups, locate the one you want to restore
5. Click the corresponding **Restore** button
6. Please carefully read the warnings in the popup window
7. Make sure to check the **I understand that this action will permanently
   delete existing data and cannot be cancelled or undone once started.**
   checkbox
8. Validate by clicking the **Confirm** button


## Restoring a Manual Backup

{% note %}
Restoring a Manual backup is only available from the database dashboard.
{% endnote %}

Manual backups are considered like any Scheduled backup. Consequently, please
refer to the documentation explaining [how to restore a Scheduled backup](#restoring-a-scheduled-backup).


## Restoring a Dump

{% note %}
Restoring a dump can only be done from your workstation.
{% endnote %}

1. Make sure you have successfully installed
   [elasticsearch-dump][elasticsearch-dump] on your workstation

2. [Create a dump][backup-dump] or make sure you have one at your disposal

3. [Open a DB tunnel][accessing-db-tunnel] so you can access your database from
   your workstation

4. Create a local variable to store the local [connection
   URI][connecting-understand-uri]:
   ```bash
   export SCALINGO_DB_URL="http://<user>:<password>@127.0.0.1:<port>"
   ```
   With `user` and `password` from your original connection URI and
   `port` depending on what you did (default is `10000`)

5. Restore the database from the dump, using the `elasticdump` command:
   ```bash
   # Restoring analyzers:
   elasticdump \
       --input=<index>-analyzers.json \
       --output="${SCALINGO_DB_URL}/<index>" \
       --type=analyzer

   # Restoring mappings:
   elasticdump \
       --input=<index>-mappings.json \
       --output="${SCALINGO_DB_URL}/<index>" \
       --type=mapping

   # Restoring data:
   elasticdump \
       --input=<index>-data.json \
       --output="${SCALINGO_DB_URL}/<index>" \
       --type=data
   ```
   With `index` being the name of the index to restore.

   Please adjust the above commands to fit your needs. For instance, you may be
   interested in restoring only the data, or in restoring the settings, aliases
   or templates of the index (please refer to [the official
   documentation][elasticsearch-dump] to get an exhaustive list of values to
   use with the `--type` flag).

   It's also possible to restore an index directly from another accessible
   OpenSearch® database. To do so, set the `--input` flag value to the
   connection URI of the source OpenSearch® database, like so:
   ```bash
   elasticdump \
       --input=<source_db_uri>/<index> \
       --output="${SCALINGO_DB_URL}/<index>" \
       --type=data
   ```
   With `index` being the name of the index to restore and `source_db_uri`
   being the connection URI of the other accessible OpenSearch® database.

6. The elasticsearch-dump project also provides a convenient tool called
   `multielasticdump` to restore multiple indexes at once:
   ```bash
   multielasticdump \
       --direction=load\
       --input=<dump_dir> \
       --output="${SCALINGO_DB_URL}" \
       --match=<index_regexp> \
       --includeType=<types>
   ```
   With `dump_dir` being the source directory, where all dump files are stored,
   `index_regexp` being a regular expression to filter which indexes should be
   restored and `types` being a comma-separated list of types to restore.


[opensearch-api-snapshot]: https://docs.opensearch.org/docs/latest/api-reference/snapshots/index/
[elasticsearch-dump]: https://github.com/elasticsearch-dump/elasticsearch-dump

[db-dashboard]: {% post_url databases/about/2000-01-01-database-dashboard %}
[opensearch-limitations-backup]: {% post_url databases/opensearch/about/2000-01-01-limitations %}#affecting-backups-and-restorations
[accessing-db-tunnel]: {% post_url databases/opensearch/getting-started/2000-01-01-accessing %}#using-our-command-line-tool
[connecting-understand-uri]: {% post_url databases/opensearch/getting-started/2000-01-01-connecting %}#understanding-the-connection-uri
[backup-dump]: {% post_url databases/opensearch/guides/2000-01-01-backing-up %}#dumping-indexes
