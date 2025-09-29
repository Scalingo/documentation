---
title: Limitations
nav: Limitations
modified_at: 2025-09-25 12:00:00
tags: addon database mysql
index: 4
---


As Scalingo for MySQL® is a fully managed service, we enforce certain
operational limits and usage policies to maintain reliability and security for
all users.


## Affecting User Management

- Updating the [protected user][mysql-protected-user]'s password is not
  supported. Please get in touch with our support team to refresh this
  password.


## Affecting Features

- When using a Business plan, the secondary nodes of the cluster are not
  accessible. These instances are only present to ensure high-availability.
  There are not meant to plug analysis tools, even in read-only mode.


## Requirements

- Starting with MySQL® version 8, every table must have a primary key.\\
  Here is an example of a SQL statement adding a new column and setting it as
  primary (impact of this modification must be evaluated before proceeding):
  
  ```sql
  ALTER TABLE 'foo' ADD COLUMN <column name> PRIMARY KEY;
  ```


## Timeouts

Scalingo for MySQL® addons have, depending on the plan, one or two MySQL®
Router instances as entry point. These instances have a few **default**
timeouts configured which may impact your application.

For further details about these timeouts, please check the official
documentation for MySQL® Router, depending on your MySQL® version:

| MySQL® Version | Link                                   |
| -------------- | -------------------------------------- |
| `8.0`          | [Documentation][mysql-router-conf-8.0] |


[mysql-router-conf-8.0]: https://dev.mysql.com/doc/mysql-router/8.0/en/mysql-router-conf-options.html

[mysql-protected-user]: {% post_url databases/mysql/guides/2000-01-01-managing-users %}#understanding-protected-user
