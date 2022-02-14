---
title: Downsampling
modified_at: 2022-01-21 00:00:00
tags: timescale databases postgresql extensions downsampling
---

The downsampling reduces the amount of data by compressing the old values.

## Example

Below an example of a logic of downsampling. It is based on [TimescaleDB documentation](https://docs.timescale.com/timescaledb/latest/how-to-guides/user-defined-actions/example-downsample-and-compress/#downsample-and-compress).

The data is stored in a table `conditions`, composed by `temperature` and `humidity`
value. This is a use case where a table is composed of raw data.

We want to decrease the database size. We don't need to have data by the
minute for data older than one week, the average of values by hour is enough.
So we can use a downsampling logic which reduces the data older than one week,
and only stores the average by hour.


### Data

For the following table:

```
$ select * from conditions;
             time              | location |    temperature     |      humidity
-------------------------------+----------+--------------------+--------------------
 2022-01-21 09:50:05.049911+00 | office   |                 75 |                 52
 2022-01-21 09:50:05.058412+00 | office   |                 70 |                 57
 2022-01-21 09:50:05.059489+00 | office   |                 76 |                 52
 2022-01-20 09:50:05.06032+00  | office   |                 79 |                 54
```

### Downsample Procedure

The procedure below contains the logic to downsample the table `conditions`

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

### Execute Procedure

You can schedule the execution of the previous procedure by using the
[Scalingo scheduler]({% post_url platform/app/task-scheduling/2000-01-01-scalingo-scheduler %}).
Add a `cron.json` file at the root of your application’s source code,
containing the code below:

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

The scheduled task will be executed every day at midnight. And execute a `psql`
command that invoke a SQL script called `downsample_conditions_table.sql`.

Create this SQL script file at the root of your application's source code containing
the code below:

```sql
call downsample_conditions(config => '{"lag":"3 week", "period":"1 hour"}');
```

This script invokes the created procedure `downsample_conditions` to apply it for
the data older than three weeks and on a period of one hour.
