---
title: Prerequisites Before Upgrading to MySQL® 8.0 LTS
nav: Upgrading to MySQL 8.0
modified_at: 2026-01-29 12:00:00
tags: databases mysql addon migration
index: 40
---

Starting with MySQL® 8, Scalingo enables group replication on all MySQL®
databases. This MySQL® feature has a couple of [strong prerequisites][prereq].
Please make sure your database is compatible before proceeding with the
upgrade:

## Checking the Storage Engine

All tables **must** use the InnoDB storage engine. You can check which tables
use a different storage engine with the following SQL statement:

```sql
SELECT table_schema, table_name FROM information_schema.tables \
  WHERE table_schema IN ('my-app-3030') AND engine != 'InnoDB';
```

Here is the output if the `foo` table uses a storage engine other than InnoDB:

```text
+--------------+------------+
| table_schema | table_name |
+--------------+------------+
| my-app-3030  | foo        |
+--------------+------------+
1 row in set (0.00 sec)
```

In such a case, you need to update `foo`'s storage engine with the following
SQL statement:

```sql
ALTER TABLE 'foo' ENGINE = 'InnoDB';
```

## Checking Mandatory Primary Keys

All tables **must** have a primary key configured. You can check which tables
do not have any primary key with the following SQL statement:

```sql
SELECT information_schema.tables.table_schema, information_schema.tables.table_name \
  FROM information_schema.tables LEFT JOIN information_schema.key_column_usage AS c ON (\
    information_schema.tables.table_name = c.table_name AND \
    c.constraint_schema = information_schema.tables.table_schema AND \
    c.constraint_name = 'PRIMARY' \
  ) \
  WHERE information_schema.tables.table_schema IN ('my-app-3030') AND \
  information_schema.tables.table_type != "VIEW" AND \
  c.constraint_name IS NULL;
```

Here is the output if the `foo` table does not have a primary key:

```text
+--------------+------------+
| table_schema | table_name |
+--------------+------------+
| my-app-3030  | foo        |
+--------------+------------+
1 row in set (0.00 sec)
```

In such a case, you need to add a primary key to the `foo` table. You need to
evaluate the impact of this modification before proceeding. Here is an example
SQL statement to add a new column and set it as primary:

```sql
ALTER TABLE 'foo' ADD COLUMN <column description> PRIMARY KEY;
```

## One Command Script

Below is a script that can be run directly on the database to:
- create missing primary keys for the concerned tables
- set the engine to InnoDB for the concerned tables

The script creates two procedures, one for each previous actions.

{% warning %}
As always, we highly recommend to make a backup before executing the script.
{% endwarning %}

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS `create_missing_pk`$$

CREATE PROCEDURE `create_missing_pk`()
BEGIN

DECLARE v_finished INTEGER DEFAULT 0;
DECLARE v_table VARCHAR(100) DEFAULT "";
DECLARE stmt VARCHAR(500) DEFAULT "";

-- get the list of tables without PK
DECLARE table_cursor CURSOR FOR
SELECT i.table_name \
  FROM information_schema.tables AS i LEFT JOIN information_schema.key_column_usage AS c ON (\
    i.table_name = c.table_name AND \
    c.constraint_schema = i.table_schema AND \
    c.constraint_name = 'PRIMARY' \
  ) \
  WHERE i.table_schema \
    NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql', 'mysql_innodb_cluster_metadata') AND \
    i.table_type != "VIEW" AND \
    c.constraint_name IS NULL;

DECLARE CONTINUE HANDLER
FOR NOT FOUND SET v_finished = 1;

OPEN table_cursor;

-- loop over all tables without PK
alter_tables: LOOP

    FETCH table_cursor INTO v_table;
    IF v_finished = 1 THEN
    LEAVE alter_tables;
    END IF;

    -- below the alter table which create PKs
    SET @prepstmt = CONCAT('ALTER TABLE ',v_table,' ADD COLUMN generated_pk INT AUTO_INCREMENT NOT NULL PRIMARY KEY FIRST;');

    PREPARE stmt FROM @prepstmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END LOOP alter_tables;

CLOSE table_cursor;

END$$

-- Procedure to set engine to InnoDB
DROP PROCEDURE IF EXISTS `set_innodb_engine`$$

CREATE PROCEDURE `set_innodb_engine`()
BEGIN

DECLARE v_finished INTEGER DEFAULT 0;
DECLARE v_table VARCHAR(100) DEFAULT "";
DECLARE stmt VARCHAR(500) DEFAULT "";

-- get the list of tables without InnoDB engine
DECLARE table_cursor CURSOR FOR
SELECT table_name \
  FROM information_schema.tables \
  WHERE table_schema \
    NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql', 'mysql_innodb_cluster_metadata') AND \
    table_type != "VIEW" AND \
    ENGINE != 'InnoDB';

DECLARE CONTINUE HANDLER
FOR NOT FOUND SET v_finished = 1;

OPEN table_cursor;

-- loop over all tables without InnoDB engine
alter_tables: LOOP

    FETCH table_cursor INTO v_table;
    IF v_finished = 1 THEN
    LEAVE alter_tables;
    END IF;

    -- below the alter table which set the engine to InnoDB
    SET @prepstmt = CONCAT('ALTER TABLE ',v_table,' ENGINE = "InnoDB";');

    PREPARE stmt FROM @prepstmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END LOOP alter_tables;

CLOSE table_cursor;

END$$
DELIMITER ;

-- then call the procedures
call create_missing_pk;
call set_innodb_engine;

-- clear procedures
DROP PROCEDURE IF EXISTS `create_missing_pk`;
DROP PROCEDURE IF EXISTS `set_innodb_engine`;

-- check the current configuration of table
SELECT i.table_schema, i.table_name, i.engine, c.constraint_name  \
  FROM information_schema.tables AS i LEFT JOIN information_schema.key_column_usage AS c ON (\
    i.table_name = c.table_name AND \
    c.constraint_schema = i.table_schema AND \
    c.constraint_name = 'PRIMARY' \
  ) \
  WHERE i.table_schema not in ('information_schema', 'performance_schema', 'sys', 'mysql', 'mysql_innodb_cluster_metadata');
```


[prereq]: https://dev.mysql.com/doc/refman/8.0/en/group-replication-requirements.html
