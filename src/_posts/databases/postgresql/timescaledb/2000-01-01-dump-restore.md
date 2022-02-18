---
title: TimescaleDB
nav: Dump and restore
modified_at: 2022-02-18 00:00:00
tags: timescale databases postgresql extensions dump restore
index: 2
---

{% warning %}
  The backup restoration process may put the database in an undesirable state.
  Pay attention to the restoration process.
{% endwarning %}

## Dump

The only dump available of a PostgreSQL using the TimescaleDB extension are the
[on demand backups]({% post_url databases/postgresql/2000-01-01-start %}#on-demand-backups).
The reason is that the restoration process must be done by the Scalingo support using
these specific backups, see below.

Note that [Point-in-Time Recovery]({% post_url databases/postgresql/2000-01-01-start %}#point-in-time-recovery)
backups are still working normally.

## Restore

The backup restoration on TimescaleDB requires a preparation of the PostgreSQL database
which needs admin rights. That's why you have to ask our support to handle the process.
Please, specify in your support request the timestamp of the backup.

## Warnings

Several points are important to take into account.

It may happen some trouble due to a PostgreSQL and TimescaleDB version mismatch
between the time the backup was made and the database you are trying to restore to.

You cannot backup an individual hypertable, `pg_dump` creates dumps that do not
contain the information needed to properly restore the hypertable from a backup.

You can find more details on the
[TimescaleDB documentation: "logical backups with pg_dump and pg_restore"](https://docs.timescale.com/timescaledb/latest/how-to-guides/backup-and-restore/pg-dump-and-restore/).
