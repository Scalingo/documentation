---
title: Remote Console
nav: : Interactive Remote Console
modified_at: 2026-02-09 12:00:00
tags: databases
index: 2
---

This page details how to use the Remote Console method from
[Access Your Database][access-your-database].

## Availability

The Remote Console is available for supported Shared Resources databases only:

- PostgreSQL
- MySQL
- MongoDB
- Redis
- InfluxDB

It is not available for OpenSearch or Dedicated Resources databases.

{% note %}
Remote Console tools run in a one-off container, which is a copy of your app
execution environment. Client versions follow stack compatibility constraints,
so some versions are not available on older stacks (for example, MySQL client
8.4 is not available on `scalingo-20`).
{% endnote %}

## Open a Remote Console

```bash
# Open a console using the `mysql` client
scalingo --app my-app mysql-console

# Open a console using the `psql` client
scalingo --app my-app pgsql-console

# Open a console using the `mongo` client
scalingo --app my-app mongo-console

# Open a console using the `redis-cli` client
scalingo --app my-app redis-console

# Open a console using the `InfluxDB shell` client
scalingo --app my-app influxdb-console
```

Make sure you have already added the corresponding addon from your application
dashboard before running one of these commands.

{% include info_command_line_tool.md %}

## Manually Install the Databases CLI in a One-off

If you started a Bash process in a [one-off container]({% post_url platform/app/2000-01-01-tasks %}),
you can download various CLI tools for the supported databases listed below:

| Database   | Keyword                       | Installed Tools      |
| ---------- | ----------------------------- | -------------------- |
| PostgreSQL | `pgsql`, `postgresql`, `psql` | `psql`, `pg_basebackup`, `pg_controldata`, `pg_dump`, `pg_isready`, `pg_recvlogical`, `pg_restore`, `pg_test_fsync`, `pg_upgrade`, `pg_archivecleanup`, `pg_config`, `pg_ctl`, `pg_dumpall`, `pg_receivewal`, `pg_resetwal`, `pg_rewind`, `pg_test_timing`, `pg_waldump` |
| MySQL      | `mysql`                       | `mysql`, `mysqldump` |
| MongoDB    | `mongo`                       | `mongo`, `mongodump`, `mongorestore`, `mongoexport`, `mongoimport` |
| Redis      | `redis`                       | `redis-cli`          |
| InfluxDB   | `influxdb`, `influx`          | `influx`             |

{% include dbclient_fetcher.md %}

[access-your-database]: {% post_url platform/databases/2000-01-01-access %}
