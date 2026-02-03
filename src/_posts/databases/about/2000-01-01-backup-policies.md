---
title: Databases Backup Policies
nav: Backup Policies
modified_at: 2025-12-23 18:00:00
tags: databases backup policy policies explanation
index: 20
---

All plans include automated, managed backups designed to support reliable data
recovery. Depending on the architecture model, the typical recovery point
objective (RPO) ranges from about 5 minutes with continuous backups to up to
1 day with logical backups.

Backup technology and retention policy depend on the database engine and 
architecture model:

| Managed Database            | Architecture model  | Logical Backups      | Continious Backups |
|-----------------------------|---------------------|----------------------|--------------------|
| Scalingo for PostgreSQL®    | Dedicated Resources | Customer-managed[^1] | Managed            |
| Scalingo for PostgreSQL®    | Shared Resources    | Managed              | Managed            |
| Scalingo for MySQL®         | Shared Resources    | Managed              | Not available      |
| Scalingo for MongoDB®       | Shared Resources    | Managed              | Not available      |
| Scalingo for OpenSearch®    | Shared Resources    | Managed              | Not available      |
| Scalingo for Elasticsearch® | Shared Resources    | Managed              | Not available      |
| Scalingo for InfluxDB®      | Shared Resources    | Managed              | Not available      |

[^1]: On Dedicated Resources, logical backups are possible, but they are 
customer-managed and rely on an external tool for both execution and retention 
policy.

## Logical Backups

Scalingo provides two logical backup mechanisms for supported database engines:

- [Scheduled backups](#scheduled-backups) rely on our automated backup service
  to create a daily full backup of your database.
- [Manual backups](#manual-backups), as the name implies, can be leveraged at
  any time to manually trigger the creation of a new full backup.

### Scheduled Backups

Scalingo provides a scheduled backup service for all our databases addons in
Starter and Business plans. Scheduled backups are done on a daily basis. They consist in dumping the database to an archive that is kept
during a [certain amount of time](#retention-policy-for-scheduled-backups).

The start time can be customized using the dashboard or our Command Line tool,
enabling you to align backups with your workload and core business operations.

#### Retention Policy for Scheduled Backups

We retain a limited number of backups based on your database plan:

- **Daily backups**: one backup is retained for each of the last 7 days, for a
  total of 7 backups.
- **Weekly backups**: the daily backup taken on Sunday is retained as the
  weekly backup.
- **Monthly backups**: the daily backup from the first Sunday of the month is
  retained as the monthly backup.

| Plan     | Daily Backups  | Weekly Backups  | Monthly Backups   |
| -------- | -------------- | --------------- | ----------------- |
| Starter  | 7 rolling days | 4 rolling weeks | None              |
| Business | 7 rolling days | 8 rolling weeks | 12 rolling months |

Deleting a database doesn't immediately remove its scheduled backups. They
expire gradually according to their retention policy.

### Manual Backups

Scalingo provides a manual backup service for databases in the Starter and
Business plans. Manual backups consist in dumping the database to an archive
that is kept during a [certain amount of time](#retention-policy-for-manual-backups).
This feature allows you to create a backup on demand, such as before an upgrade
or any important operation on your data.

#### Retention Policy for Manual Backups

The number of manual backups you can store is limited by your plan (see below).
Manual backups are kept for an unlimited amount of time, as long as the number
of backups doesn't exceed the plan's limit. If creating a new backup exceeds
this limit, the oldest backup is automatically deleted.

| Plan     | Backups Retained        |
| -------- | ----------------------- |
| Starter  | Last 10 rolling backups |
| Business | Last 50 rolling backups |

When a database is deleted, a retention policy is retroactively applied to
all existing manual backups, based on their creation date. The retention
duration depends on the plan:

| Plan     | Retention Duration |
| -------- | ------------------ |
| Starter  | 1 month            |
| Business | 1 year             |

If manual backups have already exceeded their retention period, they are
deleted immediately.


## Continuous backups

Continuous backups (Point-in-Time Recovery, PiTR) is the primary backup
mechanism for PostgreSQL® instances. They let you restore the database to a
specific point in time within a predefined **recovery window**. The recovery
window ranges from 7 to 30 days, depending on the service class and
architecture model.

We achieve this by making a full PiTR backup of the database on a weekly basis.
Between two full PiTR backups, we keep track of the Write-Ahead Logs (WAL),
which contains all the modification instructions. Replaying the WAL from a
full PiTR backup until a specific date allows us to rebuild the state of the
database at that particular date. Please note that the first base backup may
take up to 24 hours to complete, after which PiTR begins monitoring changes for
recovery purposes.

PiTR technology operates independently of the database's load or size, making
it a reliable solution for handling large datasets. This feature offers a 7-day
retention period without the usual constraints of traditional backup methods.

Performing a Point-in-Time Recovery resets the continuous backup timeline. This
means the retention window starts over, and you won’t be able to restore from
an earlier point in time. Currently, Scalingo only supports a single timeline
in its recovery process.

### Recovery Window for PiTR

The recovery window ranges from 7 to 30 days, depending on the service class and
architecture model.

| Architecture model   | Starter | Business | Enterprise |
|----------------------|---------|----------|------------|
| Shared Resources     | 7 days  | 7 days   | —          |
| Dedicated Resources  | 7 days  | 14 days  | 30 days    |


## Monitoring Backups

The following events are available to monitor the backups:

| Event                       | Description                                       |
| --------------------------- | ------------------------------------------------- |
| `database_backup_succeeded` | A database backup has been successfully completed |
| `database_backup_failed`    | A database backup has failed                      |

To learn more about events and notifications, please visit the page dedicated to [app notifications]({% post_url platform/app/2000-01-01-notification %}).


## Important Considerations

- All backups are encrypted and securely stored in our infrastructure. They are
  duplicated in the three availability zones of the region where the database
  is hosted.

- The time required to complete a backup depends on the amount of data being
  backed up. This operation may impact the performance of the database and, by
  extension, the application.

- On Business plans, backups are performed on the secondary instance to limit
  the impact on the primary instance.

- Several factors can delay, cancel, or impact the backup process:

  - The database load, the volume of data stored, and the nature of the queries
    running during the backup can have a significant impact.
  - The service is optimized for standard use but large datasets or specific
    operations may impede the backup's successful execution. In such cases, we
    encourage you to contact Scalingo support to explore alternative
    architectural solutions that could improve the scalability of your
    applications.

- Some specific conditions may delay, cancel, or affect the consistency of the
  backup:

  - Backups are only performed if the feature is enabled, which is the default
    setting. However, users can manually disable it if needed.
  - The database must be in a running state at the scheduled time of the
    backup.
  - No maintenance operations, either scheduled or unscheduled, should be
    performed during the backup. The backup could otherwise be delayed or
    skipped entirely.
  - Application-level locks or long-running transactions can prevent backups
    from executing, as these can block access to certain tables or resources
    needed during the backup process.
  - The scheduled time is flexible: it might be delayed depending on the load
    on our infrastructure.
