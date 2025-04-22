---
title: Troubleshooting Scalingo for MySQL®
nav: Troubleshooting
modified_at: 2024-04-23 12:00:00
tags: databases mysql addon
index: 9
---

## Understanding Memory Consumption

MySQL® uses several strategies to efficiently manage data and optimize
performances. Among them, MySQL® (and more specifically InnoDB) maintains a
storage area called *Buffer Pool* for caching data, indexes, and other
auxiliary buffers in memory. This cache helps reduce disk I/O, and, thus, speed
up query execution.

Scalingo for MySQL® instances typically allocate:
- ~50% of the memory to the [Buffer Pool](https://dev.mysql.com/doc/refman/8.0/en/innodb-buffer-pool-resize.html)
- ~37.5% to [Connection Management](https://dev.mysql.com/doc/refman/8.0/en/connection-management.html)
- ~12.5% to [Group Replication](https://dev.mysql.com/doc/refman/8.0/en/group-replication.html)

MySQL® generally tries to avoid swapping to disk because disk I/O is
significantly slower than memory access. However, if the system is under
memory pressure, the underlying operating system can decide to swap out MySQL®
memory pages to disk, leading to performance degradation and increased latency.

As a consequence, the size of the Buffer Pool should ideally be large enough to
handle the database workload, thus preventing swap usage. A constantly swapping
database could indicate that the space dedicated to the Buffer Pool has become
insufficient. In such a case, [switching to a superior plan]({% post_url databases/mysql/2000-01-01-changing-plan %})
should quickly resolve the swapping issue.

For further details about how MySQL® manages memory, please refer to [the
official documentation](https://dev.mysql.com/doc/refman/8.0/en/memory-use.html).


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
  execution, forcing MySQL® to perform full table scans instead of quick
  index lookups, significantly increasing I/O load.


## Identifying Performances Issues

### Identifying Most Expensive Queries

A good starting point when trying to spot potential performance problems
consists in identifying the queries that are the most time-consuming.

The default MySQL® configuration provided by Scalingo logs slow queries. A
query is considered slow if it takes more than 2 seconds to execute. So, the
very first action to take when chasing expensive queries would be to find
problematic query statements by [viewing your database logs]({% post_url databases/mysql/2000-01-01-monitoring %}#inspecting-database-logs).

Here is an example of a slow query log:

```text
2024-03-07 16:02:11.224378809 +0100 CET [mysql-1] # Time: 2024-03-07T15:02:11.223955Z
2024-03-07 16:02:11.224396794 +0100 CET [mysql-1] # User@Host: my_app_4553[my_app_4553] @  [192.168.100.3]  Id: 23004
2024-03-07 16:02:11.224397505 +0100 CET [mysql-1] # Query_time: 10.000321  Lock_time: 0.000000 Rows_sent: 1  Rows_examined: 1
2024-03-07 16:02:11.224398023 +0100 CET [mysql-1] SET timestamp=1709823725;
2024-03-07 16:02:11.224398826 +0100 CET [mysql-1] SELECT SLEEP(10);
```

### Identifying a Low Cache Hit Ratio

[As seen previously](#understanding-memory-consumption), relying on swap usage
and excessive disk reads can significantly impact your database performance.
Consequently, measuring the number of times the database has to read data from
the disk instead of fetching it from the cache (stored in memory) can help
identify non-optimal queries or inappropriate configuration.

The following instructions allow to compute the *cache hit ratio*: a
measurement that quantifies the proportion of queries fully satisfied by only
hitting the cache.

A high cache hit ratio indicates that a significant portion of the required
data is already in the cache, leading to efficient query performance. On the
other hand, a low cache hit ratio suggests that the query is not sufficiently
benefiting from cached data, potentially resulting in slower performance and
more disk I/O operations.

**For queries that run very oftently**, the cache hit ratio should ideally
neighbor `100%`.

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, open a console for your MySQL® addon: 
   ```bash
   scalingo --app my-app mysql-console
   ```
3. Run the following query:
   ```sql
   SELECT ((g1.VARIABLE_VALUE - g2.VARIABLE_VALUE) * 100.0 / g1.VARIABLE_VALUE) AS ratio
   FROM performance_schema.global_status g1
   INNER JOIN performance_schema.global_status g2
   WHERE g1.VARIABLE_NAME = 'Innodb_buffer_pool_read_requests'
   and g2.VARIABLE_NAME = 'Innodb_buffer_pool_reads';
   ```

The resulting value represents the percentage of requests that were satisfied
from the InnoDB buffer pool cache without requiring a physical disk read. While
this ratio **can** give some insights, **it must be taken with care**:
- The numbers are given for all queries that have been executed since the
  latest start. There is no way to identify which specific queries are
  responsible for these numbers.
- A query that run only once in a while and fetches data from disk (hence being
  slow) is perfectly fine and should not be considered an issue. These numbers
  and this ratio completely obfuscate such queries.


## Solving Performance Issues

Identifying the reasons for a slow query can involve various factors. There is
no single answer to a performance issue. Here are the most common reasons why
your MySQL® database might not be performing as well as you would want, along
with some general steps to address them:

### Inefficient Query

- Ensure your SQL queries are properly designed and optimized to retrieve only
  necessary data.
- Use the [`EXPLAIN` keyword](https://dev.mysql.com/doc/refman/8.0/en/using-explain.html)
  to see the query execution plan. Analyze it to find bottlenecks or missing
  indexes.

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
