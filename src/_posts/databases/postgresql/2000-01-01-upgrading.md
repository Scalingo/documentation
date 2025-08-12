---
title: Upgrading Your Scalingo for PostgreSQL® Addon
nav: Upgrading
modified_at: 2024-12-10 12:00:00
tags: databases postgresql addon
index: 9
---

In Scalingo's terminology, ***upgrading*** a Scalingo for PostgreSQL® addon
designates the operation consisting in changing the database version for a
newer one.

We disinguish two main cases:
- a ***minor-upgrade*** designates an incremental release with a change in the
  tenths digit of the version number (e.g. `13.3.4` to `13.5.0`). It usually
  provides bugs or security fixes as well as minor additional features.
- a ***major-upgrade*** designates an incremental release with a change in the
  main version number (e.g. `13.x.y` to `14.0.0`). Major-upgrades often provide
  significant changes and new features that **can** break backward
  compatibility.

While we usually advise to stick to the latest minor-upgrade available to
benefit from bug and security fixes, we also **strongly** advise to take
extra-care when major-upgrading your Scalingo for PostgreSQL® addon ([more
about this below](#best-practices-when-managing-major-upgrades)).

When the database vendor releases a new version of your database engine, we
take some time to study it and test it thoroughly before making it available.
Upgrading to this new version is still your choice.

{% warning %}
Beware that no downgrade is possible once your database has been upgraded.
{% endwarning %}


## Understanding the Minor-Upgrade Process

### Prerequisites

There are no prerequisites for minor-upgrades.

### Process

#### For Starter Plans

1. The instance is stopped. The database is unreachable.
2. We restart the instance with the targeted version. This operation can take
   quite some time, depending on the database size and enabled extension(s).
3. Once the instance restarted, the database is reachable again.
4. The application is restarted to ensure proper connections. This shouldn't
   cause any additional downtime.

Since we have to completely stop the instance, **a downtime is inevitable**.

We usually roughly estimate the downtime caused by the operation between a few
seconds to a few minutes. In any cases, it shouldn't exceed 10 minutes.

#### For Business Plans

1. The standby instance is stopped. The primary instance is still running, so
   the database is still reachable.
2. We restart the standby instance with the targeted version.
3. When the standby instance is ready, a failover is done to make it primary.
   The old primary becomes the standby instance. During this operation, the
   connection can be lost during a few milliseconds.
4. The new standby instance is restarted with the targeted version.
5. Once restarted, the cluster is fully upgraded and fully operational again.
6. The application is restarted to ensure proper connections. This shouldn't
   cause any additional downtime.

Minor-upgrades of Business plans are **usually achieved without any impactful
downtime**.


## Understanding the Major-Upgrade Process

### Prerequisites

To get access to the next major version, your database must first be upgraded
to the latest minor version. Each following major version will be suggested
until you reach the latest version available on the platform.

Let’s assume your database is currently on PostgreSQL® 13.5 and you want to
upgrade to PostgreSQL® 15. First, upgrade your database to the latest version
of the 13.x branch. Then, proceed to the latest version of the 14.x branch.
Finally, upgrade to the latest version of the 15.x branch.

### Process

#### For Starter Plans

1. The instance is stopped. The database is unreachable.
2. `pg_upgrade` is executed on the data.
4. The instance is restarted with the targeted version. The database is
   reachable again and the application can use it normally.
5. The `ANALYZE` SQL command is executed against the database to build up
   PostgreSQL® statistics. PostgreSQL® uses these statistics to determine
   the most efficient execution plans for queries.
6. The application is restarted to ensure proper connections. This shouldn't
   cause any additional downtime.
7. A base backup is asynchronously done to make [point-in-time recovery]({% post_url databases/2000-01-01-backup-policies %}#point-in-time-recovery-backups)
   available again.

Since we have to completely stop the instance to upgrade it, **a downtime is
inevitable**.

We usually roughly estimate the overall downtime of the operation by assuming
1 minute of unavailibility per 10GiB of data. This remains a raw estimation and
our experience tends to show that it often takes less time.

#### For Business Plans

1. The entire cluster is stopped. The database is unreachable.
2. `pg_upgrade` is executed on the data.
3. The primary instance is restarted with the targeted version. The database is
   reachable again and the application can use it normally.
4. The `ANALYZE` SQL command is executed against the database to build up
   PostgreSQL® statistics. PostgreSQL® uses these statistics to determine
   the most efficient execution plans for queries.
5. The application is restarted to ensure proper connections. This shouldn't
   cause any additional downtime.
6. A base backup is asynchronously done to make [point-in-time recovery]({% post_url databases/2000-01-01-backup-policies %}#point-in-time-recovery-backups)
   available again.
7. The standby instance is rebuilt from scratch, based on the primary instance
   data. This means the database lives in a degraded state until the end of the
   replication process.

{% warning %}
After a major-upgrade, expect a period of reduced performance during phasis 4,
5 and 6 as the running primary is sollicitated for these internal tasks. The
duration depends of the quantity of data stored in your Scalingo for
PostgreSQL® addon.
{% endwarning %}

Since we have to completely stop the instances to upgrade them, **a downtime is
inevitable**.

We usually roughly estimate the overall downtime of the operation by assuming
1 minute of unavailibility per 10GiB of data. This remains a raw estimation and
our experience tends to show that it often takes less time.

### Best Practices When Managing Major-Upgrades

Since major-upgrades can introduce some breaking changes, we **strongly**
advise to take extra care when dealing with them:

- First, carefully read the changelogs provided by PostgreSQL® (we usually link
  them in our respective changelog entries). Identifying noticeable changes,
  especially ones that may have a negative impact on your database or app, will
  allow you to update your application accordingly.

- We also generally advise to test the changes in a [Review App]({% post_url platform/app/2000-01-01-review-apps %}).

  The use of Review Apps can be deactivated on your production application, [as
  we recommend]({% post_url platform/app/2000-01-01-review-apps %}#configuration-of-review-apps)
  in our documentation. In general, it is recommended that you carry out this
  process on a staging application using the same code repository, but linked
  to a database with no production or customer data. Once you have activated
  the Review Apps feature, you can create a pull request in which you can
  modify the `scalingo.json` manifest file to force the deployment of a
  specific version of PostgreSQL®. The full process is as follow:

  1. Create a new app dedicated to this major-upgrade.
  2. Link this app to your application's code repository.
  3. Make sure to enable Review Apps for this application.
  4. Leverage the [`scalingo.json` manifest file]({% post_url platform/app/2000-01-01-app-manifest %})
     to:
     - Specify the version of the database addon you require. This version
       should match the one you are using in your production environment.
     - Ideally ask the platform to fill your database with **testing data**,
       using a [`first-deploy` script]({% post_url platform/app/2000-01-01-app-manifest %}#deployment-hooks).

     Here is an example of a manifest file asking the platform to provision a
     PostgreSQL `14.6.0` addon and to run the `db-seed.sh` script after the
     first deployment (the script must be included in your codebase):
     ```json
     {
       "addons": [
         {
           "plan": "postgresql:postgresql-starter-512",
           "options": {
             "version": "14.6.0"
           }
         }
       ],

       "env": {
         "CANONICAL_HOST_URL": {
           "generator": "url"
         }
       },

       "scripts": {
         "first-deploy": "bash -c db-seed.sh"
       }
     }
     ```
  5. Create a new Pull Request from the repository hosting your application's
     code. A new Review App is created with the appropriate database version.
     If you have a `first-deploy` script in your `scalingo.json` manifest, it's
     executed.
  6. (optional): If you couldn't use a `first-deploy` script, it's now
     time to fill your database with your test dataset.
  7. Once filled with testing data, upgrade your database until it reaches the
     targeted version.
  8. Execute your tests scenarios on the Review App. This should help you
     validate the changes, or identify the required fixes before sending them
     to production.
  9. Once done, close the Pull Request to automatically destroy the linked
     Review App. You can now plan the production upgrade.

- [Create a manual backup]({% post_url databases/postgresql/2000-01-01-backing-up %}#creating-a-manual-backup)
  of your current production database just before making the move in your
  production environment.


## Upgrading

{% note %}
Upgrading a PostgreSQL® addon to a newer version is only available through the
database dashboard.
{% endnote %}

### Using the Database Dashboard

1. From your web browser, open your [database dashboard]({% post_url databases/postgresql/2000-01-01-getting-started %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Click the **Overview** tab
3. Locate the **Database Upgrade** block
4. If an upgrade is available, the text in the block explains what will be
   done.
5. To launch the upgrade, click the **Upgrade to …** button
