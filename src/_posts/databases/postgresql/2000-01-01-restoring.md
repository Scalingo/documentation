---
title: Restoring Your Scalingo for PostgreSQL® Addon
nav: Restoring
modified_at: 2024-01-03 12:00:00
tags: databases postgresql addon
index: 8
---


## Restoring a Point-in-Time Recovery Backup

{% warning %}
Restoring a database using the Point-in-Time Recovery feature requires the
database to be completely stopped, hence causing an inevitable downtime.
{% endwarning %}

### Using the Database Dashboard

1. From your web browser, open your [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Click the **Backups** tab
3. Locate the **Point-in-Time Recovery** block
4. Pick a date and time
5. Click the **Restore Database** button

{% note %}
Restoring a PiTR backup is only available from the database dashboard.
{% endnote %}


## Restoring an On-Demand Backup

{% warning %}
Restoring a database using an On-Demand backup requires the database to be
completely stopped, hence causing an inevitable downtime.
{% endwarning %}

### Using the Command Line

#### From a One-Off Container

1. Follow the procedure to [access your PostgreSQL® database from a One-Off
   container]({% post_url databases/postgresql/2000-01-01-accessing %}#using-a-one-off)
2. From the One-Off command line, download and install the Scalingo command
   line tool to complete the One-Off setup:
   ```bash
   install-scalingo-cli
   ```
3. Login to Scalingo:
   ```bash
   scalingo login
   ```
4. Either [download a backup]({% post_url databases/postgresql/2000-01-01-backing-up %}#downloading-an-on-demand-backup),
   or [use a dump]({% post_url databases/postgresql/2000-01-01-backing-up %}#from-a-one-off-container)
   made previously
5. Uncompress the backup (this step is not necessary with a dump):
   ```bash
   tar -xvzf <archive>
   ```
6. Restore the database from the uncompressed file or from the dump, using the
   `pg_restore` command:
   ```bash
   pg_restore --clean --if-exists --no-owner --no-privileges --no-comments --dbname "${SCALINGO_POSTGRESQL_URL}" <dump_file>
   ```

#### From Your Workstation

1. Either [download a backup]({% post_url databases/postgresql/2000-01-01-backing-up %}#downloading-an-on-demand-backup),
   or [create a dump]({% post_url databases/postgresql/2000-01-01-backing-up %}#from-a-one-off-container)
2. Uncompress the backup (this step is not necessary with a dump):
   ```bash
   tar -xvzf <archive>
   ```
3. [Open a DB tunnel]({% post_url databases/postgresql/2000-01-01-accessing %}#using-our-command-line-tool)
   so you can access your database from your workstation
4. Adjust the [connection URI]({% post_url databases/postgresql/2000-01-01-connecting %}#understanding-the-connection-uri):
   ```bash
   export SCALINGO_DATABASE_URL="postgresql://<user>:<password>@127.0.0.1:<port>/<dbname>"
   ```
   With `user`, `password` and `dbname` from your original connection URI and
   `port` depending on what you did (default is `10000`)
5. Restore the database from the uncompressed file or from the dump, using the
   `pg_restore` command (you may have to install it):
   ```bash
   pg_restore --clean --if-exists --no-owner --no-privileges --no-comments --dbname "${SCALINGO_DATABASE_URL}" <dump_file>
   ```

{% note %}
Restoring an On-Demand backup is only available from the command line.
{% endnote %}


## Restoring a Manual Backup

Manual backups are considered like any On-Demand backup. Consequently, please
refer to the [documentation explaining how to restore an On-Demand backup](#restoring-an-on-demand-backup).


## Restoring a Dump

Dumps are considered like any On-Demand backup. Consequently, please refer to
the [documentation explaining how to restore an On-Demand backup](#restoring-an-on-demand-backup).
