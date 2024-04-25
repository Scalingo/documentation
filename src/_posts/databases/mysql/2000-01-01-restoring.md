---
title: Restoring Your Scalingo for MySQL® Addon From a Backup or From a Dump
nav: Restoring
modified_at: 2024-04-16 12:00:00
tags: databases mysql addon
index: 8
---

## Restoring From a Periodic Backup

{% warning %}
Restoring a database from a backup requires the database to be completely
stopped, hence causing an inevitable downtime.
{% endwarning %}

### Using the Command Line

#### From a One-Off Container

1. Follow the procedure to [access your MySQL® database from a one-off
   container]({% post_url databases/mysql/2000-01-01-accessing %}#using-a-one-off)
2. From the one-off command line, download and install the Scalingo command
   line tool to complete the one-off setup:
   ```bash
   install-scalingo-cli
   ```
3. Login to Scalingo:
   ```bash
   scalingo login
   ```
4. Still from the one-off, [download a backup]({% post_url databases/mysql/2000-01-01-backing-up %}#downloading-a-periodic-backup)
5. Uncompress the backup file:
   ```bash
   tar -xvzf <backup_file>
   ```
6. Restore the database from the uncompressed file, using the `mysql` command:
   ```bash
   mysql --user=<user> --password=<password> --host=<host> --port=<port> <dbname> < <uncompressed_file>
   ```
   With `user`, `password`, `host`, `port` and `dbname` from your original
   [connection URI]({% post_url databases/mysql/2000-01-01-connecting %}#understanding-the-connection-uri).

#### From Your Workstation

1. [Download a backup]({% post_url databases/mysql/2000-01-01-backing-up %}#downloading-a-periodic-backup)
2. Uncompress the backup file:
   ```bash
   tar -xvzf <backup_file>
   ```
3. [Open a DB tunnel]({% post_url databases/mysql/2000-01-01-accessing %}#using-our-command-line-tool)
   so you can access your database from your workstation
4. Restore the database from the uncompressed file, using the `mysql` command
   (you may have to install it on your workstation):
   ```bash
   mysql --user=<user> --password=<password> --host=127.0.0.1 --port=<port> <dbname> < <uncompressed_file>
   ```
   With `user`, `password` and `dbname` from your original connection URI and
   `port` depending on what you did (default is `10000`)

{% note %}
Restoring a backup is only available from the command line.
{% endnote %}


## Restoring From a Manual Backup

Manual backups are considered like any Periodic backup. Consequently, please
refer to the [documentation explaining how to restore from a Periodic backup](#restoring-from-a-periodic-backup).


## Restoring From a Dump

{% warning %}
Restoring a database from a dump requires the database to be completely
stopped, hence causing an inevitable downtime.
{% endwarning %}

### Using the Command Line

#### From a One-Off Container

1. Follow the procedure to [access your MySQL® database from a one-off
   container]({% post_url databases/mysql/2000-01-01-accessing %}#using-a-one-off)
2. From the one-off command line, download and install the Scalingo command
   line tool to complete the one-off setup:
   ```bash
   install-scalingo-cli
   ```
3. Login to Scalingo:
   ```bash
   scalingo login
   ```
4. Still from the one-off, retrieve a dump made previously
5. Restore the database from the dump file, using the `mysql` command:
   ```bash
   mysql --user=<user> --password=<password> --host=<host> --port=<port> <dbname> < <dump_file>
   ```
   With `user`, `password`, `host`, `port` and `dbname` from your original
   [connection URI]({% post_url databases/mysql/2000-01-01-connecting %}#understanding-the-connection-uri).

#### From Your Workstation

1. Make sure you have the dump you want to restore at hand
2. [Open a DB tunnel]({% post_url databases/mysql/2000-01-01-accessing %}#using-our-command-line-tool)
   so you can access your database from your workstation
3. Restore the database from the dump file, using the `mysql` command (you may
   have to install it on your workstation):
   ```bash
   mysql --user=<user> --password=<password> --host=127.0.0.1 --port=<port> <dbname> < <dump_file>
   ```
   With `user`, `password` and `dbname` from your original connection URI and
   `port` depending on what you did (default is `10000`)

{% note %}
Restoring from a dump is only available from the command line.
{% endnote %}
