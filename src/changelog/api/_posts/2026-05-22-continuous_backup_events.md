---
modified_at: 2026-05-22 10:00:00
title: "New Database Continuous Backup Events"
---

Three new event types have been added to monitor continuous backups for
Point-in-Time Recovery (PiTR):

- `database_continuousbackup_healthy`: Point-in-time recovery is available and
  restore points are up to date
- `database_continuousbackup_delayed`: The latest restorable point is more than
  12 hours behind
- `database_continuousbackup_stale`: The latest restorable point is more than
  24 hours behind

These events can be used to create notifiers that alert you when continuous
backup health changes.

More information about events and notifiers in the
[documentation]({% post_url platform/app/2000-01-01-notifiers %}).
