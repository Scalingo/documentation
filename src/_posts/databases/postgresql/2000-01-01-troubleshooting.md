---
title: Troubleshooting Scalingo for PostgreSQL®
nav: Troubleshooting
modified_at: 2024-01-04 12:00:00
tags: databases postgresql addon
index: 9
---

## Identifying Performances Issues


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

Consequently, it's not necessarily an issue that 100% of the RAM is used. It's
also perfectly fine to have only a few slower queries when indices are stored
on disk because they are not used that often.

## Understanding I/O Peaks

In the metrics available in your database dashboard, you may notice I/O peaks,
particularly for read operations. Those peaks can often be attributed to a few
common factors:
- One primary reason could be insufficient memory. When the database cannot
  hold enough of its working set in memory, it resorts to frequent disk reads
  and writes (swap), leading to high I/O.
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
