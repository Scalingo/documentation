---
title: Monitoring and Auditing Your Scalingo for PostgreSQL® Addon
nav: Monitoring and Auditing
modified_at: 2023-11-28 00:00:00
tags: databases postgresql addon
index: 4
---


Each Scalingo for PostgreSQL® addon comes with several tools allowing for basic
monitoring and auditing of your database. These tools give access to the
[database logs](#consulting-database-logs), to some [metrics](#consulting-database-metrics)
and to [running queries figures](#viewing-running-queries). [Query Statistics](#consulting-query-statistics)
can also be enabled if needed.

All these tools are available from the [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard).


## Consulting Database Logs

Database logs are a very valuable resource when it comes to monitoring and
troubleshooting problems, tracking performance and auditing the database
activity.

### Understanding Hot and Cold Logs

By default, only the most recent logs are directly and immediately available
from the different tools (see below). We call these logs *Hot Logs*.

Once the logs reach 50MiB, they are compressed and placed in an archive. These
archives are *Cold Logs*. They are still available, but they require a bit more
work (see below).

### Using the Database Dashboard

1. From your web browser, open your [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Click the **Logs** tab

The default view allows to consult the latest logs in real-time. The
**Archives** link at the upper-right corner of the page allows to download t

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo Command Line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, list the addons attached to your application:
   ```bash
   scalingo --app my-app addons
   ```
   The output should look like this:
   ```bash
   +------------+-----------------------------------------+------------------------+---------+
   |   ADDON    |                   ID                    |          PLAN          | STATUS  |
   +------------+-----------------------------------------+------------------------+---------+
   | PostgreSQL | ad-871546ad-943a-4929-9770-ec7c839d65f5 | postgresql-starter-512 | running |
   ...
   ```
3. Locate the `ID` corresponding to the addon you are interested in
4. Run the following command to access the logs of this addon:
   ```bash
   scalingo --app my-app logs --addon <addon_ID> --lines <number_of_lines>
   ```


## Consulting Database Metrics


## Viewing Running Queries


## Consulting Query Statistics

