---
title: Extending Your Scalingo for PostgreSQL® Addon
nav: Extending
modified_at: 2024-11-05 12:00:00
tags: databases postgresql addon
index: 7
---

PostgreSQL® is a database engine which is extensible thanks to a large set of
extensions. A lot of them are installed alongside your PostgreSQL® instance,
but you need to enable those manually according to your needs.

Please note that we have dedicated pages for some of the most popular
extensions:
- [TimescaleDB®]({% post_url databases/postgresql/2000-01-01-timescaledb %})
- [PostGIS]({% post_url databases/postgresql/2000-01-01-postgis %})
- [pgvector]({% post_url databases/postgresql/2000-01-01-pgvector %})

## Available Extensions

{% include database_postgresql_extensions.md %}


## Enabling an Extension

{% note %}
Enabling an extension for your PostgreSQL® is only available from the command
line.
{% endnote %}

### Using the Command Line

1. Access your database using the [Interactive Remote Console]({% post_url databases/postgresql/2000-01-01-accessing %}#using-the-interactive-remote-console)
2. From the PostgreSQL® console, run the following command:
   ```sql
   CREATE EXTENSION IF NOT EXISTS <extension_name>;
   ```
   The output should look like this:
   ```bash
   CREATE EXTENSION
   my_app_4553=>
   ```


## Disabling an Extension

{% note %}
Disabling an extension from your PostgreSQL® is only available from the command
line.
{% endnote %}

### Using the Command Line

1. Access your database using the [Interactive Remote Console]({% post_url databases/postgresql/2000-01-01-accessing %}#using-the-interactive-remote-console)
2. From the PostgreSQL® console, run the following command:
   ```sql
   DROP EXTENSION IF EXISTS <extension_name>;
   ```
   The output should look like this:
   ```bash
   DROP EXTENSION
   my_app_4553=>
   ```
