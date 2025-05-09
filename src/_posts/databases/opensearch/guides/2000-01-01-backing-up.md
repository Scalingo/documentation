---
title: Backing Up Your Scalingo for OpenSearch® Addon
nav: Backing Up
modified_at: 2025-05-05 12:00:00
tags: databases opensearch addon
index: 5
---


{% note %}
Please carefully read our [backup policies]({% post_url databases/2000-01-01-backup-policies %})
for details about backups retention and important considerations regarding
backups and restorations.
{% endnote %}


## Understanding the Backup Processes

Starter and Business plans of Scalingo for OpenSearch® include automated and
managed backups so you don't have to worry about them.

We use [Scheduled backups](#understanding-scheduled-backups) to create the
automated ones. [Manual backups](#understanding-manual-backups) are also
available for these plans.

Both Scheduled and Manual backups capture a point-in-time state of one or more
indexes, including settings, mappings, and data. They are stored in a remote
object storage only accessible by Scalingo.

When dealing with backups, please keep in mind that OpenSearch®'s
[Snapshot APIs][opensearch-api-snapshot] are not available.


## Scheduled Backups

### Creating a Scheduled Backup

Scheduled backups are automatically enabled and created by the platform when
using a Starter or a Business plan.

### Configuring Scheduled Backups

By default, Scheduled backups are done around 1:00 AM Central European Time
(CET or UTC+0100). This time can be modified.

{% note %}
The scheduled time is not strongly enforced: it might get delayed depending on
the workload on our infrastructure.
{% endnote %}

#### Using the Database Dashboard

1. From your web browser, open your [database dashboard][db-dashboard]
2. Click the **Backups** tab
3. Locate the **Backup schedule** block
4. Click the **Schedule** button
5. Make sure to check the **I want to enable scheduled backups** checkbox
6. Pick an hour (**timezone is UTC**)
7. Validate by clicking the **Update** button

#### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, configure the time of backup:
   ```bash
   scalingo --app my-app --addon opensearch backups-config --schedule-at "<hour> <timezone>"
   ```
   With `hour` being an integer between 0-23 (specifying minutes is currently
   not supported) and `timezone` being optional (default is `UTC`).\
   In this example, we ask the platform to create the backup at ~06:00
   Europe/Paris:
   ```bash
   scalingo --app my-app --addon opensearch backups-config --schedule-at "6 Europe/Paris"
   ```
   The output should look like this:
   ```text
   -----> Periodic backups will be done daily at 6:00 CEST
   ```

### Downloading a Scheduled Backup

{% note %}
It's not possible to download a Scheduled backup.\
Please see [Dumping Indexes](#dumping-indexes) for further guidance.
{% endnote %}


## Manual Backups

### Creating a Manual Backup

#### Using the Database Dashboard

1. From your web browser, open your [database dashboard][db-dashboard]
2. Click the **Backups** tab
3. Locate the **Backups** block
4. Click the **Trigger manual backup** button

#### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. Ask the platform to backup the database:
   ```bash
   scalingo --app my-app --addon opensearch backups-create
   ```
   After a while, the output should look like this:
   ```text
   -----> Backup successfully finished
   ```

### Downloading a Manual Backup

{% note %}
It's not possible to download a Manual backup.\
Please see [Dumping Indexes](#dumping-indexes) for further guidance.
{% endnote %}


## Dumping Indexes

OpenSearch® does not provide any official tool to dump the content of a
database. However, the open source community has created very useful tools to
fill this gap. The [elasticsearch-dump][elasticsearch-dump] project provides
two of them: `elasticdump` and `multielasticdump`. We usually
advise to rely on them to dump indexes from an OpenSearch® database to a the
workstation local storage or to another OpenSearch® database.

For more comprehensive help about these tools, please refer to [the official
documentation][elasticsearch-dump].

{% note %}
- Dumping OpenSearch® indexes can only be done from your workstation.
- Please make sure the workstation from which you are conducting the operations
  has enough storage space!
{% endnote %}

### From Your Workstation

1. Make sure you have successfully installed
   [elasticsearch-dump][elasticsearch-dump] on your workstation
2. [Open a DB tunnel][accessing-db-tunnel] so you can access your database from
   your workstation
3. Create a local variable to store the local [connection
   URI][connecting-understand-uri]:
   ```bash
   export SCALINGO_DB_URL="http://<user>:<password>@127.0.0.1:<port>"
   ```
   With `user` and `password` from your original connection URI and
   `port` depending on what you did (default is `10000`)
4. Run the following commands to create a dump of a single index, including
   analyzers, mappings, and data:
   ```bash
   # Dump analyzers:
   elasticdump \
       --input="${SCALINGO_DB_URL}/<index>" \
       --output=<index>-analyzers.json \
       --type=analyzer

   # Dump mappings:
   elasticdump \
       --input="${SCALINGO_DB_URL}/<index>" \
       --output=<index>-mappings.json \
       --type=mapping

   # Dump data:
   elasticdump \
       --input="${SCALINGO_DB_URL}/<index>" \
       --output=<index>-data.json \
       --type=data
   ```
   With `index` being the name of the index you want to dump.

   Please adjust the above commands to fit your needs. For instance, you may be
   interested in dumping only the data, or in dumping the settings, aliases or
   templates of the index (please refer to [the official
   documentation][elasticsearch-dump] to get an exhaustive list of values to
   use with the `--type` flag).

   It's also possible to dump an index directly to another accessible
   OpenSearch® database. To do so, set the `--output` flag value to the
   connection URI of the destination OpenSearch® database, like so:
   ```bash
   elasticdump \
       --input="${SCALINGO_DB_URL}/<index>" \
       --output=<destination_db_uri>/<index> \
       --type=data
   ```
   With `index` being the name of the index to dump and `destination_db_uri`
   being the connection URI of the destination OpenSearch® database.
5. The elasticsearch-dump project also provides a convenient tool called
   `multielasticdump` to create a dump of multiple indexes at once:
   ```bash
   multielasticdump \
       --direction=dump\
       --input="${SCALINGO_DB_URL}" \
       --output=<dump_dir> \
       --match=<index_regexp> \
       --includeType=<types>
   ```
   With `dump_dir` being the destination directory, where all files are
   stored, `index_regexp` being a regular expression to filter which indexes
   should be dumped and `types` being a comma-separated list of types to
   dump.


[opensearch-api-snapshot]: https://docs.opensearch.org/docs/latest/api-reference/snapshots/index/
[elasticsearch-dump]: https://github.com/elasticsearch-dump/elasticsearch-dump

[cli]: {% post_url platform/cli/2000-01-01-start %}
[db-dashboard]: {% post_url databases/about/2000-01-01-database-dashboard %}
[db-backup-policies]: {% post_url databases/2000-01-01-backup-policies %}
[accessing-one-off]: {% post_url databases/opensearch/getting-started/2000-01-01-accessing %}#using-a-one-off
[accessing-db-tunnel]: {% post_url databases/opensearch/getting-started/2000-01-01-accessing %}#using-our-command-line-tool
[connecting-understand-uri]: {% post_url databases/opensearch/getting-started/2000-01-01-connecting %}#understanding-the-connection-uri
