---
title: Limitations
nav: Limitations
modified_at: 2025-06-10 12:00:00
tags: addon database postgresql
index: 10
---


As Scalingo for PostgreSQL® is a fully managed service, we enforce certain
operational limits and usage policies to maintain reliability and security for
all users.


## Affecting User Management

- Updating the [protected user][postgresql-protected-user]'s password is not
  supported. Please get in touch with our support team to refresh this
  password.


## Affecting Backups and Restorations

- When restoring from a Point-in-Time Recovery backup, PostgreSQL® switches to
  a new [timeline][postgresql-timelines]. Consequently, you **must not**
  restore from another PiTR backup created before the restoration date and
  time.


## Affecting Features

- When using a Business or Enterprise plan, the replica instance of the cluster 
  is not accessible. This instance is only present to ensure high-availability.
  It's not meant to plug analysis tools, even in read-only mode.

- Only one named database is provisioned per addon. [PostgreSQL®'s
  schemas][postgresql-schemas] can be leveraged to create different logical
  groups of database objects (i.e. tables, views, functions, etc.)


## Affecting Extensions

- The `pg_repack` extension requires superuser permissions and thus, can
  only be run by our operators. Please get in touch with our support team to
  plan the operation.


## Timeouts

Scalingo for PostgreSQL® addons have, depending on the plan, one or two HAProxy
instances as entry point. These HAProxy instances have a few timeouts
configured which may impact your application, especially when reusing
connections.

| Context                                    | Timeout    |
| ------------------------------------------ | ---------- |
| Client is inactive                         | 1 day      |
| Server is inactive                         | 30 minutes |
| Half-closed connections on the client side | 5 minutes  |


[postgresql-protected-user]: {% post_url databases/postgresql/guides/2000-01-01-managing-users %}#understanding-protected-user
[postgresql-timelines]: https://www.postgresql.org/docs/current/continuous-archiving.html#BACKUP-TIMELINES
[postgresql-schemas]: https://www.postgresql.org/docs/current/ddl-schemas.html
