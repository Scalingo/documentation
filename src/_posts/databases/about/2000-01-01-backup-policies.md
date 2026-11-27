---
title: Databases Backup Policies
nav: Backup Policies
modified_at: 2026-11-27 00:00:00
tags: databases backup policy policies explanation
index: 20
---

All plans include automated, managed backups.

Backup technology and retention policy depend on the database engine and architecture model. We provide two backup mechanisms when supported:

- [**Logical backups**](#logical-backups): scheduled or manual dumps of the database, stored as
  archives and retained according to the applicable retention policy.
- [**Continuous backups**](#continuous-backups): Point-in-Time Recovery (PiTR), which lets you
  restore the database to a specific point in time within the configured
  recovery window.

The table shows the backup methods and typical recovery point objective (RPO)
for each database engine and architecture model.

| Managed Database            | Architecture model  | Logical Backups      | Continuous Backups | Typical RPO[^2] |
|-----------------------------|---------------------|----------------------|--------------------|-----------------|
| Scalingo for PostgreSQL®    | Dedicated Resources | Customer-managed[^1] | Managed            | 5 minutes[^3]   |
| Scalingo for PostgreSQL®    | Shared Resources    | Managed              | Managed            | 5 minutes[^3]   |
| Scalingo for MySQL®         | Dedicated Resources | Customer-managed[^1] | Managed            | 5 minutes[^3]   |
| Scalingo for MySQL®         | Shared Resources    | Managed              | Not available      | 1 day           |
| Scalingo for OpenSearch®    | Dedicated Resources | Managed              | Not available      | 1 hour          |
| Scalingo for OpenSearch®    | Shared Resources    | Managed              | Not available      | 1 day           |
| Scalingo for Valkey®        | Shared Resources    | Managed              | Not available      | 1 hour          |
| Scalingo for Valkey®        | Dedicated Resources | Managed              | Not available      | 1 hour          |
| Scalingo for Caching        | Shared Resources    | Managed              | Not available      | 1 day           |
| Scalingo for Elasticsearch® | Shared Resources    | Managed              | Not available      | 1 day           |
| Scalingo for InfluxDB®      | Shared Resources    | Managed              | Not available      | 1 day           |
| Scalingo for MongoDB®       | Shared Resources    | Managed              | Not available      | 1 day           |
{: #backup-mechanisms }

[^1]: For these combinations of database engine and architecture model, Scalingo
    uses continuous backups (PiTR) as the primary backup method. You can create
    logical backups with external tools and manage their retention yourself.

[^2]: The latest recovery point is the most recent successful scheduled backup
    or the latest point available through PiTR. Backup delays or failures can
    leave an older recovery point.

[^3]: This estimate accounts for the time needed to synchronize and ingest
    database changes for continuous backups.

## Logical Backups

Scalingo manages two types of logical backups.

- [Scheduled backups](#scheduled-backups) are full database backups that
  Scalingo's backup service runs automatically.
- [Manual backups](#manual-backups) are full database backups that run when
  you request them.

You can also create logical backups with external tools. You store these backups
outside Scalingo and manage their retention. The policies below apply only to
backups managed by Scalingo.

### Scheduled Backups

Scheduled backups are enabled by default. Each backup creates an archive that
Scalingo keeps according to the [retention policy](#retention-policy-for-scheduled-backups).

You can set the start time for daily backups in the dashboard or with the CLI
to suit your workload. The actual start time may vary depending on platform load.

#### Retention Policy for Scheduled Backups

Scalingo uses the following retention levels for scheduled backups.

- **Hourly** keeps successful hourly backups within the retention window.
- **Twelve-hourly** keeps one successful backup per half-day, starting at 00:00
  and 12:00 UTC.
- **Daily** keeps one successful backup per day.
- **Weekly** keeps the daily backup from Sunday.
- **Monthly** keeps the daily backup from the first Sunday of the month.

Deleting a database doesn't immediately remove its scheduled backups. They
expire gradually according to their retention policy.

##### Daily schedules

These limits apply to Scalingo for PostgreSQL®, MySQL®, MongoDB®, OpenSearch®,
Elasticsearch®, InfluxDB®, and Caching on Shared Resources.

| Service Class | Daily Retention | Weekly Retention | Monthly Retention |
|---------------|-----------------|------------------|-------------------|
| Starter       | Last 7 days     | Last 4 weeks     |                 — |
| Business      | Last 7 days     | Last 8 weeks     | Last 12 months    |

##### Hourly schedules

These limits apply to Scalingo for OpenSearch® on Dedicated Resources and to
Scalingo for Valkey®.

| Service Class | Hourly Retention | Twelve-hourly Retention | Daily Retention |
|---------------|------------------|-------------------------|-----------------|
| Starter       | Last 8 hours     | Last 2 half-days        | Last 7 days     |
| Business      | Last 24 hours    | Last 4 half-days        | Last 14 days    |
| Enterprise    | Last 24 hours    | Last 8 half-days        | Last 30 days    |

### Manual Backups

Scalingo provides a manual backup service for supported database engines.
Manual backups consist in dumping the database to an archive which is retained
according to their [retention policy](#retention-policy-for-manual-backups).
This feature allows you to create a backup on demand, such as before an upgrade
or any important operation on your data.

#### Retention Policy for Manual Backups

Manual backup limits depend on how often Scalingo runs scheduled backups for
the database.

For databases with **[daily scheduled backups](#daily-schedules)**:

| Service Class | Backups Retained        |
|---------------|-------------------------|
| Starter       | Last 10 rolling backups |
| Business      | Last 50 rolling backups |
| Enterprise    | Last 50 rolling backups |

For databases with **[hourly scheduled backups](#hourly-schedules)**:

| Service Class | Backups Retained        |
|---------------|-------------------------|
| Starter       | Last 10 rolling backups |
| Business      | Last 10 rolling backups |
| Enterprise    | Last 10 rolling backups |

Manual backups are kept for an unlimited amount of time, as long as the number
of backups doesn't exceed the plan's limit. If creating a new backup exceeds
this limit, the oldest backup is automatically deleted.

When a database is deleted, a retention policy is retroactively applied to
all existing manual logical backups, based on their creation date. The retention
duration depends on the plan:

| Service Class | Retention Period |
|---------------|------------------|
| Starter       | 1 month          |
| Business      | 1 year           |
| Enterprise    | 1 year           |

If manual backups have already exceeded their retention period, they are deleted
immediately.

## Continuous backups

Continuous backups (Point-in-Time Recovery, PiTR) let you restore the database
to a specific point in time within a predefined **recovery window**. The
recovery window ranges from 7 to 30 days, depending on the service class and
architecture model.

Scalingo creates a full backup on a weekly basis and records database changes
between full backups.
To restore a database to a specific point in time, the platform restores a
full backup and replays the changes recorded up to that point.

Point-in-time recovery becomes available once the first full backup is complete.
This can take up to 24 hours.

Performing a Point-in-Time Recovery resets the continuous backup timeline. This
means the retention window starts over, and you won’t be able to restore from
an earlier point in time. Currently, Scalingo only supports a single timeline
in its recovery process.

Deleting a database permanently removes its continuous backup data.
After deletion, point-in-time recovery is no longer possible.

### Recovery Window for PiTR

The recovery window ranges from 7 to 30 days, depending on the service class and
architecture model.

| Architecture Model   | Starter | Business | Enterprise |
|----------------------|---------|----------|------------|
| Shared Resources     | 7 days  | 7 days   | —          |
| Dedicated Resources  | 7 days  | 14 days  | 30 days    |


## Monitoring Backups

The following events are available to monitor the backups:

| Event                       | Description                                       |
| --------------------------- | ------------------------------------------------- |
| `database_backup_succeeded` | A database backup has been successfully completed |
| `database_backup_failed`    | A database backup has failed                      |

The following events are available to monitor continuous backups for Point-in-Time
Recovery (PiTR):

| Event                               | Description |
| ----------------------------------- | ----------- |
| `database_continuousbackup_healthy` | Point-in-time recovery is available and restore points are up to date |
| `database_continuousbackup_delayed` | The latest restorable point is more than 12 hours old |
| `database_continuousbackup_stale`   | The latest restorable point is more than 24 hours old |

To learn more about events and notifiers, please visit the page dedicated to [app notifiers]({% post_url platform/app/2000-01-01-notifiers %}).

## Restoring a backup

The restore procedure depends on the database engine and architecture model.
Refer to the guide for your database:

- [Scalingo for PostgreSQL® (Dedicated Resources)]({% post_url databases/postgresql/dedicated-resources/guides/2000-01-01-restoring %})
- [Scalingo for PostgreSQL® (Shared Resources)]({% post_url databases/postgresql/shared-resources/guides/2000-01-01-restoring %})
- [Scalingo for MySQL® (Dedicated Resources)]({% post_url databases/mysql/dedicated-resources/guides/2000-01-01-restoring %})
- [Scalingo for MySQL® (Shared Resources)]({% post_url databases/mysql/shared-resources/guides/2000-01-01-restoring %})
- [Scalingo for OpenSearch®]({% post_url databases/opensearch/guides/2000-01-01-restoring %})
- [Scalingo for MongoDB®]({% post_url databases/mongodb/2000-01-01-start %}#backups)
- [Scalingo for Caching]({% post_url databases/redis/2000-01-01-start %}#backups)
- [Scalingo for Elasticsearch®]({% post_url databases/elasticsearch/2000-01-01-start %}#backups)
- [Scalingo for InfluxDB®]({% post_url databases/influxdb/2000-01-01-start %}#backups)


## Important Considerations

- All backups are encrypted and securely stored in our infrastructure. They are
  duplicated in the three availability zones of the region where the database
  is hosted.

- The time required to complete a backup depends on the amount of data being
  backed up. This operation may impact the performance of the database and, by
  extension, the application.

- On Business plans, logical backups are performed on the secondary instance to
  limit the impact on the primary instance.

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

  - Logical backups are only performed if the feature is enabled, which is the
    default setting. However, users can manually disable it if needed.
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
