---
title: Troubleshooting Scalingo for PostgreSQL
nav: Troubleshooting
modified_at: 2023-12-01 00:00:00
tags: databases postgresql addon
index: 9
---

## Identifying Performances Issues


## Understanding Idle Queries

PostgreSQL optimizes database performance by effectively using all available memory. It stores frequently accessed data in memory to reduce the need for disk reads and writes, speeding up query processing. This approach not only enhances the system's efficiency but also requires careful memory management to prevent the system from using swap memory. Excessive usage of swap memory can significantly slow down database operations, so PostgreSQL is designed to maximize its memory usage without resorting to swap, ensuring both high performance and system stability.
your web dashboard would always be at 100% in such situation.


## Understanding Memory Consumption

Some of these queries are considered idling by PostgreSQL®. To display these
queries you need to enable them with the toggle on the Running Queries tab.
These idle queries should not be considered a _bad thing_. As
stated on the PostgreSQL® [mailing list](https://postgrespro.com/list/id/CAC6ry0LFHv+eMjpde_3jqfSnG9hg2O6s=9VTwLh2jiYydXSqGg@mail.gmail.com):

> "idle" means the client is not currently executing a query nor in a
  transaction. If [the start date] is 2 days old, that just means the last
  query to be executed on that connection was two days ago. [...] It's
  generally desirable for a connection pool to have a few idle connections so
  queries don't suffer the latency of establishing a new connection.
