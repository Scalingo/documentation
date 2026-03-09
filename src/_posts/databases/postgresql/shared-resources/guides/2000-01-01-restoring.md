---
title: Restoring Your Scalingo for PostgreSQL® Shared Resources Database addon
nav: Restoring
modified_at: 2024-12-10 00:00:00
tags: databases postgresql addon
index: 6
---

## Restoring a Point-in-Time Recovery Backup

{% warning %}
- Restoring a database using the Point-in-Time Recovery feature requires the
  database to be completely stopped, causing an inevitable downtime.
- Restoring a Point-in-Time Recovery backup resets the continuous backup
  timeline, meaning you won't be able to restore from an earlier point in time.
{% endwarning %}

### Using the Database Dashboard

1. From your web browser, open your [database dashboard][database-dashboard]
2. Click the **Backups** tab
3. Locate the **Point-in-Time Recovery** block
3. Click the **Start a PiTR** button
4. Pick a date and time (**timezone is UTC**)
5. Make sure to check the **I understand that this action will permanently
   delete existing data and cannot be cancelled or undone once started.**
   checkbox
6. Validate by clicking the **Confirm** button

{% note %}
Restoring a PiTR backup is only available from the database dashboard.
{% endnote %}


## Restoring a Scheduled Backup

{% warning %}
Restoring a database using a Scheduled backup requires the database to be
completely stopped, hence causing an inevitable downtime.
{% endwarning %}

### Using the Command Line

#### From a One-Off Container

1. Follow the procedure to [access your PostgreSQL® database from a one-off
   container][accessing-one-off]
2. From the one-off command line, download and install the Scalingo command
   line tool to complete the one-off setup:
   ```bash
   install-scalingo-cli
   ```
3. Login to Scalingo:
   ```bash
   scalingo login
   ```
4. Either [download a backup][backing-up-downloading], or
   [use a dump][backing-up-one-off] made previously
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

1. Either [download a backup][backing-up-downloading], or
   [create a dump][backing-up-one-off]
2. Uncompress the backup (this step is not necessary with a dump):
   ```bash
   tar -xvzf <archive>
   ```
3. [Open a DB tunnel][accessing-cli]
   so you can access your database from your workstation
4. Adjust the [connection URI][connecting-uri]:
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
Restoring a Scheduled backup is only available from the command line.
{% endnote %}


## Restoring a Manual Backup

Manual backups are considered like any Scheduled backup. Consequently, please
refer to the [documentation explaining how to restore a Scheduled backup](#restoring-a-scheduled-backup).


## Restoring a Dump

Dumps are considered like any Scheduled backup. Consequently, please refer to
the [documentation explaining how to restore a Scheduled backup](#restoring-a-scheduled-backup).


[database-dashboard]: {% post_url databases/postgresql/shared-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard
[accessing-one-off]: {% post_url databases/postgresql/shared-resources/getting-started/2000-01-01-accessing %}#using-a-one-off
[accessing-cli]: {% post_url databases/postgresql/shared-resources/getting-started/2000-01-01-accessing %}#using-our-command-line-tool
[connecting-uri]: {% post_url databases/postgresql/shared-resources/getting-started/2000-01-01-connecting %}#understanding-the-connection-uri
[backing-up-downloading]: {% post_url databases/postgresql/shared-resources/guides/2000-01-01-backing-up %}#downloading-a-scheduled-backup
[backing-up-one-off]: {% post_url databases/postgresql/shared-resources/guides/2000-01-01-backing-up %}#from-a-one-off-container
