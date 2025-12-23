---
title: Restore your Database Backup
modified_at: 2025-12-23 12:00:00
tags: databases backups
index: 2
---

If your database is in a paid plan (i.e. it's not "free plan"), Scalingo makes automated backups of
your database on a daily basis. During your application lifetime, you might feel the need to restore
your database at a previous state. We will guide you through the different steps to download a
specific backups and restore the database with its content.

Here are the instructions to download a backup in a one-off container:

```sh
$ scalingo --app my-app run bash
[10:30][osc-fr1] Scalingo:my-app ~ $ install-scalingo-cli
[10:30][osc-fr1] Scalingo:my-app ~ $ scalingo login
[10:30][osc-fr1] Scalingo:my-app ~ $ scalingo --app my-app addons
+------------+-----------------------------------------+------------------------+---------+
|   ADDON    |                   ID                    |        PLAN            | STATUS  |
+------------+-----------------------------------------+------------------------+---------+
| PostgreSQL | ad-32ef9060-d912-4a53-b2bb-6cf1bf333865 | postgresql-starter-512 | running |
+------------+-----------------------------------------+------------------------+---------+
[10:30][osc-fr1] Scalingo:my-app ~ $ ADDON_UUID="ad-32ef9060-d912-4a53-b2bb-6cf1bf333865"
[10:30][osc-fr1] Scalingo:my-app ~ $ scalingo --app my-app --addon $ADDON_UUID backups-download
```

This downloads the last successful backup. In order to restore the downloaded backup, instructions are available in each database type page:

- [Scalingo for PostgreSQL®]({% post_url databases/postgresql/guides/2000-01-01-restoring %})
- [Scalingo for MySQL®]({% post_url databases/mysql/guides/2000-01-01-restoring %})
- [Scalingo for OpenSearch]({% post_url databases/opensearch/guides/2000-01-01-restoring %})
- [Scalingo for MongoDB®]({% post_url databases/mongodb/2000-01-01-start %}#backups)
- [Scalingo for Caching]({% post_url databases/redis/2000-01-01-start %}#backups)
- [Scalingo for Elasticsearch®]({% post_url databases/elasticsearch/2000-01-01-start %}#backups)
- [Scalingo for InfluxDB®]({% post_url databases/influxdb/2000-01-01-start %}#backups)
