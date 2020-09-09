---
title: Prerequisites Before Upgrading to MySQL 8
nav: Upgrading to MySQL 8
modified_at: 2020-09-04 00:00:00
tags: databases mysql addon
index: 4
---

Starting with MySQL 8, Scalingo enables group replication on all MySQL
databases. This MySQL feature has a couple of strong prerequisites ([MySQL
documentation](https://dev.mysql.com/doc/refman/8.0/en/group-replication-requirements.html)).
Please make sure your database is compatible before proceeding with the upgrade:

## Storage Engine

All tables **must** use the InnoDB storage engine. You can check which tables
use a different storage engine with the SQL command:

```sql
SELECT table_schema, table_name FROM information_schema.tables \
  WHERE table_schema IN ('my-app-3030') AND engine != 'InnoDB';
```

Here is the output of this command if the `foo` table use another storage engine than InnoDB:

```text
+--------------+------------+
| table_schema | table_name |
+--------------+------------+
| my-app-3030  | foo        |
+--------------+------------+
1 row in set (0.00 sec)
```

In this situation, you need to update `foo`'s storage engine with the following command:

```sql
ALTER TABLE 'foo' ENGINE = 'InnoDB';
```

## Mandatory Primary Keys

All tables **must** have a primary key configured. You can check which tables
use a different storage engine with the SQL command:

```sql
SELECT information_schema.tables.table_schema, information_schema.tables.table_name \
  FROM information_schema.tables LEFT JOIN information_schema.key_column_usage AS c ON (\
    information_schema.tables.table_name = c.table_name AND \
    c.constraint_schema = information_schema.tables.table_schema AND \
    c.constraint_name = 'PRIMARY' \
  ) \
  WHERE information_schema.tables.table_schema IN ('my-app-3030') AND \
  c.constraint_name IS NULL;
```

Here is the output of this command if the `foo` table does not have a primary key:

```text
+--------------+------------+
| table_schema | table_name |
+--------------+------------+
| my-app-3030  | foo        |
+--------------+------------+
1 row in set (0.00 sec)
```

In this situation, you need to add a primary key to the `foo` table. You need to evaluate the impact of this modification before proceeding. Here is the command to add a new column and set it as primary:

```sql
ALTER TABLE 'foo' ADD COLUMN <column description> PRIMARY KEY;
```
