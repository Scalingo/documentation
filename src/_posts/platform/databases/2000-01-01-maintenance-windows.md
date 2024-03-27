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

## Maintenance Operation Definition

A maintenance operation is a change of any size that is applied to a database. The application of this change may, but does not necessarily, have an impact on the availability of your database.

Here are the different stages of a maintenance operation:

1. **Definition**: A Scalingo operator defines a new maintenance. This object allows us to attach all the elements that are important for its smooth execution (procedure, rollback, integrity test, etc.).
2. **Selection**: depending on the specific criteria for each maintenance, the eligible databases are assigned to this maintenance.
3. **Scheduling**: every hour, our system schedules operations to be carried out 24 hours later. If this corresponds to the maintenance window for an eligible resource, you will receive a notification confirming that this operation has been scheduled. From then on, it will not be possible to change or cancel the schedule without contacting our support team.
4. **Execution**: When the operation starts, you will receive another notification. It will then be important to limit any manipulation of your database.
5. **Operation completed**: You will receive another notification that the operation has been completed. The nominal service has been restored and your database is fully available again.

It is also possible that based on the remaining time in the selected window, we may determine that the operation cannot proceed. In that case, we will also notify you by email. The operation will be rescheduled for a later time.

{% note %}
Please note that once a maintenance notice has been issued, it cannot be changed or cancelled. If you are concerned that this operation will disrupt your business, you can contact our support team by chat or email.
{% endnote %}

## Customize the Maintenance Window for a Database

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

## Check Past and Future Maintenance Operations

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

## Share the information with your team

By default owner and collaborators will receive email notifications one day before a scheduled maintenance execution. This notification system operates via the [App notifications](https://doc.scalingo.com/platform/app/notification) feature and the “default notifier” which is configured for each app. Please check if it is still active or configure another notifier for this purpose.
It can easily be configured to suit your preferences. For instance, if you prefere webhook notifications over email, you can easily configure this setting (or create a new dedicated notifier). Additionally, you have the option to filter the list of recipients or provide a service address for individuals who need to be notified but do not have a Scalingo account.

Three new events have been added:

- `database_maintenance_planned` : A database maintenance has been planned.
- `database_maintenance_started`: A database maintenance has started.
- `database_maintenance_completed`: A database maintenance has completed.
