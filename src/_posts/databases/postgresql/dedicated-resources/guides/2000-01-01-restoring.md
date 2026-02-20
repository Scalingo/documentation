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

???

[database-dashboard]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard
