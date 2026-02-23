---
title: Restoring Your Scalingo for PostgreSQL® Dedicated Resources Database
nav: Restoring
modified_at: 2026-02-13 12:00:00
tags: databases postgresql dedicated
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

## Restoring a Dump

On Dedicated Resources, dump restore is a client-managed operation.
You must connect to the database yourself and run standard PostgreSQL® tools
(`pg_restore`, `psql`).

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
