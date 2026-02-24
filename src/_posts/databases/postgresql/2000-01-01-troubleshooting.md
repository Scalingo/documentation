---
title: Troubleshooting Scalingo for PostgreSQL®
nav: Troubleshooting
modified_at: 2024-03-13 12:00:00
tags: databases postgresql addon
index: 30
---

## Understanding Memory Consumption

PostgreSQL® optimizes database performance by effectively using all available
memory. It stores frequently accessed data in memory to reduce the need for
disk reads and writes, speeding up query processing. This approach not only
enhances the system's efficiency but also requires careful memory management to
prevent the system from using swap memory.

Swapping can significantly slow down database operations (as accessing data
from swap is slower than accessing data from RAM). To avoid such situations,
PostgreSQL® is designed to maximize its memory usage without resorting to swap,
ensuring both high performance and system stability.

In addition to managing memory to avoid swap usage, PostgreSQL® strategically
employs temporary files to handle complex queries that require more resources
than available in memory. This use of temporary disk storage helps manage large
sorting or hashing operations without overburdening the system's memory,
thereby maintaining performance without resorting to swap memory usage.

Consequently, it's not necessarily an issue that 100% of the RAM is used. It's
also perfectly fine to have only a few slower queries when indices are stored
on disk because they are not used that often.

## Understanding I/O Peaks

In the metrics available in your database dashboard, you may notice I/O peaks,
particularly for read operations. Those peaks can often be attributed to a few
common factors:
- One primary reason could be insufficient memory. When the database cannot
  hold enough of its working set in memory, it resorts to frequent disk reads
  and writes, leading to high I/O.
- Another potential cause is executing queries that retrieve large amounts of
  data, especially if these operations are not optimized or if the resulting
  dataset size exceeds the available memory.
- Additionally, a lack of proper indexing can lead to inefficient query
  execution, forcing PostgreSQL® to perform full table scans instead of quick
  index lookups, significantly increasing I/O load.

## Understanding Idle Queries

Some queries are considered idling by PostgreSQL®. To display these queries you
need to enable them with the toggle on the Running Queries tab. These idle
queries should not be considered a _bad thing_. As stated in the PostgreSQL®
[mailing list](https://postgrespro.com/list/id/CAC6ry0LFHv+eMjpde_3jqfSnG9hg2O6s=9VTwLh2jiYydXSqGg@mail.gmail.com):

> "idle" means the client is not currently executing a query nor in a
  transaction. If [the start date] is 2 days old, that just means the last
  query to be executed on that connection was two days ago. [...] It's
  generally desirable for a connection pool to have a few idle connections so
  queries don't suffer the latency of establishing a new connection.

## Identifying Performances Issues

The `pg_stat_statements` extension of PostgreSQL® allows to gather a lot of
useful statistics about queries. It's an unvaluable source of information,
allowing to identify which queries are performing slowly or poorly and why.

A few columns of the provided `pg_stat_statements` view are especially useful
when chasing for potential issues with queries:
- **`calls`**:
  number of times the query was executed.
- **`total_exec_time`**:
  total time spent executing the query, in milliseconds.
- **`mean_exec_time`**:
  mean time spent executing the query, in milliseconds.
- **`shared_blks_hit`**:
  total number of shared block cache hits by the query.
- **`shared_blks_read`**:
  total number of shared blocks that had to be read from the disk to satisfy
  the query.

For an exhaustive list of columns and their usage, please refer to [the
official PostgreSQL® documentation](https://www.postgresql.org/docs/current/pgstatstatements.html#PGSTATSTATEMENTS-PG-STAT-STATEMENTS).

Also note that **all values are cumulative** since the last time the service
has been (re)started.

### Identifying Most Expensive Queries

A good starting point when trying to spot potential performance problems
consists in listing the queries that are the most time-consuming.

The following statement lists the 10 slowest queries that have been executed
more than 200 times (since the latest (re)start). We don't mind slow queries
that only get executed very infrequently. This 200 threshold can (should)
be fine-tuned depending on your needs and usage.

While it's clearly not a silver bullet, this query can still help finding
queries that could merit attention or further investigations.

1. Make sure the `pg_stat_statements` extension [is enabled]({% post_url databases/postgresql/shared-resources/guides/2000-01-01-monitoring %}#exploring-query-statistics)
2. [Access your PostgreSQL database]({% post_url databases/postgresql/shared-resources/getting-started/2000-01-01-accessing %})
3. Run the following query:
   ```sql
   WITH pss AS (
       SELECT * FROM pg_stat_statements
           JOIN pg_roles ON (userid=oid)
       WHERE rolname = current_user
   )
   SELECT ROUND(( 100 * total_exec_time / SUM(total_exec_time) OVER())::NUMERIC, 2) AS percent,
       calls,
       ROUND(total_exec_time::NUMERIC, 2) AS total,
       ROUND(mean_exec_time::NUMERIC, 2) AS mean,
       SUBSTRING(query, 1, 60) AS query
   FROM pss
   WHERE calls > 200
   ORDER BY percent DESC
   LIMIT 10;
   ```

### Identifying Queries With a Low Cache Hit Ratio

[As seen previously](#understanding-memory-consumption), relying on swap usage and excessive disk reads can significantly impact your database performance. Consequently,
measuring the number of times a query has to read data from the disk instead of
fetching it from the cache (stored in memory) can help identify non-optimal queries.

The following statement computes the *cache hit ratio*: a measurement that
quantifies the proportion of queries fully satisfied by only hitting the cache.

A high cache hit ratio indicates that a significant portion of the required
data is already in the cache, leading to efficient query performance. On the
other hand, a low cache hit ratio suggests that the query is not sufficiently
benefiting from cached data, potentially resulting in slower performance and
more disk I/O operations.

For queries that run very oftently, the cache hit ratio should ideally neighbor
`100%`.

As we don't consider slow query that only run once in a while as being an
issue, we added an arbitrary threshold of 200 calls in the `WHERE` clause. Feel
free to adjust this depending on your usage.

1. Make sure the `pg_stat_statements` extension [is enabled]({% post_url databases/postgresql/shared-resources/guides/2000-01-01-monitoring %}#exploring-query-statistics)
2. [Access your PostgreSQL database]({% post_url databases/postgresql/shared-resources/getting-started/2000-01-01-accessing %})
3. Run the following query:
   ```sql
   WITH pss AS (
       SELECT * FROM pg_stat_statements
           JOIN pg_roles ON (userid=oid)
       WHERE rolname = current_user
   )
   SELECT calls,
       shared_blks_hit,
       shared_blks_read,
       ( 100 * shared_blks_hit / NULLIF(shared_blks_hit + shared_blks_read, 0)::NUMERIC ) AS cache_hit_ratio,
       SUBSTRING(query, 1, 60) AS query
   FROM pss
   WHERE calls > 200
   ORDER BY cache_hit_ratio DESC
   LIMIT 10;
   ```

## Solving Performance Issues

Identifying the reasons for a slow query can involve various factors. There is
no single answer to a performance issue. Here are the most common reasons why
your PostgreSQL® database might not be performing as well as you would want,
along with some general steps to address them:

### Inefficient Query

- Ensure your SQL queries are properly designed and optimized to retrieve only
  necessary data.
- Use the [`EXPLAIN` keyword](https://www.postgresql.org/docs/current/sql-explain.html)
  (or `EXPLAIN ANALYZE`) to see the query execution plan. Analyze it to find
  bottlenecks or missing indexes.

### Lack of Indexes

- Ensure that the columns involved in your statement's `WHERE`, `JOIN`, and
  `ORDER BY` clauses have appropriate indexes.
- Use the `CREATE INDEX` statement to create appropriate indexes on columns
  that are frequently used in search conditions.

### Large Result Sets

- If your query returns a large number of rows, consider fetching only the
  necessary columns and limit the result set using the `LIMIT` clause.
- Implement pagination by using the `LIMIT` and `OFFSET` clauses to retrieve
  smaller chunks of data.

### Insufficient Resources

- Check the metrics of your database and verify that your database is
  provisioned with enough CPU and memory to handle your workload.
- Monitor these metrics during query execution to identify potential resource
  bottlenecks.

### Use Connection Pooling

- Implement connection pooling to reuse database connections, reducing the
  overhead of establishing a new connection for each query.
