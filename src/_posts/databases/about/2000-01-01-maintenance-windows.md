---
title: Database Maintenance Windows
nav: Maintenance Windows
modified_at: 2024-12-16 12:00:00
tags: databases maintenance
index: 30
---


## Understanding Database Maintenance Windows

**Database Maintenance Windows** is Scalingo's system for scheduling
*[maintenance operations](#understanding-maintenance-operations)* on your
databases. On the customer's side, it mainly consists in an 8 hours timespan
during which database maintenance operations can be scheduled. The goal of
maintenance windows is to minimize the impact of maintenance operations on your
application, while facilitating continuous improvement on our side.

A default 8 hours maintenance window is automatically assigned to all newly
provisioned database. This maintenance window is set to a random weekday,
from 9PM to 5AM UTC.

If the given timeframe doesn't align with your business requirements, please
[adjust it as needed](#configuring-a-database-maintenance-window). We strongly
advise to schedule the maintenance window when your app is less prone to high
traffic to minimize undesired consequences such as a possible downtime.

{% note %}
Database Maintenance Windows are excluded from the SLA calculation.
{% endnote %}


## Viewing Database Maintenance Windows

### Using the Database Dashboard

1. From your web browser, open your database dashboard
2. Select the **Settings** tab.
3. In the **Settings** submenu, select **Maintenance**
4. The current Maintenance Window is displayed in the **Maintenance Window**
   block

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url tools/cli/2000-01-01-start %})
2. From the command line, run the following command to view the maintenance
   window settings:
   ```bash
   scalingo --app my-app addons-info <database_type>
   ```
   With:
   - `database_type`: must be either `postgresql`, `mysql`, `redis`, `mongodb`,
     `elasticsearch`, `opensearch` or `influxdb`, depending on the database engine

   The output should look like this:
   ```text
   +------------------------+------------------------------+
   | Addon Provider         | PostgreSQL                   |
   | Plan                   | postgresql-starter-512       |
   | Status                 | running                      |
   | Database Type          | postgresql                   |
   | Version                | 16.11.0-1                    |
   | Force TLS              | disabled                     |
   | Internet Accessibility | disabled                     |
   | Maintenance window     | Tuesdays at 22:00 (08 hours) |
   +------------------------+------------------------------+
   ```


## Configuring Database Maintenance Windows

Maintenance windows can be configured separately for each database instance. To
configure it, you will have to pick a weekday and a start time.

{% note %}
Please note that once a maintenance notice has been issued, it can't be
rescheduled or cancelled. If you have concerns about a planned maintenance
operation (e.g. business disruption), please get in touch with our support
team.
{% endnote %}

### Using the Database Dashboard

1. From your web browser, open your database dashboard
2. Select the **Settings** tab.
3. In the **Settings** submenu, select **Maintenance**
4. Locate the **Maintenance Window** block
5. Click the **Update schedule** button
6. Pick a day and a start time (**timezone is UTC**)
7. Validate by clicking the **Update schedule** button

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url tools/cli/2000-01-01-start %})
2. From the command line, run the following command to configure the
   maintenance window:
   ```bash
   scalingo --app my-app addons-config --maintenance-window-day <day> --maintenance-window-hour <hour> <database_type>
   ```
   With:
   - `day`: must be either `monday`, `tuesday`, `wednesday`, `thursday`,
     `friday`, `saturday` or `sunday`
   - `hour`: start time of the database maintenance window (**timezone is the
     local one**). Must be an integer between `0` and `23`
   - `database_type`: must be either `postgresql`, `mysql`, `redis`, `mongodb`,
     `elasticsearch`, `opensearch` or `influxdb`, depending on the database engine you are
     configuring

   The output should look like this:
   ```text
   Addon config updated.
   ```
   To set to database maintenance window of your PostgreSQL® instance to start on
   Mondays at 1AM (local) while being located at UTC-5:
   ```bash
   scalingo --app my-app addons-config --maintenance-window-day monday --maintenance-window-hour 1 postgresql
   ```


## Understanding Maintenance Operations

In Scalingo's terminology, a ***maintenance operation*** designates a change of
any size that is applied to a database. The application of this change may, but
does not necessarily, have an impact on the availability of your database.

Maintenance operations encompass various automated tasks, ranging from minor
database engine configurations to updates of the database engine itself,
including essential security patches and migrations to updated host nodes.

Here are the different stages of a maintenance operation:

1. **Definition**:\
   A Scalingo operator defines a new maintenance. This object allows us to
   attach all the elements that are important for its smooth execution
   (procedure, rollback, integrity test, etc.).
2. **Selection**:\
   Depending on the specific criteria for each maintenance, the eligible
   databases are assigned to this maintenance.
3. **Scheduling**:\
   Every hour, our system schedules operations to be carried out 24 hours
   later. If this corresponds to the maintenance window for an eligible
   resource, you will receive a notification confirming that this
   operation has been scheduled. From then on, it is not be possible to
   change or cancel the schedule without contacting our support team.
4. **Execution**:\
   Notifications are sent as soon as the operation starts. It's then important
   to limit any manipulation of the database.
5. **Operation completed**:\
   Notifications are sent once the operation has completed, meaning the
   nominal service has been restored and that the database is fully available
   again.

{% note %}
Based on the remaining time in the selected window, the platform may determine
that the planned operation won't be able to run successfully in the given
timeframe. In such a case, the operation is cancelled and rescheduled for a
later time.
{% endnote %}


## Listing Past and Future Maintenance Operations

### Using the Database Dashboard

1. From your web browser, open your database dashboard
2. Click on the **Settings** tab.
3. In the **Settings** menu, select **Maintenance**
4. The list of maintenance operations scheduled or carried out in the last 12
   months is displayed in the **Maintenance operations list** block

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url tools/cli/2000-01-01-start %})
2. From the command line, run the following command to list maintenance
   operations:
   ```bash
   scalingo --app my-app --addon <database_type> database-maintenance-list
   ```
   With:
   - `database_type`: must be either `postgresql`, `mysql`, `redis`, `mongodb`,
     `elasticsearch`, `opensearch` or `influxdb`, depending on the database engine

   The output should look like this:
   ```text
   +--------------------------+-------------------+---------------------+---------------------+--------+
   |            ID            |       TYPE        |     STARTED AT      |      ENDED AT       | STATUS |
   +--------------------------+-------------------+---------------------+---------------------+--------+
   | 65143fd19307d522665facc0 | db-node-migration | 2023/09/29 13:00:00 | 2023/09/29 13:00:00 | done   |
   +--------------------------+-------------------+---------------------+---------------------+--------+
   ```
3. From the command line, run the following command to get more details about a
   specific maintenance operation:
   ```bash
   scalingo --app my-app --addon <database_type> database-maintenance-info <maintenance_uuid>
   ```
   With:
   - `database_type`: must be either `postgresql`, `mysql`, `redis`, `mongodb`,
     `elasticsearch`, `opensearch`or `influxdb`, depending on the database engine
   - `maintenance_uuid`: id of the maintenance operation

   The output should look like this:
   ```
   +------------+----------------------------------------------+
   | ID         | 656ddbd39307d5ec79ff748b                     |
   | Type       | db-node-migration                            |
   | Started At | Next Maintenance Window: 2023/12/08 12:00:00 |
   | Ended At   |                                              |
   | Status     | scheduled                                    |
   +------------+----------------------------------------------+
   ```

## Sharing the Information With Your Team

By default, owner and collaborators receive email notifications one day before
a scheduled maintenance execution. This notification system operates via the
[App notifications]({% post_url /platform/app/2000-01-01-notification %})
feature and the "default notifier" which is configured for each app. Please
check if it is still active or configure another notifier for this purpose.
It can easily be configured to suit your preferences. For instance, if you
prefer webhook notifications over email, you can easily configure this setting
(or create a new dedicated notifier). Additionally, you have the option to
filter the list of recipients or provide a service address for individuals who
need to be notified but do not have a Scalingo account.

There are three events about database maintenance:

- `database_maintenance_planned` : A database maintenance has been planned.
- `database_maintenance_started`: A database maintenance has started.
- `database_maintenance_completed`: A database maintenance has completed.
