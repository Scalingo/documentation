---
title: Monitoring and Auditing Your Scalingo for MySQL® Addon
nav: Monitoring and Auditing
modified_at: 2024-03-05 12:00:00
tags: databases mysql addon
index: 4
---


Each Scalingo for MySQL® addon comes with several tools allowing for monitoring
and auditing of your database. These tools give access to the [database logs](#inspecting-database-logs)
and to some [metrics](#analyzing-database-metrics).

All these tools are available from the [database dashboard]({% post_url databases/mysql/2000-01-01-getting-started %}#accessing-the-scalingo-for-mysql-dashboard).


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

1. From your web browser, open your [database dashboard]({% post_url databases/mysql/2000-01-01-getting-started %}#accessing-the-scalingo-for-mysql-dashboard)
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
   +-------+-----------------------------------------+-------------------+---------+
   | ADDON |                   ID                    |       PLAN        | STATUS  |
   +-------+-----------------------------------------+-------------------+---------+
   | MySQL | ad-871546ad-943a-4929-9770-ec7c839d65f5 | mysql-starter-512 | running |
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

1. From your web browser, open your [database dashboard]({% post_url databases/mysql/2000-01-01-getting-started %}#accessing-the-scalingo-for-mysql-dashboard)
2. Click the **Metrics** tab

{% note %}
Metrics related to your MySQL® addon are only available from the database
dashboard.
{% endnote %}
