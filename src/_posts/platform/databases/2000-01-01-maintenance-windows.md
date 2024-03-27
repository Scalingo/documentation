---
title: Database Maintenance Windows
nav: Maintenance Windows
modified_at: 2024-03-27 06:00:00
tags: databases maintenance
index: 4
---

Database Maintenance Windows is the Scalingo system for scheduling the maintenance needed on your databases. This system automates maintenance operations according to your preferred schedule, minimizing the impact on your application, while facilitating continuous improvement on our side.

Maintenance operations encompass various automated tasks, ranging from minor database engine configurations to updates of the database engine itself, including essential security patches and migrations to updated host nodes.

{% note %}
Currently, Scalingo does not automatically perform version upgrades for your database. While you still need to manage this manually, the introduction of Database Maintenance Windows will enable this kind of operation in the future.
{% endnote %}

Each database has been assigned with a 8 hours default Maintenance Window on a weekday, from 21:00 to 05:00 UTC. However, if this timeframe doesn't align with your business requirements, you have the flexibility to adjust it as needed.

In concrete terms, it's now possible to schedule a maintenance when your app is less prone to high traffic (e.g. the night between Sunday and Monday). With those features, we have in mind the prevention of any undesired downtime of your app.

{% note %}
Planned Maintenance Windows are excluded from the SLA calculation.
{% endnote %}

### Customize the Maintenance Window for a Database?

With the Scalingo CLI, the desired beginning period of your 8 hours time window can be configured with the `addons-config` command:

```bash
# You are setting the window day to "monday", starting at 1 AM (local)
$ scalingo --app my-app addons-config --maintenance-window-day monday --maintenance-window-hour 1 addon-uuid
Addon config updated.
```

Setting this up allows Scalingo to proceed to their maintenance between 1 AM and 9 AM in your timezone. If you do configure your Database Maintenance Window to begin at 1 AM, and your CLI is located at UTC-5, it will begin at 6 AM UTC. You can check the time window you configured with the command `addons-info`:

```bash
$ scalingo --app my-app addons-info addon-uuid
```

```bash
# Show the current Maintenance Window configuration for the PostgreSQL addon
$ scalingo --app my-app addons-info postgresql
+------------------------+------------------------------+
| Database Type          | postgresql                   |
| Version                | 13.11.0-1                    |
| Status                 | running                      |
| Plan                   | postgresql-starter-512       |
| Force TLS              | disabled                     |
| Internet Accessibility | disabled                     |
| Maintenance window     | Tuesdays at 22:00 (08 hours) |
+------------------------+------------------------------+
```

### Check Past and Future Maintenance Operations

To use the following commands in order to list planned and past maintenance on your database, specify the related application, and your database addon UUID:

```bash
$ scalingo --app my-app --addon addon-uuid database-maintenance-list
```


```bash
# List database Maintenance Operations for my-app's PostgreSQL
$ scalingo --app my-app --addon postgresql database-maintenance-list
+--------------------------+-------------------+---------------------+---------------------+--------+
|            ID            |       TYPE        |     STARTED AT      |      ENDED AT       | STATUS |
+--------------------------+-------------------+---------------------+---------------------+--------+
| 65143fd19307d522665facc0 | db-node-migration | 2023/09/29 13:00:00 | 2023/09/29 13:00:00 | done   |
+--------------------------+-------------------+---------------------+---------------------+--------+
```

This command displays the list of the planned Maintenance Windows for your database.

You can, as well, get more details about a specific Maintenance Operation:

```bash
$ scalingo --app my-app --addon addon-uuid database-maintenance-info maintenance_uuid
```

```bash
# Get more detail about a specific maintenance's operation
$ scalingo --app my-app --addon postgresql database-maintenance-info 656ddbd39307d5ec79ff748b
+------------+----------------------------------------------+
| ID         | 656ddbd39307d5ec79ff748b                     |
| Type       | db-node-migration                            |
| Started At | Next Maintenance Window: 2023/12/08 12:00:00 |
| Ended At   |                                              |
| Status     | scheduled                                    |
+------------+----------------------------------------------+
```
