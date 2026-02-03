---
title: Database Dashboard
nav: Database Dashboard
modified_at: 2025-04-28 12:00:00
tags: databases dashboard
index: 10
---


Every database engine provided by Scalingo comes with a dedicated web dashboard,
generally referred to as **database dashboard**.

This database dashboard is the central place for most common administrative
tasks, such as:

- Monitoring the database through logs, metrics and statistics
- Upgrading the database engine version
- Changing the database plan
- Managing database users
- Managing backups
- Configuring the [Database Maintenance Window][maintenance-windows]
- Enabling specific features (enforcing TLS connection, making the database
  reachable over the Internet, etc.)

For further help regarding these topics (and more), please refer to the
dedicated **guides** available for each database.


## Accessing the Database Dashboard

You can access the database dashboard via the application dashboard:

1. From your web browser, open your [dashboard][dashboard]
2. Click on the application for which you want to manage your database
3. Click on the **Overview** tab
4. Locate the **Addons** block and click on the **Dashboard** button next to
   the database you want to manage.


[dashboard]: https://dashboard.scalingo.com/apps
[maintenance-windows]: {% post_url databases/about/2000-01-01-maintenance-windows %}
