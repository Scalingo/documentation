---
title: Databases Backup Policies
nav: Backup Policies
modified_at: 2024-12-04 12:00:00
tags: databases backup policy policies explanation
index: 2
---


{% warning %}
The backup features described in this page are only available for Starter and
Business plans.\
They are **not** available for Sandbox plans.
{% endwarning %}

Scalingo provides at least two different backup mechanisms for every database
addons in Starter or Business plans:
- [Scheduled backups](#scheduled-backups) rely on our automated backup service
  to create a full backup of your database every 24 hours.
- [Manual backups](#manual-backups), as the name implies, can be leveraged at
  any time to manually trigger the creation of a new full backup.


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


## Scheduled Backups

Scalingo provides a scheduled backup service for all our databases addons in
Starter and Business plans. Scheduled backups are done on a daily basis, every
24 hours. They consist in dumping the database to an archive that is kept
during a [certain amount of time](#retention-policy-for-scheduled-backups).

The start time can be customized using the dashboard or our Command Line tool,
enabling you to align backups with your workload and core business operations.

### Retention Policy for Scheduled Backups

We retain a limited number of backups based on your database plan:

- **Daily backups**: one backup is retained for each of the last 7 days, for a
  total of 7 backups.
- **Weekly backups**: the daily backup taken on Sunday is retained as the
  weekly backup.
- **Monthly backups**: the daily backup from the first Sunday of the month is
  retained as the monthly backup.

| Plan     | Daily Backups  | Weekly Backups  | Monthly Backups   |
| -------- | -------------- | --------------- | ----------------- |
| Sandbox  | None           | None            | None              |
| Starter  | 7 rolling days | 4 rolling weeks | None              |
| Business | 7 rolling days | 8 rolling weeks | 12 rolling months |

Deleting a database doesn't immediately remove its scheduled backups. They
expire gradually according to their retention policy.


## Manual Backups

Scalingo provides a manual backup service for databases in the Starter and
Business plans. Manual backups consist in dumping the database to an archive
that is kept during a [certain amount of time](#retention-policy-for-manual-backups).
This feature allows you to create a backup on demand, such as before an upgrade
or any important operation on your data.

### Retention Policy for Manual Backups

The number of manual backups you can store is limited by your plan (see below).
Manual backups are kept for an unlimited amount of time, as long as the number
of backups doesn't exceed the plan's limit. If creating a new backup exceeds
this limit, the oldest backup is automatically deleted.

| Plan     | Backups Retained        |
| -------- | ----------------------- |
| Sandbox  | None                    |
| Starter  | Last 10 rolling backups |
| Business | Last 50 rolling backups |

When a database is deleted, a retention policy is retroactively applied to
all existing manual backups, based on their creation date. The retention
duration depends on the plan:

| Plan     | Retention Duration |
| -------- | ------------------ |
| Sandbox  | None               |
| Starter  | 1 month            |
| Business | 1 year             |

If manual backups have already exceeded their retention period, they are
deleted immediately.


## Point-in-Time-Recovery Backups

Point-in-Time Recovery (PiTR) is a feature **exclusive to PostgreSQL®**
allowing the restoration of your PostgreSQL® database to any specific point in
time **within the last 7 days**. This feature is available for Starter and
Business plans only and provides an additional layer of data protection by
keeping continuous backups of your database's state.

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

### Retention Policy for PiTR

The PiTR retention window is 7 days. This means you can restore your database
to any point in time within the past week.
