---
title: Working with SQL Modes
nav: Working with SQL Modes
modified_at: 2025-09-24 12:00:00
tags: databases mysql addon modes
index: 20
---


SQL modes allow you to configure MySQL® to behave according to specific
standards, adjusting how it processes queries and verifies data validity. This
includes settings that can make MySQL® more strict or more flexible regarding
SQL syntax and data constraints, providing developers the ability to optimize
database performances based on their application's requirements.

Scalingo doesn't moderate the modes available, which means all modes supported
by your addon are indeed available. The exhaustive list may vary depending on
your MySQL® version. Descriptions of the modes can be found in the official
MySQL® documentation:

- [for MySQL® `8.0`][sql-modes-80]
- [for MySQL® `8.4`][sql-modes-84]

Currently, the default SQL mode includes:
- `ONLY_FULL_GROUP_BY`
- `STRICT_TRANS_TABLES`
- `NO_ZERO_IN_DATE`
- `NO_ZERO_DATE`
- `ERROR_FOR_DIVISION_BY_ZERO`
- `NO_ENGINE_SUBSTITUTION`


## Setting SQL Modes

{% note %}
Setting SQL modes is only available through the database dashboard. MySQL®
users provided by the platform do not have the necessary permissions to perform
these actions via the MySQL® console.
{% endnote %}

### Using the Database Dashboard

1. From your web browser, open your [database dashboard][database-dashboard]
2. Click the **Settings** tab
3. In the **Settings** submenu, select **Configuration**
4. Click the **Manage SQL modes** button
5. Select the mode(s) you are interested in
6. Validate by clicking the **Update configuration** button
7. The changes are done at runtime, which means they immediately apply to new
   queries


[sql-modes-80]: https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html
[sql-modes-84]: https://dev.mysql.com/doc/refman/8.4/en/sql-mode.html

[database-dashboard]: {% post_url databases/mysql/getting-started/2000-01-01-provisioning %}#accessing-the-mysql-dashboard
