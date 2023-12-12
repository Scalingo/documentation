---
title: Monitoring and Auditing Your Scalingo for PostgreSQL® Addon
nav: Monitoring and Auditing
modified_at: 2023-11-28 00:00:00
tags: databases postgresql addon
index: 4
---


Each Scalingo for PostgreSQL® addon comes with several tools allowing for basic
monitoring and auditing of your database. These tools give access to the
[database logs](#inspecting-database-logs), to some [metrics](#analyzing-database-metrics)
and to [running queries figures](#watching-running-queries). [Query Statistics](#exploring-query-statistics)
can also be enabled if needed.

All these tools are available from the [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard).


## Inspecting Database Logs

Database logs are a very valuable resource when it comes to monitoring and
troubleshooting problems, tracking performance and auditing the database
activity.

By default, only the most recent logs are directly and immediately available
from the different tools (see below). We call these logs *Hot Logs*.

Once the logs reach 50MiB, they are compressed and placed in an archive. These
archives are *Cold Logs*. They are still available, but they require a bit more
work (see below).

### Using the Database Dashboard

1. From your web browser, open your [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Click the **Logs** tab

The default view allows to consult the latest hot logs in real-time. The
**Archives** link at the upper-right corner of the page allows to download the
cold logs. These have to be manually unarchived to be processed.

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, list the addons attached to your application:
   ```bash
   scalingo --app my-app addons
   ```
   The output should look like this:
   ```text
   +------------+-----------------------------------------+------------------------+---------+
   |   ADDON    |                   ID                    |          PLAN          | STATUS  |
   +------------+-----------------------------------------+------------------------+---------+
   | PostgreSQL | ad-871546ad-943a-4929-9770-ec7c839d65f5 | postgresql-starter-512 | running |
   ...
   ```
3. Locate the `ID` corresponding to the addon you are interested in
4. Run the following command:
   - To access the hot logs of this addon:
   ```bash
   scalingo --app my-app logs --addon <addon_ID> --lines <number_of_lines>
   ```
   - To access the cold logs of this addon:
   ```bash
   scalingo --app my-app logs-archives --addon <addon_ID>
   ```


## Analyzing Database Metrics

Database metrics are very helpful to identify and track overall performance
issues, making them key indicators to watch.

The provided metrics include:
- CPU usage, memory consumption, storage usage and disk input/output operations
  per second (IOPS) for all nodes composing your database cluster
- CPU usage and memory consumption for all gateway nodes.

### Using the Database Dashboard

1. From your web browser, open your [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Click the **Metrics** tab

{% note %}
Metrics related to your PostgreSQL® addon are only available from
the database dashboard.
{% endnote %}


## Watching Running Queries

Viewing running queries in real time is another feature we provide to help
have a better understanding of what's going on with your Scalingo for
PostgreSQL®. They allow to quickly identify resource-consuming queries, or even
stuck ones.

### Using the Database Dashboard

1. From your web browser, open your [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Click the **Running Queries** tab

{% note %}
Viewing running queries is only available from the database dashboard.
{% endnote %}


## Exploring Query Statistics

Query statistics are another useful tool allowing to get precious insights
about the database operations and performances over time. Analyzing these data
can help identifying costful queries, thus allowing to optimize code or
resources.

Query statistics are built by the `pg_stat_statements` extension. Once
activated, this extension provides a `pg_stat_statements` view that can be
queried as you wish. Detailed information about this view can be found [in the
extension official documentation](https://www.postgresql.org/docs/current/pgstatstatements.html).

### Enabling Query Statistics

Gathering query statistics can have a non negligible impact on your database
overall performance. Consequently, they are **not enabled by default** and have
to be activated manually.

#### Using the Database Dashboard

1. From your web browser, open your [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Click the **Query Statistics** tab
3. Click the **Enable Query Statistics** button

#### Using the Command Line

1. Access your database using the [Interactive Remote Console]({% post_url databases/postgresql/2000-01-01-accessing %}#using-the-interactive-remote-console)
2. From the PostgreSQL® console, run the following command:
   ```sql
   CREATE extension pg_stat_statements;
   ```
   The output should look like this:
   ```bash
   CREATE EXTENSION
   my_app_4553=>
   ```

### Using the Database Dashboard

[Once enabled](#enabling-query-statistics), query statistics can be consulted:

1. From your web browser, open your [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Click the **Query Statistics** tab

{% note %}
Consulting query statistics is only available from the database dashboard.
{% endnote %}
