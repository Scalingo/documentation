---
title: Upgrading Your Scalingo for MySQL® Dedicated Resources Database
nav: Upgrading
modified_at: 2026-10-14 00:00:00
tags: databases mysql dedicated
index: 5
---

In Scalingo's terminology, ***upgrading*** a Scalingo for MySQL® Dedicated
Resources database
designates the operation consisting in changing the database version for a
newer one.

Scalingo for MySQL® Dedicated Resources runs MySQL® 8.4 LTS Community Edition.

As explained in [the official documentation][mysql-lts], and starting with
MySQL® `8.0.34`, the patch-upgrades only contain bug and security fixes.
Consequently, it should be rather safe to upgrade to a new minor version.

While we usually advise to stick to the latest patch-upgrade available to
benefit from bug and security fixes, we also strongly advise to take extra-care
when upgrading your Scalingo for MySQL® Dedicated Resources database ([more about this
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

Since we have to completely stop the instance, **a downtime is inevitable**.

#### For Business and Enterprise Plans

1. The Scalingo for MySQL® Routers of the cluster are restarted one by one with
   the targeted version. This shouldn't cause any downtime.
2. The different instances forming the cluster are restarted one by one. This
   shouldn't cause any downtime, thanks to the MySQL® Routers routing the
   connections to the available instances.
3. Once all the nodes are restarted, the cluster is fully upgraded and fully
   operational again.

Patch-upgrades of Business and Enterprise plans are **usually achieved without any impactful
downtime**.

### Best Practices Before Upgrading

- First, carefully read the changelogs provided by MySQL® (we usually link them
  in our respective changelog entries). Identifying noticeable changes,
  especially ones that may have a negative impact on your database or app, will
  allow you to update your application accordingly.

- Test the upgrade on a separate Dedicated Resources database using testing
  data and the same application code before upgrading production.

- [Create a dump][backing-up-dumping] of your current
  production database just before making the move in your production
  environment.

- [Put the app in maintenance mode][maintenance-mode] during the upgrade
  operations, especially if a significant downtime is expected.


## Upgrading

{% note %}
Upgrading a Scalingo for MySQL® Dedicated Resources database to a newer version
is only available
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
[maintenance-mode]: {% post_url platform/app/2000-01-01-custom-error-page %}#custom-maintenance-page
[database-dashboard]: {% post_url databases/mysql/dedicated-resources/getting-started/2026-10-14-provisioning %}#accessing-the-scalingo-for-mysql-dashboard
[backing-up-dumping]: {% post_url databases/mysql/dedicated-resources/guides/2026-10-14-backing-up %}#dumping-the-database
