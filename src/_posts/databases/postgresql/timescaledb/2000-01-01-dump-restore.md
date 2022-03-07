---
title: Dump and restore
nav: Dump and restore
modified_at: 2022-02-24 00:00:00
tags: timescale databases postgresql extensions dump restore
index: 2
---

{% warning %}
  The backup restoration process may put the database in an undesirable state.
{% endwarning %}

## Dump

You can use the command `pg_dump` as explained
[on our documentation]({% post_url databases/postgresql/2000-01-01-dump-restore %}).
But you cannot restore it on a PostgreSQL using TimescaleDB hosted on Scalingo.

The only dump available to make restorable backups on Scalingo hosted TimescaleDB
are the [on demand backups]({% post_url databases/postgresql/2000-01-01-start %}#on-demand-backups).
The reason is that the restoration process must be done by the Scalingo support using
these specific backups, see below.

Note that [Point-in-Time Recovery]({% post_url databases/postgresql/2000-01-01-start %}#point-in-time-recovery)
backups are still working normally.

## Restore

The backup restoration on TimescaleDB requires a specific process to be done on
the PostgreSQL database as it is explained on
[TimescaleDB official documentation](https://docs.timescale.com/timescaledb/latest/how-to-guides/backup-and-restore/pg-dump-and-restore/#restoring-an-entire-database-from-backup).
A temporary database should be used for the backup restore and the following
command should be executed using admin rights:
```sql
SELECT timescaledb_pre_restore();
\! pg_restore -Fc -d exampledb exampledb.psql
SELECT timescaledb_post_restore();
```
On Scalingo, default user does not have admin rights on database, this means that this
process must be done by an operator of the support.

## Warnings

Several points are important to take into account.

Make sure you keep track of which versions of PostgreSQL and TimescaleDB you are
running during backup process. For more information, see "Troubleshooting version mismatches" of
[official documentation](https://docs.timescale.com/timescaledb/latest/how-to-guides/backup-and-restore/pg-dump-and-restore/#tshoot-version-mismatch).

You cannot backup an individual hypertable, `pg_dump` creates dumps that do not
contain the information needed to properly restore the hypertable from a backup.

You can find more details on the
[TimescaleDB documentation: "logical backups with pg_dump and pg_restore"](https://docs.timescale.com/timescaledb/latest/how-to-guides/backup-and-restore/pg-dump-and-restore/).
