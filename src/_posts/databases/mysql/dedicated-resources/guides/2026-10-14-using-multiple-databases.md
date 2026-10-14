---
title: Using Multiple Databases on Scalingo for MySQL® Dedicated Resources
nav: Using Multiple Databases
modified_at: 2026-10-14 00:00:00
tags: databases mysql dedicated
index: 8
---


Each Scalingo for MySQL® Dedicated Resources database comes with a default
database. You can, however,
create multiple databases on the same Scalingo for MySQL® instance. In this
case:
- The memory and disk storage allocated in the plan are shared between all
  databases
- By default, the database users (the default one and the ones you could have
  created) are shared between databases, even for existing ones
- All databases are covered by the same [continuous backups][backing-up]
- The platform doesn't provide any environment variable for these additional
  databases. You should, however, be able to generate one from the original
  `SCALINGO_MYSQL_URL`.


## Listing Existing Databases

### Using the Database Dashboard

1. From your web browser, [open your database dashboard][database-dashboard]
2. Click the **Settings** tab
3. In the **Settings** submenu, select **Databases**

### Using the Command Line Tool

1. Access your database using the [MySQL client][mysql-client]
2. From the MySQL® console, run the following command:
   ```sql
   SHOW DATABASES;
   ```
   The output should look like this:
   ```
   mysql> SHOW DATABASES;
   +--------------------+
   | Database           |
   +--------------------+
   | my_app_5432        |
   | my_database01      |
   | my_database02      |
   | information_schema |
   | performance_schema |
   +--------------------+
   5 rows in set (0.01 sec)
   ```


## Creating a New Database

{% note %}
Creating a new database is only available from the Database Dashboard.
{% endnote %}

### Using the Database Dashboard

1. From your web browser, [open your database dashboard][database-dashboard]
2. Click the **Settings** tab
3. In the **Settings** submenu, select **Databases**
4. Fill the **Add a database** form by specifying a **name** for the new
   database
5. Validate the form by clicking the **Create this database** button


## Deleting a Database

{% note %}
- The default database can not be deleted. It can only be emptied.
- Deleting a database is only available from the Database Dashboard.
{% endnote %}

{% warning %}
Consider [creating a dump][backing-up-create] prior to deleting a database.
{% endwarning%}

### Using the Database Dashboard

1. From your web browser, [open your database dashboard][database-dashboard]
2. Click the **Settings** tab
3. In the **Settings** submenu, select **Databases**
4. Locate the database you want to remove
5. Click the **"&#8230;"** button next to the database
6. From the popup menu, select **Drop**
7. In the popup window, confirm the deletion by typing the name of the database
8. Validate by clicking the **Confirm** button


[mysql-client]: {% post_url databases/mysql/dedicated-resources/getting-started/2026-10-14-accessing %}#using-the-mysql-client
[database-dashboard]: {% post_url databases/mysql/dedicated-resources/getting-started/2026-10-14-provisioning %}#accessing-the-scalingo-for-mysql-dashboard

[backing-up]: {% post_url databases/mysql/dedicated-resources/guides/2026-10-14-backing-up %}
[backing-up-create]: {% post_url databases/mysql/dedicated-resources/guides/2026-10-14-backing-up %}#dumping-the-database
