---
title: Monitoring and Auditing Your Scalingo for OpenSearch® Addon
nav: Monitoring and Auditing
modified_at: 2025-04-25 12:00:00
tags: databases opensearch addon
index: 2
---


Each Scalingo for OpenSearch® addon comes with several tools allowing for
monitoring and auditing of your database. These tools give access to the
[database logs](#inspecting-database-logs) and some [metrics](#analyzing-database-metrics).

All these tools are available from the [database dashboard][db-dashboard].


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

1. From your web browser, open your [database dashboard][db-dashboard]
2. Click the **Logs** tab

The default view allows to consult the latest hot logs in real-time. The
**View archives** link at the upper-right corner of the page allows to download
the cold logs. These have to be manually unarchived to be processed.

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. Run the following command:
   - To access the hot logs of this addon:
   ```bash
   scalingo --app my-app --addon opensearch logs --lines <number_of_lines>
   ```
   - To access the cold logs of this addon:
   ```bash
   scalingo --app my-app --addon opensearch logs-archives
   ```


## Analyzing Database Metrics

Database metrics are very helpful to identify and track overall performance
issues, making them key indicators to watch.

The provided metrics include:
- CPU usage, memory consumption, storage usage and disk input/output operations
  per second (IOPS) for all nodes composing your database cluster
- CPU usage and memory consumption for all gateway nodes.

### Using the Database Dashboard

1. From your web browser, open your [database dashboard][db-dashboard]
2. Click the **Metrics** tab

{% note %}
Metrics related to your OpenSearch® addon are only available from the database
dashboard.
{% endnote %}


[cli]: {% post_url tools/cli/2000-01-01-start %}
[db-dashboard]: {% post_url databases/about/2000-01-01-database-dashboard %}
[monitoring]: {% post_url databases/opensearch/guides/2000-01-01-monitoring %}
[managing-users]: {% post_url databases/opensearch/guides/2000-01-01-managing-users %}
[backing-up]: {% post_url databases/opensearch/guides/2000-01-01-backing-up %}

