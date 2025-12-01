---
modified_at: 2025-12-01 18:00:00
title: "New Database Backup Events"
---

Two new event types have been added to monitor database backup operations:

- `database_backup_succeeded`: A database backup has been successfully completed
- `database_backup_failed`: A database backup has failed

These events can be used to create notifiers that alert you when backup operations
complete or fail.

More information about events and notifications in the [documentation]({% post_url platform/app/2000-01-01-notification %}).
