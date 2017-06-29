---
title: Scalingo MySQL Addon
modified_at: 2016-01-11 00:00:00
category: databases
tags: databases mysql addon
---

<blockquote class="bg-info">
	Some operation requires our command-line tool to be installed.
  <br>
  Instructions are detailed in <a href="{% post_url cli/2015-09-18-command-line-tool %}">Command-Line Tool Documentation</a> and <a href="http://cli.scalingo.com">installer</a> page.
</blockquote>

Scalingo MySQL addon is the official addon provided by Scalingo, details on the available plans can be found [here](https://scalingo.com/addons/scalingo-mysql). This addon gives your app instant access to a MySQL database running in its own Docker container.


## Adding Scalingo MySQL addon to your app

You can add the MySQL addon through the **Dashboard** or through the **command-line interface**. The capacity of your database is elastic, you will be able to upgrade it later.

### Through the Dashboard

1. Go to your app on [Scalingo Dashboard](https://my.scalingo.com/apps)
2. Click on **Addons** tab
3. Select the addon you want to add
4. In the dialog select the database plan you need
5. Validate your choice

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_dashboard_addons_mysql.png" %}
{% include mdl_img.html %}

### Through the command-line interface

```bash
$ scalingo -a example-app addons-add scalingo-mysql 1g

-----> Addon scalingo-mysql has been provisionned
       ID: example-app-3030
       Modified variables: [DATABASE_URL SCALINGO_MYSQL_URL]
       Message from addon provider: Database successfully created
```

This command will provision the application `example-app` with a `1g` MySQL database plan.

To find out what other plans are available:

```bash
$ scalingo addons-plans scalingo-mysql
```


## Getting your connection URI

Once the addon is provisioned, 2 environment variables are added to your app: `SCALINGO_MYSQL_URL` and `DATABASE_URL`. To find out how to use it in your code please refer to [Application environment]({% post_url app/2014-09-15-environment %}).

In most cases, you can pass the variable directly to the client library you are using in your code. But sometimes the library requires a specific URI format, you'll need to add a little bit of code to suit the library.

You can get environment variables from the Dashboard or the command-line interface.

### From the Dashboard

1. Go to your app on [Scalingo Dashboard](https://my.scalingo.com/apps)
2. Click on **Environment** tab
3. `SCALINGO_MYSQL_URL` is displayed

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_dashboard_environment_mysql.png" %}
{% include mdl_img.html %}

### From the command-line interface

```bash
$ scalingo -a example-app env | grep MYSQL

DATABASE_URL=$SCALINGO_MYSQL_URL
SCALINGO_MYSQL_URL=mysql://example_app_3030:CaUrq1MdUkAzCSEq-1Fg@example-app-3030.mysql.dbs.appsdeck.eu:30999/example_app_3030
```

### Ruby rails specific

`DATABASE_URL` is an alias to `SCALINGO_MYSQL_URL`, the Ruby buildpack will read the value of `DATABASE_URL` and create the `database.yml` configuration file accordingly.

If you’re using the <em>mysql2</em> gem, you will need to copy the value of `SCALINGO_MYSQL_URL` into `DATABASE_URL` and change the scheme part from `mysql://` to `mysql2://`.


## Remote access your database

If you need to access your database from other places than your app please follow the [Access your database]({% post_url databases/2015-06-24-access-database %}) guide.


## Changing plans

You can upgrade or downgrade your database plan whenever you need it. This operation happens instantly thanks to Docker containers and no manual input is required. When you change the plan, your database will be stopped then simply restarted on a new host with new parameters of the chosen plan. During the operation the connection is dropped bewteen your app and the database. Finally, after the operation is successful, the related app will be restarted. 

### From the Dashboard

1. Go to your app on [Scalingo Dashboard](https://my.scalingo.com/apps)
2. Click on **Addons** tab
3. Select the addon you want to change
4. In the dialog select the plan you want to upgrade/downgrade to
5. Validate your choice

### From the command-line interface

To upgrade or downgrade your addon the sub-command is the same: `addons-upgrade`.

```bash
$ scalingo -a example-app addons-upgrade example-app-3030 2g
```

In this example, `example-app-3030` is the ID of the addon, and `2g` is the plan we want to upgrade to.

To find out the addon ID:

```bash
$ scalingo -a example-app addons 

+----------------+------------------+------+
|      ADDON     |        ID        | PLAN |
+----------------+------------------+------+
| Scalingo MySQL | example-app-3030 |   1g |
+----------------+------------------+------+
```

## Database dashboard

The Scalingo MySQL dashboard is the central place for administrative tasks such as:

- Monitor database and system stats
- Upgrade the database engine version
- Activate database specific features
- Manage database users
- Manage backups

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_database_mysql_overview.png" %}
{% include mdl_img.html %}

### Database Upgrade

When the database vendor releases a new version of your database engine, we will try to provide it as soon as possible. You will have the choice to upgrade your database with just one click through your database dashboard.

This operation is similar to changing your database plan; your database will be stopped and restarted with new database environment. Thanks to Docker containers this happens seamlessly and quickly without manual action. When this operation finishes, your application will be restarted.

{% assign data = "Beware that no downgrade is possible once your database has been upgraded." %}
{% include danger %}


### Container Stats

<table class="mdl-data-table ">
  <tbody>
    <tr>
      <td class="mdl-data-table__cell--non-numeric">CPU usage</td>
      <td class="mdl-data-table__cell--non-numeric">Current CPU usage.</td>
    </tr>
    <tr>
      <td class="mdl-data-table__cell--non-numeric">Memory usage</td>
      <td class="mdl-data-table__cell--non-numeric">Display the current, hightest and free memory. Highest is the maximum memory recorded since database restarted.</td>
    </tr>
    <tr>
      <td class="mdl-data-table__cell--non-numeric">Swap usage</td>
      <td class="mdl-data-table__cell--non-numeric">Display the current, hightest and free swap. Highest is the maximum swap recorded since database restarted.</td>
    </tr>
  </tbody>
</table>

### Database Stats

<table class="mdl-data-table ">
  <tbody>
    <tr>
      <td class="mdl-data-table__cell--non-numeric">Database connections</td>
      <td class="mdl-data-table__cell--non-numeric">Number of currently open and maximum connections.</td>
    </tr>
    <tr>
      <td class="mdl-data-table__cell--non-numeric">Data size</td>
      <td class="mdl-data-table__cell--non-numeric">Logical space reported by the database.</td>
    </tr>
    <tr>
      <td class="mdl-data-table__cell--non-numeric">Database on disk size</td>
      <td class="mdl-data-table__cell--non-numeric">Effective physical space used.</td>
    </tr>
  </tbody>
</table>


## Backups

{% include database_backups.md %}

### Download automated backups

Automated backups are listed in the database specific dashboard. 

1. Go to your app on [Scalingo Dashboard](https://my.scalingo.com/apps)
2. Click on **Addons** tab
3. Click **Link to dashboard** which will take you to the **Scalingo MySQL dashboard**
4. Click on **Backups** tab
5. Download the backup you want

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_database_mysql_backups.png" %}
{% include mdl_img.html %}

### Manual database backup

If you wish to manually backup your database, please follow [How to dump and restore my MySQL database on Scalingo]({% post_url databases/2015-10-01-dump-restore-mysql %}) guide.
