---
title: Prerequisites Before Upgrading to MySQL® 8.4 LTS
nav: Upgrading to MySQL 8.4
modified_at: 2026-01-29 12:00:00
tags: databases mysql addon migration
index: 40
---

Upgrading a Scalingo for MySQL® database from MySQL® 8.0.x LTS to MySQL® 8.4.x LTS may be refused if your schema uses features that are no longer supported in MySQL® 8.4.

This page lists the only upgrade blockers you can address from your side on Scalingo. If you need a broader overview of changes between MySQL 8.0 and 8.4, refer to [Oracle’s upgrade notes](https://docs.oracle.com/en/database/mysql/heatwave-aws/hw-aws-upgrading-mysql-8.0-8.4.html).

## Checking AUTO_INCREMENT on FLOAT or DOUBLE

MySQL® 8.4 no longer supports AUTO_INCREMENT on FLOAT and DOUBLE columns. If your schema contains such a column, Scalingo will refuse the upgrade.

You can list the impacted columns with the following SQL statement:

```sql
SELECT table_schema, table_name, column_name
		 FROM information_schema.columns
		 WHERE extra LIKE '%%auto_increment%%'
		   AND data_type IN ('float', 'double')
```

If the query returns rows, you must remove AUTO_INCREMENT from these columns and use a supported identifier pattern, for example an integer primary key.

## Checking Prefix Columns in Partitioning Keys

MySQL® 8.4 no longer allows prefix columns in partitioning keys. This pattern was deprecated in MySQL® 8.0 and is now rejected.

You first need to list partitioned tables:

```sql
SELECT DISTINCT
    p.TABLE_SCHEMA,
    p.TABLE_NAME,
    s.COLUMN_NAME,
    s.SUB_PART
FROM information_schema.PARTITIONS p
JOIN information_schema.STATISTICS s
    ON s.TABLE_SCHEMA = p.TABLE_SCHEMA
   AND s.TABLE_NAME = p.TABLE_NAME
WHERE
    p.PARTITION_NAME IS NOT NULL
    AND p.PARTITION_METHOD IN ('KEY', 'LINEAR KEY')
    AND s.NON_UNIQUE = 0
    AND s.SUB_PART IS NOT NULL
    AND (
        INSTR(p.PARTITION_EXPRESSION, CONCAT('`', s.COLUMN_NAME, '`')) > 0
        OR p.PARTITION_EXPRESSION IS NULL
    ); 
```

If the query returns rows, your database contains partitioned tables. You must review their partitioning definitions and ensure no partitioning key uses a prefix length before you can upgrade to MySQL® 8.4.

For each table returned by the query above, inspect the partitioning definition:

```sql
SHOW CREATE TABLE `foo`;
```

If you find a partitioning key using a prefix length, you need to update the table definition to remove this pattern.


If you fixed all the issues listed above, or if none were detected, you can now safely [perform the upgrade from the Scalingo dashboard][mysql-upgrade].

[mysql-upgrade]: {% post_url databases/mysql/guides/2000-01-01-upgrading %}#upgrading
