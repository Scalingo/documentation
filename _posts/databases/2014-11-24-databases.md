---
title: Scalingo database add-ons
modified_at: 2014-11-24 00:00:00
category: databases
tags: index-databases polydbs
index: 0
---

You applications need databases to store your data. As we believe your data
should be located geographically close to your application servers we support
the most common types of database.

We ensure your database is located at the same location as your applications.
It provides the best performance and latency possible. Moreover you know where
your data are.

## Database types

### SQL

* [PostgreSQL]({% post_url databases/2000-01-01-scalingo-postgresql-addon %})
* [MySQL]({% post_url databases/2000-01-01-scalingo-mysql-addon %})

### NoSQL

* [MongoDB]({% post_url databases/2000-01-01-scalingo-mongodb-addon %})
* [Redis]({% post_url databases/2000-01-01-scalingo-redis-addon %})
* [Elasticsearch]({% post_url databases/2000-01-01-scalingo-elasticsearch-addon %})
* [InfluxDB]({% post_url databases/2000-01-01-scalingo-influxdb-addon %})

## Backups

{% include database_backups.md %}
