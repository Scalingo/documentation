---
title: Restoring Your Scalingo for MySQL® Dedicated Resources Database
nav: Restoring
modified_at: 2026-10-21 00:00:00
tags: databases mysql dedicated
index: 7
---


Scalingo for MySQL® Dedicated Resources databases are automatically backed up.
Point-in-time recovery (PITR) lets you restore your database to a specific point
within your plan's [Recovery Window][recovery-window].

You can restore your database either from a managed
[continuous backup](#restoring-from-a-continuous-backup),
or from a [customer-provided dump](#restoring-from-a-customer-provided-dump).


## Restoring from a continuous backup

Point-in-Time Recovery is a fully managed restore operation available from the
database dashboard.

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
4. Click the **Start a PiTR** button
5. Pick a timezone, then a date and time (**default timezone is your browser timezone**)
6. Make sure to check the **I understand that this action will permanently
   delete existing data and cannot be cancelled or undone once started.**
   checkbox
7. Validate by clicking the **Confirm** button

## Restoring from a customer-provided dump

On Dedicated Resources, [dump][backing-up-dumping] restore is a client-managed operation.
You must connect to the database yourself and run standard MySQL® tools
(`mysql`).

{% warning %}
Restoring a dump over an existing database requires application downtime.
Stop application access to the database until the restore is complete.
{% endwarning %}

You can run the restore from your local or development environment.
In both cases, you must configure the Dedicated Resources firewall to allow
connections from your chosen source before running the restore.

{% warning %}
Restoring a dump can overwrite existing data. Make sure you understand the
impact before importing the dump.
{% endwarning %}

### From Your Workstation

1. Make sure your source IP (or range) is allowlisted in the database firewall
   ```sh
   scalingo --database my-dedicated-db-id database-firewall-rules-add --cidr 203.0.113.0/24 --label "Office network"
   # or directly the public ip of the workstation:
   scalingo --database my-dedicated-db-id database-firewall-rules-add --cidr <public IP>/32 --label "My workstation"
   # wait for the database to be reachable from workstation
   ```
2. Get the database [connection URI][connection-uri]
   ```sh
   scalingo --database my-dedicated-db-id env-get SCALINGO_MYSQL_URL
   ```
3. Restore the dump:
   ```sh
   mysql --user=<user> --password --host=<hostname> --port=<port> --ssl-mode=REQUIRED <dbname> < dump.sql
   ```

   Use the user, hostname, port and database name from the connection URI.
   Enter the database password when prompted.

[database-dashboard]: {% post_url databases/mysql/dedicated-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-mysql-dashboard
[connection-uri]: {% post_url databases/mysql/dedicated-resources/getting-started/2000-01-01-connecting %}#getting-the-connection-uri
[backing-up-dumping]: {% post_url databases/mysql/dedicated-resources/guides/2000-01-01-backing-up %}#dumping-the-database

[recovery-window]: {% post_url databases/about/2000-01-01-backup-policies %}#recovery-window-for-pitr
