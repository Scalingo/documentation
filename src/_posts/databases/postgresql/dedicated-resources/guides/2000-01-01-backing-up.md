---
title: Backing Up Your Scalingo for PostgreSQL® Dedicated Resources Database
nav: Backing Up
modified_at: 2026-02-13 12:00:00
tags: databases postgresql dedicated how-to
index: 5
---


Scalingo for PostgreSQL® Dedicated Resources Databases include automated and
managed backups so you don't have to worry about them.

Dedicated Resources databases come with [continuous backups][backup-policies-pitr] (Point-in-Time Recovery), with a recovery window ranging from 7 to 30 days depending on your database [service class][backup-policies-pitr-window].

{% note %}
**Please carefully read our [backup policies][backup-policies] for details
about backups retention and important considerations regarding backups.**
{% endnote %}


## Point-in-Time Recovery Backups

### Creating a Point-in-Time Recovery Backup

Point-in-Time Recovery backups are automatically created by the platform.

### Configuring Point-in-Time Recovery Backups

You have nothing to do to be able to use the Point-in-Time Recovery mechanism.


## Dumping the Database

On Dedicated Resources, dumps are client-managed operations.
You must connect to the database yourself and run standard PostgreSQL® tools
(`pg_dump`, `pg_dumpall`, `pg_restore`).

You can run the dump from your local or development environment. 
In both cases, you must configure the Dedicated Resources firewall to allow
connections from your chosen source before running the dump.

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
3. Create the dump:
   ```sh
   pg_dump --clean --if-exists --format c --dbname "${SCALINGO_DB_URL}" --no-owner --no-privileges --no-comments --exclude-schema 'information_schema' --exclude-schema '^pg_*' --file dump.pgsql
   ```


[cli]: {% post_url tools/cli/2000-01-01-start %}

[backup-policies]: {% post_url databases/about/2000-01-01-backup-policies %}
[backup-policies-pitr]: {% post_url databases/about/2000-01-01-backup-policies %}#continuous-backups
[backup-policies-pitr-window]: {% post_url databases/about/2000-01-01-backup-policies %}#restoring-a-backup

[database-dashboard]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard
[connection-uri]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-connecting %}#getting-the-connection-uri
