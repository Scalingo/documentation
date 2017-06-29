---
title: Scalingo MongoDB Addon
modified_at: 2016-01-11 00:00:00
category: databases
tags: databases mongodb addon
---

<blockquote class="bg-info">
	Some operation requires our command-line tool to be installed.
  <br>
  Instructions are detailed in <a href="{% post_url cli/2015-09-18-command-line-tool %}">Command-Line Tool Documentation</a> and <a href="http://cli.scalingo.com">installer</a> page.
</blockquote>

Scalingo MongoDB addon is the official addon provided by Scalingo, details on the available plans can be found [here](https://scalingo.com/addons/scalingo-mongodb). This addon gives your app instant access to a MongoDB database running in its own Docker container.


## Adding Scalingo MongoDB addon to your app

You can add the MongoDB addon through the **Dashboard** or through the **command-line interface**. The capacity of your database is elastic, you will be able to upgrade it later.

### Through the Dashboard

1. Go to your app on [Scalingo Dashboard](https://my.scalingo.com/apps)
2. Click on **Addons** tab
3. Select the addon you want to add
4. In the dialog select the database plan you need
5. Validate your choice

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_dashboard_addons_mongo.png" %}
{% include mdl_img.html %}

### Through the command-line interface

```bash
$ scalingo -a example-app addons-add scalingo-mongodb 1g

-----> Addon scalingo-mongodb has been provisionned
       ID: example-app-3030
       Modified variables: [MONGO_URL SCALINGO_MONGO_URL]
       Message from addon provider: Database successfully created
```

This command will provision the application `example-app` with a `1g` MongoDB database plan.

To find out what other plans are available:

```bash
$ scalingo addons-plans scalingo-mongodb
```


## Getting your connection URI

Once the addon is provisioned, 2 environment variables are added to your app: `SCALINGO_MONGO_URL` and `MONGO_URL`. `MONGO_URL` is an alias to `SCALINGO_MONGO_URL` for the convenience of some libraries such as the framework [Meteor]({% post_url languages/javascript/meteor/2015-02-09-getting-started-with-meteor %}) or the Ruby gem **mongoid**, but using `SCALINGO_MONGO_URL` is prefered in most cases. To find out how to use them in your code please refer to [Application environment]({% post_url app/2014-09-15-environment %}).

In most cases, you can pass the variable directly to the client library you are using in your code. But sometimes the library requires a specific URI format, you'll need to add a little bit of code to suit the library.

You can get those variables from the Dashboard or the command-line interface.

### From the Dashboard

1. Go to your app on [Scalingo Dashboard](https://my.scalingo.com/apps)
2. Click on **Environment** tab
3. `MONGO_URL` and `SCALINGO_MONGO_URL` are displayed

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_dashboard_environment_mongo.png" %}
{% include mdl_img.html %}

### From the command-line interface

```bash
$ scalingo -a example-app env | grep MONGO

MONGO_URL=$SCALINGO_MONGO_URL
SCALINGO_MONGO_URL=mongodb://example-app-3030:2rj5FYoiKRFp8eZhpMz7@example-app-3030.mongo.dbs.appsdeck.eu:30949/example-app-3030
```


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

+------------------+------------------+------+
|       ADDON      |        ID        | PLAN |
+------------------+------------------+------+
| Scalingo MongoDB | example-app-3030 |   1g |
+------------------+------------------+------+
```

## Database dashboard

The Scalingo MongoDB dashboard is the central place for administrative tasks such as:

- Monitor database and system stats
- Upgrade the database engine version
- Activate database specific features (e.g. Oplog for MongoDB)
- Manage database users
- Manage backups

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_database_mongo_overview.png" %}
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
      <td class="mdl-data-table__cell--non-numeric">MongoDB index size</td>
      <td class="mdl-data-table__cell--non-numeric">Index size reported by MongoDB, for the best performance this value should fit in the memory size.</td>
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
3. Click **Link to dashboard** which will take you to the **Scalingo MongoDB dashboard**
4. Click on **Backups** tab
5. Download the backup you want

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_database_mongo_backups.png" %}
{% include mdl_img.html %}

### Manual database backup

If you wish to manually backup your database, please follow [How to dump and restore my MongoDB database on Scalingo]({% post_url databases/2015-09-30-dump-restore-mongodb %}) guide.


## MongoDB Oplog

Oplog is a MongoDB feature which logs all the operations achieved on a MongoDB cluster. This feature is tightly related to MongoDB replication, but is also used by Meteor to increase app performance. If you wish to use Oplog in your application please refer to the official [MongoDB documentation](https://docs.mongodb.org/manual/core/replica-set-oplog/). Oplog can be enabled from the database dashboard, when activated it wil automatically add the `MONGO_OPLOG_URL` variable in your application.

### Activating Oplog

1. Go to your app on [Scalingo Dashboard](https://my.scalingo.com/apps)
2. Click on **Addons** tab
3. Click **Link to dashboard** which will take you to the **Scalingo MongoDB dashboard**
4. Click on **Advanced** tab

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_database_mongo_advanced.png" %}
{% include mdl_img.html %}

### Meteor specific

Meteor uses this feature to sync different instances of an application. Your can read more about how to scale Meteor <a href="http://doc.scalingo.com/languages/javascript/nodejs/meteor/#how-to-scale-meteor">here</a>.

The variable `MONGO_OPLOG_URL` is the one used by Meteor. As a result, after activating Oplog you juste have to restart your application.
