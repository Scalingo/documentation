---
title: Troubleshooting Scalingo for PostgreSQL
nav: Troubleshooting
modified_at: 2023-12-01 00:00:00
tags: databases postgresql addon
index: 9
---

## Identifying Performances Issues


## Understanding Idle Queries

PostgreSQL® tends to use all the available memory if there is enough indices to
fill the memory. If there is too many indices to fit into the memory, some of
them are stored on the disk. In this situation, queries needing these indices
will be slowed down. PostgreSQL® first needs to load the indices from the disk
into the RAM which takes some time. The memory usage on the "Metrics" tab of
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
