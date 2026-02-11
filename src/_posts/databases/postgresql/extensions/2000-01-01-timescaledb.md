---
title: TimescaleDB®
nav: TimescaleDB®
modified_at: 2025-09-18 12:00:00
tags: databases postgresql timescaledb timeseries extensions
index: 30
---


TimescaleDB® is an open-source extension for PostgreSQL®. It is designed to make PostgreSQL
scalable for time series data.

This extension adds several features and functions. You can find more
information on the [official documentation][official_doc].


## TimescaleDB® at Scalingo

TimescaleDB® has some particularities which you should be aware of before
getting started.

- There are two licenses of TimescaleDB®: **Community** edition and
  **Open-Source** edition. The latter is the only one available on Scalingo.
  Hence TimescaleDB®'s functions labeled "*community*" on their documentation
  are not available on the platform.

- On Scalingo, TimescaleDB® requires a PostgreSQL® database version 13.6.0-1 or
  above.

- Working with a time series database usually involves the need to [downsample
  the dataset](#downsampling) in runtime and [remove the oldest data](#configuring-data-retention).
  We provide documentation about these topics below.

- While most documentation about PostgreSQL® remains applicable for
  TimescaleDB®, there are a few elements that differ. **Especially regarding
  [dumping](#dumping-and-restoring) and [restoring](#dumping-and-restoring) a
  TimescaleDB® database**.


## Enabling TimescaleDB®

To enable TimescaleDB®:

1. [Provision a new PostgreSQL® database][provisioning]
2. Access your database using the [Interactive Remote Console][irc]
3. [Enable the `timescaledb` extension][enabling-extension] using the following commands:

    From the PostgreSQL® console, run the following command:

    ```sql
    CREATE EXTENSION IF NOT EXISTS timescaledb;
    ```

    The output should look like this:

    ```bash
    CREATE EXTENSION
    my_app_4553=>
    ```

4. TimescaleDB® is now enabled and ready to be used!

## Downsampling

### Understanding Downsampling

Downsampling consists in decreasing the size of a dataset by selecting a subset
of the data at a reduced granularity compared to the original. The resulting
dataset has a much lower size, but still keeps its accuracy. This process
allows for easier analysis, storage, or computation.

To better understang the concept and benefits, we provide an example below.
This example is based on [TimescaleDB® official documentation][official_doc-downsampling].

The data is stored in a table called `conditions` that stores raw data of
`temperature` and `humidity` values.

We want to decrease the database size. To do so, we consider that we don't need
to have data by the minute for data older than one week. The average by hour is
enough past a week. We will use a **downsampling** logic which reduces the data
older than one week, and only stores the average by hour.

The data look like this:

```sql
$ select * from conditions;
             time              | location |    temperature     |      humidity
-------------------------------+----------+--------------------+--------------------
 2022-01-21 09:50:05.049911+00 | office   |                 75 |                 52
 2022-01-21 09:50:05.058412+00 | office   |                 70 |                 57
 2022-01-21 09:50:05.059489+00 | office   |                 76 |                 52
 2022-01-20 09:50:05.06032+00  | office   |                 79 |                 54
```

### Creating the Downsampling Procedure

1. From the command line, open an [Interactive Remote Console][irc] to access
   your database
2. From the database command line, run the following commands to create a
   procedure which aims at downsampling the `conditions` table:
   ```sql
   CREATE OR REPLACE PROCEDURE downsample_conditions (config jsonb)
   LANGUAGE PLPGSQL
   AS $$
   DECLARE
     lag interval;
     chunk REGCLASS;
     tmp_name name;
   BEGIN
     SELECT jsonb_object_field_text (config, 'lag')::interval INTO STRICT lag;

     IF lag IS NULL THEN
       RAISE EXCEPTION 'Config must have lag';
     END IF;

     FOR chunk IN
       SELECT show.oid
       -- we specify the table which need to be downsampled
       FROM show_chunks('conditions', older_than => lag) SHOW (oid)
         INNER JOIN pg_class pgc ON pgc.oid = show.oid
         INNER JOIN pg_namespace pgns ON pgc.relnamespace = pgns.oid
         INNER JOIN timescaledb_information.chunks chunk ON chunk.chunk_name = pgc.relname
           AND chunk.chunk_schema = pgns.nspname
     LOOP
       RAISE NOTICE 'Processing chunk: %', chunk::text;

       -- build name for temp table
       SELECT '_tmp' || relname
       FROM pg_class
       WHERE oid = chunk INTO STRICT tmp_name;

       -- copy downsampled chunk data into temp table
       EXECUTE format($sql$ CREATE UNLOGGED TABLE %I AS
         -- you can configure here the time range to aggregate data and how you do it. Here we used `avg` function on 1 hour
         SELECT time_bucket('1h', time), location, avg(temperature) as avg_temperature, avg(humidity) as avg_humidity FROM %s GROUP BY 1, 2;
       $sql$, tmp_name, chunk);

       -- clear original chunk
       EXECUTE format('TRUNCATE %s;', chunk);

       -- copy downsampled data back into chunk
       EXECUTE format('INSERT INTO %s(time, location, temperature, humidity) SELECT * FROM %I;', chunk, tmp_name);

       -- drop temp table
       EXECUTE format('DROP TABLE %I;', tmp_name);

       COMMIT;
     END LOOP;
   END
   $$;
   ```

### Executing the Downsampling Procedure

1. At the root of your applications's source code, create a file called
   `downsample_conditions_table.sql` containing the following SQL script:
   ```sql
   call downsample_conditions(config => '{"lag":"3 week", "period":"1 hour"}');
   ```
   This script invokes [the procedure `downsample_conditions`](#creating-the-downsampling-procedure)
   and applies it for data older than three weeks and on a period of one hour.
2. Schedule the execution of the SQL script by using the [Scalingo
   scheduler][scalingo-scheduler]. Your `cron.json` file at the root of your
   application’s source code should look like this:
   ```json
   {
     "jobs": [
       {
         "command": "0 0 * * * dbclient-fetcher psql && psql $SCALINGO_POSTGRESQL_URL -f downsample_conditions_table.sql",
         "size": "S"
       }
     ]
   }
   ```
   The scheduled task will be executed every day at midnight.


## Configuring Data Retention

### Understanding Data Retention

A data retention policy aims at deleting old data from the database to save
space. This can lead to faster queries and less storage costs. The policy
defines what to do with the data and when.

To better understand the concept and benefits, we provide an example below.
This example creates a retention policy which applies on **all** hypertables.
It is possible to customize how it works by changing the `format` function
depending on your data, or add a filter using a `WHERE` clause in the `PERFORM`
query.

### Creating the Data Retention Policy

1. From the command line, open an [Interactive Remote Console][irc] to access
   your database
2. From the database command line, run the following commands to create a
   procedure which aims at removing data older than `drop_after`:
   ```sql
   CREATE OR REPLACE PROCEDURE generic_retention (config jsonb)
   LANGUAGE PLPGSQL
   AS $$
   DECLARE
     drop_after interval;
       schema varchar;
       name varchar;
   BEGIN
     SELECT jsonb_object_field_text (config, 'drop_after')::interval INTO STRICT drop_after;

     IF drop_after IS NULL THEN
       RAISE EXCEPTION 'Config must have drop_after';
     END IF;

     -- You can modify the following query to add a more precise retention policy.
     FOR schema, name IN SELECT hypertable_schema, hypertable_name FROM timescaledb_information.hypertables
     LOOP
       RAISE NOTICE '%', format('%I.%I', schema, name);
       PERFORM drop_chunks(format('%I.%I', schema, name), older_than => drop_after);
       COMMIT;
     END LOOP;
   END
   $$;
   ```

### Executing the Data Retention Policy

1. At the root of your applications's source code, create a file called
   `data_retention_procedure.sql` containing the following SQL script:
   ```sql
   call generic_retention(config => '{"drop_after":"12 month"}');
   ```
   This script invokes [the procedure `generic_retention`](#creating-the-data-retention-policy)
   to remove data older than 12 months.
2. Schedule the execution of the SQL script by using the [Scalingo
   scheduler][scalingo-scheduler]. Your `cron.json` file at the root of your
   application’s source code should look like this:
   ```json
   {
     "jobs": [
       {
         "command": "0 0 * * * dbclient-fetcher psql && psql $SCALINGO_POSTGRESQL_URL -f data_retention_procedure.sql",
         "size": "S"
       }
     ]
   }
   ```
   The scheduled task will be executed every day at midnight.


## Dumping and Restoring

{% warning %}
The backup restoration process may put the database in an undesirable state.
{% endwarning %}

### Dumping Your TimescaleDB®

[The procedure to dump data for PostgreSQL®][dumping] is applicable. Yet,
**you won't be able to restore** this dump on a TimescaleDB® instance hosted on
Scalingo.

For more details, please see [Restoring a TimescaleDB® Dump](#restoring-a-timescale-dump).

Also, please note that you can't backup individual hypertable. `pg_dump`
creates dumps that do not contain the information needed to properly restore
hypertables.

### Restoring a TimescaleDB® Dump

As explained in [TimescaleDB® official documentation][official_doc-restoring],
a specific process must be followed to restore from a backup. This process
includes the use of a temporary database and the execution of several commands
using admin rights, such as:

```sql
SELECT timescaledb_pre_restore();
\! pg_restore -Fc -d exampledb exampledb.psql
SELECT timescaledb_post_restore();
```

On Scalingo, default users do not have admin rights on their database.
Consequently, **only [Scheduled backups][backup_policies-scheduled] are
restorable** and **the restoration process must be done by the Scalingo support
team**.

Make sure you keep track of which versions of PostgreSQL® and TimescaleDB® you
are running during the backup process. For more information, see
["Troubleshooting version mismatches" in the official
documentation][official_doc-version-mismatch].

For more details about dumping and restoring TimescaleDB®, please refer to [the
official documentation][official_doc-backup-restore].

{% note %}
[Point-in-Time Recovery backups][backup_policies-pitr]
are still working normally and can be restored [following the procedure for
PostgreSQL®][restoring-pitr].
{% endnote %}


[official_doc]: https://docs.timescale.com/getting-started/latest/
[official_doc-downsampling]: https://docs.timescale.com/timescaledb/latest/how-to-guides/user-defined-actions/example-downsample-and-compress/#downsample-and-compress
[official_doc-backup-restore]: https://docs.timescale.com/timescaledb/latest/how-to-guides/backup-and-restore/pg-dump-and-restore/
[official_doc-restoring]: https://docs.timescale.com/timescaledb/latest/how-to-guides/backup-and-restore/pg-dump-and-restore/#restoring-an-entire-database-from-backup
[official_doc-version-mismatch]: https://docs.timescale.com/timescaledb/latest/how-to-guides/backup-and-restore/pg-dump-and-restore/#tshoot-version-mismatch

[scalingo-scheduler]: {% post_url platform/app/task-scheduling/2000-01-01-scalingo-scheduler %}

[backup_policies-pitr]: {% post_url databases/about/2000-01-01-backup-policies %}#point-in-time-recovery-backups
[backup_policies-scheduled]: {% post_url databases/about/2000-01-01-backup-policies %}#scheduled-backups

[irc]: {% post_url databases/postgresql/getting-started/2000-01-01-accessing %}#using-the-interactive-remote-console
[provisioning]: {% post_url databases/postgresql/getting-started/2000-01-01-provisioning %}
[enabling-extension]: {% post_url databases/postgresql/extensions/2000-01-01-managing-extensions %}#enabling-an-extension
[dumping]: {% post_url databases/postgresql/guides/2000-01-01-backing-up %}#dumping-the-database
[restoring-pitr]: {% post_url databases/postgresql/guides/2000-01-01-restoring %}#restoring-a-point-in-time-recovery-backup
