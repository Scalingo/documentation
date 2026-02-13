---
title: Monitoring and Auditing Your Scalingo for PostgreSQL® Shared Resources Database
nav: Monitoring and Auditing
modified_at: 2024-12-13 00:00:00
tags: databases postgresql addon
index: 2
---


Each Scalingo for PostgreSQL® Shared Resources Database addon comes with several tools allowing for
monitoring and auditing of your database. These tools give access to the
[database logs](#inspecting-database-logs), to some [metrics](#analyzing-database-metrics)
and to [running queries figures](#watching-running-queries). [Query Statistics](#exploring-query-statistics)
can also be enabled if needed.

All these tools are available from the [database dashboard][database-dashboard].


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

1. From your web browser, open your [database dashboard][database-dashboard]
2. Click the **Logs** tab

The default view allows to consult the latest hot logs in real-time. The
**View archives** link at the upper-right corner of the page allows to download 
the cold logs. These have to be manually unarchived to be processed.

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. Run the following command:
   - To access the hot logs of this addon:
   ```bash
   scalingo --app my-app --addon postgresql logs --lines <number_of_lines>
   ```
   - To access the cold logs of this addon:
   ```bash
   scalingo --app my-app --addon postgresql logs-archives
   ```


## Analyzing Database Metrics

Database metrics are very helpful to identify and track overall performance
issues, making them key indicators to watch.

The provided metrics include:
- CPU usage, memory consumption, storage usage and disk input/output operations
  per second (IOPS) for all nodes composing your database cluster
- CPU usage and memory consumption for all gateway nodes.

### Using the Database Dashboard

1. From your web browser, open your [database dashboard][database-dashboard]
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

1. From your web browser, open your [database dashboard][database-dashboard]
2. Click the **Running Queries** tab

### Using the Command Line

Scalingo for PostgreSQL® gives direct access to PostgreSQL®'s [*cumulative
statistics system*][pg-stats-monitoring],
which collects data about the database activity. Concretely, it exposes several
views that can be queried from an [Interactive Remote Console][sr-irc].

Amongst the views available, these might be of particular interest when
monitoring the current state of the database:
- `pg_stat_activity` shows information related to the current activity of each
  process running. It can be queried to view running queries and their current
  state.
- `pg_stat_progress_analyze` shows information related to each running
  `ANALYZE` process, including current progress.
- `pg_stat_progress_create_index` shows information related to each running
  `CREATE INDEX` or `REINDEX` process, including current progress.
- `pg_stat_progress_vacuum` shows information related to each running `VACUUM`
  process, including current progress.
- `pg_stat_user_tables` shows statistics about accesses to each table.

For more information, please refer to [the officiel documentation][pg-stats-monitoring].


## Exploring Query Statistics

Query statistics are another useful tool allowing to get precious insights
about the database operations and performances over time. Analyzing these data
can help identifying costful queries, thus allowing to optimize code or
resources.

Query statistics are built by the `pg_stat_statements` extension. Once
activated, this extension provides a `pg_stat_statements` view that can be
queried as you wish. Detailed information about this view can be found [in the
extension official documentation][pg-stats-statements].

### Enabling Query Statistics

Gathering query statistics can have a non negligible impact on your database
overall performance. Consequently, they are **not enabled by default** and have
to be activated manually.

#### Using the Database Dashboard

1. From your web browser, open your [database dashboard][database-dashboard]
2. Click the **Query Statistics** tab
3. Click the **Enable** button

#### Using the Command Line

1. Access your database using the [Interactive Remote Console][sr-irc]
2. From the PostgreSQL® console, run the following command:
   ```sql
   CREATE extension pg_stat_statements;
   ```
   The output should look like this:
   ```bash
   CREATE EXTENSION
   my_app_4553=>
   ```

### Viewing Query Statistics

[Once enabled](#enabling-query-statistics), query statistics can be consulted:

#### Using the Database Dashboard

1. From your web browser, open your [database dashboard][database-dashboard]
2. Click the **Query Statistics** tab

#### Using the Command Line

1. Access your database using the [Interactive Remote Console][sr-irc]
2. From the PostgreSQL® console, query the `pg_stat_statements` as you wish.\
   Our [Troubleshooting][troubleshooting]
   page gives some examples.


[pg-stats-monitoring]: https://www.postgresql.org/docs/current/monitoring-stats.html
[pg-stats-statements]: https://www.postgresql.org/docs/current/pgstatstatements.html

[cli]: {% post_url tools/cli/2000-01-01-start %}

[sr-irc]: {% post_url databases/postgresql/shared-resources/getting-started/2000-01-01-accessing %}#using-the-interactive-remote-console
[database-dashboard]: {% post_url databases/postgresql/shared-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard
[troubleshooting]: {% post_url databases/postgresql/2000-01-01-troubleshooting %}#identifying-performances-issues
