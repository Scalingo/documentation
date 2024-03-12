---
title: Restoring Your Scalingo for MySQL® Addon
nav: Restoring
modified_at: 2024-03-05 12:00:00
tags: databases mysql addon
index: 9
---

## Restoring an On-Demand Backup

{% warning %}
Restoring a database using an On-Demand backup requires the database to be
completely stopped, hence causing an inevitable downtime.
{% endwarning %}

### Using the Command Line

#### From a One-Off Container

1. Follow the procedure to [access your MyQL® database from a One-Off
   container]({% post_url databases/mysql/2000-01-01-accessing %}#using-a-one-off)
2. From the One-Off command line, download and install the Scalingo command
   line tool to complete the One-Off setup:
   ```bash
   install-scalingo-cli
   ```
3. Login to Scalingo:
   ```bash
   scalingo login
   ```
4. Either [download a backup]({% post_url databases/mysql/2000-01-01-backing-up %}#downloading-an-on-demand-backup),
   or [use a dump]({% post_url databases/mysql/2000-01-01-backing-up %}#from-a-one-off-container)
   made previously
5. Uncompress the backup (this step is not necessary with a dump):
   ```bash
   tar -xvzf <archive>
   ```
6. Restore the database from the uncompressed file or from the dump, using the
   `mysql` command:
   ```bash
   mysql --user=<user> --password=<password> --host=<host> --port=<port> <dbname> < <dump_file>
   ```
   With `user`, `password`, `host`, `port` and `dbname` from your original
   [connection URI]({% post_url databases/mysql/2000-01-01-connecting %}#understanding-the-connection-uri).

#### From Your Workstation

1. Either [download a backup]({% post_url databases/mysql/2000-01-01-backing-up %}#downloading-an-on-demand-backup),
   or [create a dump]({% post_url databases/mysql/2000-01-01-backing-up %}#from-a-one-off-container)
2. Uncompress the backup (this step is not necessary with a dump):
   ```bash
   tar -xvzf <archive>
   ```
3. [Open a DB tunnel]({% post_url databases/mysql/2000-01-01-accessing %}#using-our-command-line-tool)
   so you can access your database from your workstation
4. Restore the database from the uncompressed file or from the dump, using the
   `mysql` command (you may have to install it):
   ```bash
   mysql --user=<user> --password=<password> --host=127.0.0.1 --port=<port> <dbname> < <dump_file>
   ```
   With `user`, `password` and `dbname` from your original connection URI and
   `port` depending on what you did (default is `10000`)

{% note %}
Restoring an On-Demand backup is only available from the command line.
{% endnote %}


## Restoring a Manual Backup

Manual backups are considered like any On-Demand backup. Consequently, please
refer to the [documentation explaining how to restore an On-Demand backup](#restoring-an-on-demand-backup).


## Restoring a Dump

Dumps are considered like any On-Demand backup. Consequently, please refer to
the [documentation explaining how to restore an On-Demand backup](#restoring-an-on-demand-backup).
