---
title: Restoring Your Scalingo for PostgreSQL® Dedicated Resources Database
nav: Restoring
modified_at: 2026-02-13 12:00:00
tags: databases postgresql dedicated
index: 6
---


Dedicated Resources PostgreSQL® databases are automatically backed up and can be
restored to a specific point in time within the backup retention period,
depending on your plan.

You can restore your database either from a managed
[Point-in-Time Recovery backup](#restoring-a-point-in-time-recovery-backup),
or from a [dump you previously created](#restoring-a-dump).


## Restoring a Point-in-Time Recovery Backup

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
5. Pick a date and time (**timezone is UTC**)
6. Make sure to check the **I understand that this action will permanently
   delete existing data and cannot be cancelled or undone once started.**
   checkbox
7. Validate by clicking the **Confirm** button

## Restoring a Dump

On Dedicated Resources, [dump][backing-up-dumping] restore is a client-managed operation.
You must connect to the database yourself and run standard PostgreSQL® tools
(`pg_restore`, `psql`).

{% warning %}
Restoring a database using a dump requires the database to be completely 
stopped, hence causing an inevitable downtime.
{% endwarning %}

You can run the restore from your local or development environment.
In both cases, you must configure the Dedicated Resources firewall to allow
connections from your chosen source before running the restore.

{% warning %}
Restoring a dump can overwrite existing data. Make sure you understand the
impact before running `pg_restore --clean`.
{% endwarning %}

### From Your Workstation

1. Make sure your source IP (or range) is allowlisted in the database firewall
   ```sh
   scalingo database-firewall-rules-add my-dedicated-db-id --cidr 203.0.113.0/24 --label "Office network"
   # or directly the public ip of the workstation:
   scalingo database-firewall-rules-add my-dedicated-db-id --cidr <public IP>/32 --label "My workstation"
   # wait for the database to be reachable from workstation
   ```
2. Get the database [connection URI][connection-uri]
   ```sh
   SCALINGO_DB_URL=$(scalingo --database my-dedicated-db-id env-get SCALINGO_POSTGRESQL_URL)
   ```
3. Restore the dump:
   ```sh
   pg_restore --clean --if-exists --no-owner --no-privileges --no-comments --dbname "${SCALINGO_DB_URL}" <dump_file>
   ```

[database-dashboard]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard
[connection-uri]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-connecting %}#getting-the-connection-uri
[backing-up-dumping]: {% post_url databases/postgresql/dedicated-resources/guides/2000-01-01-backing-up %}#dumping-the-database
