---
title: Data Retention
modified_at: 2022-01-21 00:00:00
tags: timescale databases postgresql extensions data retention
---

A data retention policy aims at removing data older than a certain duration from the database.

# Example

Below an example of a retention policy which applies on __all__ hypertables.
It is possible to customize how it works by changing the `format` function according to your
data or add filter using `WHERE` clause in the `PERFORM` query.

```sql
CREATE OR REPLACE PROCEDURE generic_retention (config jsonb)
LANGUAGE PLPGSQL
AS $$
DECLARE
  drop_after interval;
BEGIN
  SELECT jsonb_object_field_text (config, 'drop_after')::interval INTO STRICT drop_after;

  IF drop_after IS NULL THEN
    RAISE EXCEPTION 'Config must have drop_after';
  END IF;

  -- You can modify the following query to add a more precise retention policy.
  PERFORM drop_chunks(format('%I.%I', table_schema, table_name), older_than => drop_after)
    FROM timescaledb_information.hypertables;
END
$$;
```


## Execute Procedure

You can schedule the execution of the previous procedure by using the
[Scalingo scheduler]({% post_url platform/app/task-scheduling/2000-01-01-scalingo-scheduler %}).
To do so, add a `cron.json` file at the root of your application’s source code,
containing the code below:

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

The scheduled task will be executed every day at midnight. And execute a `psql`
command that invokes a SQL script called `data_retention_procedure.sql`.

Create this SQL script file at the root of your application's source code containing
the code below:

```sql
call generic_retention(config => '{"drop_after":"12 month"}');
```

This script invokes the created procedure `generic_retention` to remove the data
older than twelve months.
