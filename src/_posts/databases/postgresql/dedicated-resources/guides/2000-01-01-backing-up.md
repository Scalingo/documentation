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

There are different ways to dump (and restore) a PostgreSQL® database. We
generally advise to either:
- ???

### From Your Workstation

???


[cli]: {% post_url tools/cli/2000-01-01-start %}

[backup-policies]: {% post_url databases/about/2000-01-01-backup-policies %}
[backup-policies-pitr]: {% post_url databases/about/2000-01-01-backup-policies %}#continuous-backups
[backup-policies-pitr-window]: {% post_url databases/about/2000-01-01-backup-policies %}#restoring-a-backup

[database-dashboard]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard
