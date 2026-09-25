---
modified_at: 2026-09-18 00:00:00
title: "New Database Maintenance Missed Event"
---

A new event has been added to help you understand when a maintenance has been missed and is postponed to a later maintenance window. It completes the three other events that were already in place.

- `database_maintenance_planned`: A database maintenance has been planned.
- `database_maintenance_started`: A database maintenance has started.
- `database_maintenance_completed`: A database maintenance has completed.
- `database_maintenance_missed`: A maintenance has been postponed to a later window

These events can be used to create notifiers that alert you when a maintenance is planned.

More information about events and notifiers in the
[documentation]({% post_url platform/app/2000-01-01-notifiers %}).
