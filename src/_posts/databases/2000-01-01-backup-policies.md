---
title: Databases Backup Policies
nav: Backup Policies
modified_at: 2024-11-14 12:00:00
tags: databases backup policy policies
index: 2
---


## Overview

Scalingo offers several options for backing up and restoring your data,
depending on the service used. All backups are encrypted and securely stored in
our infrastructure, within the same region as the source database.

Note that this feature is not available with the Sandbox plan.


## Full Backups

Scalingo provides two backup options for databases in the Starter and Business
plans. Customers can either trigger manual backups at any time through the
dashboard or the CLI, or rely on the automated and scheduled backup service,
which runs every 24 hours.

### Important Considerations

The time required to complete a backup depends on the amount of data being
backed up. This operation may impact the performance of the database and, by
extension, the application. On Business Plans, backups are performed on the
secondary node to limit the impact on the primary node.

However, several factors can delay, cancel, or impact the backup process. These
include the database load, the volume of data stored, and the nature of the
queries running during the backup. The service is optimized for standard use,
but large datasets or specific operations may impede the backup's successful
execution. In such cases, we encourage users to contact Scalingo support to
explore alternative architectural solutions that could improve the scalability
of their applications.

#### Execution Conditions

Certain conditions may delay, cancel, or affect the consistency of the backup:

- Backups are only performed if the feature is enabled, which is the default
  setting. However, users can manually disable it if needed.
- The database must be in a running state at the scheduled time of the backup.
- No maintenance operations, whether scheduled or unscheduled, should be
  performed during backup time. The backup could otherwise be delayed or
  skipped entirely.
- Application-level locks or long-running transactions can prevent backups from
  executing, as these can block access to certain tables or resources needed
  during the backup process.
- The scheduled time is flexible: it might be delayed depending on the load on
  our infrastructure.

### Scheduled Backups

Scalingo provides a scheduled (or periodic) backup service for databases in the
Starter and Business plans. Available for all supported databases, scheduled
backups are performed every 24 hours. The start time can be customized through
the dashboard or via the API, enabling you to align backups with your workload
and core business operations.

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
| Sandbox  | None           | None            | None              |
| Starter  | 7 rolling days | 4 rolling weeks | None              |
| Business | 7 rolling days | 8 rolling weeks | 12 rolling months |

Deleting a database doesn’t immediately remove its scheduled backups. They
expire gradually according to their retention policy.

### Manual Backups

Scalingo provides a manual backup service for databases in the Starter and
Business plans. Available for all supported databases, this feature lets you
create a backup on demand, such as before an upgrade or any important operation
on your data.

#### Retention Policy for Manual Backups

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


## Point-in-Time-Recovery

Point-in-Time Recovery (PiTR) allows the restoration of your PostgreSQL®
database to any specific point in time within the last 7 days. This feature is
available for Starter and Business plans and provides an additional layer of
data protection by keeping continuous backups of your database's state.

{% note %}
Point-in-Time Recovery (PITR) technology operates independently of the
database's state, load, or size, making it a reliable solution for handling
large datasets. This feature offers a 7-day retention period without the usual
constraints of traditional backup methods.
{% endnote %}

### Important Considerations

- PiTR requires a first base backup to be completed before Write-Ahead Logs
  (WAL) can be captured and utilized for recovery. This initial base backup may
  take up to 24 hours, after which PiTR will begin monitoring changes for
  recovery purposes.
- Performing a Point-in-Time Recovery resets the continuous backup timeline.
  This means the retention window starts over, and you won’t be able to restore
  from an earlier point in time. Currently, Scalingo only supports a single
  timeline in its recovery process.

#### Retention Policy for PiTR

The PiTR retention window is 7 days. This means you can restore your database
to any point in time within the past week.
