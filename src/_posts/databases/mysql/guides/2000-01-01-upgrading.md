---
title: Upgrading Your Scalingo for MySQL® Addon
nav: Upgrading
modified_at: 2025-09-24 12:00:00
tags: databases mysql addon
index: 4
---

In Scalingo's terminology, ***upgrading*** a Scalingo for MySQL® addon
designates the operation consisting in changing the database version for a
newer one.

*Currently**, Scalingo supports the `8.0` and `8.4` LTS branches of MySQL® Community
Edition.

As explained in [the official documentation][mysql-lts], and starting with
MySQL® `8.0.34`, the patch-upgrades only contain bug and security fixes.
Consequently, it should be rather safe to upgrade to a new minor version.

{% note %}
Running MySQL® 8.0.x LTS and upgrading to 8.4.x LTS? [Review our upgrade guide first][mysql84-prerequisites].
{% endnote %}

While we usually advise to stick to the latest patch-upgrade available to
benefit from bug and security fixes, we also strongly advise to take extra-care
when upgrading your Scalingo for MySQL® addon ([more about this
below](#best-practices-before-upgrading)).

{% warning %}
Beware that no downgrade is possible once your database has been upgraded.
{% endwarning %}


## Understanding the Patch-Upgrade Process

### Prerequisites

There are no prerequisites for patch-upgrades.

### Process

#### For Starter Plans

1. The instance is stopped. The database is unreachable.
2. The instance is restarted with the targeted version. This operation can take
   quite some time depending on the database size.
3. Once the instance is restarted, the database is reachable again.
4. The application to which the database is attached is restarted to ensure
   proper connections. [This does not cause any additional
   downtime][zero-downtime].

Since we have to completely stop the instance, **a downtime is inevitable**.

#### For Business Plans

1. The Scalingo for MySQL® Routers of the cluster are restarted one by one with
   the targeted version. This shouldn't cause any downtime.
2. The different instances forming the cluster are restarted one by one. This
   shouldn't cause any downtime, thanks to the MySQL® Routers routing the
   connexions to the available instances.
3. Once all the nodes are restarted, the cluster is fully upgraded and fully
   operational again.
4. The application to which the database is attached is restarted to ensure
   proper connections. [This does not cause any additional
   downtime][zero-downtime]

Patch-upgrades of Business plans are **usually achieved without any impactful
downtime**.

### Best Practices Before Upgrading

- First, carefully read the changelogs provided by MySQL® (we usually link them
  in our respective changelog entries). Identifying noticeable changes,
  especially ones that may have a negative impact on your database or app, will
  allow you to update your application accordingly.

- We also generally advise to test the changes in a [Review App][review_apps].

  The use of Review Apps can be deactivated on your production application, [as
  we recommend][review_apps-config] in our documentation. In general, it is
  recommended that you carry out this process on a staging application using
  the same code repository, but linked to a database with no production or
  customer data. Once you have activated the Review Apps feature, you can
  create a pull request in which you can modify the `scalingo.json` manifest
  file to force the deployment of a specific version of MySQL®. The full
  process is as follow:

  1. Create a new app dedicated to this upgrade.
  2. Link this app to your application's code repository.
  3. Make sure to enable Review Apps for this application.
  4. Leverage the [`scalingo.json` manifest file][app-manifest] to:
     - Specify the version of the database addon you require. This version
       should match the one you are using in your production environment.
     - Ideally ask the platform to fill your database with **testing data**,
       using a [`first-deploy` script][deployment-hooks].

     Here is an example of a manifest file asking the platform to provision a
     MySQL® `8.4.8` addon and to run the `db-seed.sh` script after the
     first deployment (the script must be included in your codebase):
     ```json
     {
       "addons": [
         {
           "plan": "mysql:mysql-starter-512",
           "options": {
             "version": "8.4.8"
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

- [Create a manual backup][backing-up-creating-manual] of your current
  production database just before making the move in your production
  environment.

- [Put the app in maintenance mode][maintenance-mode] during the upgrade
  operations, especially if a significant downtime is expected.


## Upgrading

{% note %}
Upgrading a Scalingo for MySQL® addon to a newer version is only available
through the database dashboard.
{% endnote %}

### Using the Database Dashboard

1. From your web browser, open your [database dashboard][database-dashboard]
2. Select the **Settings** tab
3. In the **Settings** submenu, select the **General** tab
4. Locate the **Database Version** block
5. If an upgrade is available, a button allows you to trigger the upgrade
6. Click the button to launch the upgrade process


[mysql-lts]: https://dev.mysql.com/blog-archive/introducing-mysql-innovation-and-long-term-support-lts-versions/

[zero-downtime]: {% post_url platform/internals/2000-01-01-container-management %}#zero-downtime-operations

[review_apps]: {% post_url platform/app/2000-01-01-review-apps %}
[review_apps-config]: {% post_url platform/app/2000-01-01-review-apps %}#configuration-of-review-apps
[app-manifest]: {% post_url platform/app/2000-01-01-app-manifest %}
[deployment-hooks]: {% post_url platform/app/2000-01-01-app-manifest %}#deployment-hooks
[maintenance-mode]: {% post_url platform/app/2000-01-01-custom-error-page %}#custom-maintenance-page
[mysql84-prerequisites]: {% post_url databases/mysql/guides/2000-01-01-mysql-84-prerequisites %}

[database-dashboard]: {% post_url databases/mysql/getting-started/2000-01-01-provisioning %}#accessing-the-mysql-dashboard
[backing-up-creating-manual]: {% post_url databases/mysql/guides/2000-01-01-backing-up %}#creating-a-manual-backup
