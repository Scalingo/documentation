---
modified_at: 2026-09-25 12:00:00
title: "New Event for Redis to Valkey Migration Completion"
---

A new event has been added when a migration of a Redis database to Valkey has been completed (`complete_redis_to_valkey_migration`).

This event can be used to create notifiers that alert you when such a migration completes. More information about events and notifiers in the [documentation]({% post_url platform/app/2000-01-01-notifiers %}).
