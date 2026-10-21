---
title: Upgrading Your Scalingo for MySQL® Dedicated Resources Database
nav: Upgrading
modified_at: 2026-10-21 00:00:00
tags: databases mysql dedicated
index: 5
---

Upgrading a Scalingo for MySQL® Dedicated Resources database changes its version
to a newer one.

We distinguish two cases:

- A ***minor-upgrade*** updates the database within the same LTS branch, for
  example from `8.4.1` to `8.4.2`. It provides bug and security fixes.
- A ***major-upgrade*** moves the database to a newer LTS branch, for example from `8.0`
  to `8.4`. It can
  introduce new features and changes that break backward compatibility.

We recommend promptly upgrading to the latest available minor version to receive
bug and security fixes. Major-upgrades require checking application and schema
compatibility with the target version. Before either type of upgrade, review the
[best practices below](#best-practices-when-managing-major-upgrades).

When MySQL® releases a new version, Scalingo tests it before making it available
on the platform. You choose when to launch an available upgrade from the
database dashboard.

{% warning %}
You cannot downgrade your database after an upgrade.
{% endwarning %}


## Understanding the Minor-Upgrade Process

### Prerequisites

There are no prerequisites for minor-upgrades.

### Process

Single-node databases stop during the upgrade. Multi-node clusters upgrade
instances one by one and switch the primary to an upgraded instance.

#### For Single-node Databases (`Starter`)

1. The instance is stopped. The database is unreachable.
2. Scalingo restarts the instance with the target version. The restart duration
   depends on the database size.
3. Once the instance has restarted, the database is reachable again.

**The database is unavailable from the moment the instance stops until it has
restarted.**

#### For Multi-node Clusters (`Business` and `Enterprise`)

1. The MySQL® Routers are restarted one by one with the targeted version.
2. Scalingo restarts secondary instances with the target version while the
   primary continues to serve queries.
3. A failover makes an upgraded secondary instance the primary.
4. The former primary is restarted with the target version.
5. Once all instances and routers have restarted, the cluster is fully upgraded.

Existing connections are reset when routers restart and when the primary
instance changes. Your application must reconnect to continue querying the
database.


Minor-upgrades of multi-node clusters are **usually achieved without any impactful
downtime**.

## Understanding the Major-Upgrade Process

### Prerequisites

Read the MySQL® upgrade notes for the target LTS branch. Check for removed
features, configuration changes, and schema compatibility requirements. Resolve
any compatibility issues before launching the upgrade.

For example, before upgrading from MySQL® `8.0` to `8.4`, review the
[upgrade prerequisites][mysql84-prerequisites]. Test the upgrade with your
application before upgrading production.

### Process

Single-node databases stop during the upgrade. Multi-node clusters upgrade
instances one by one and switch the primary to an upgraded instance.

#### For Single-node Databases (`Starter`)

1. The instance is stopped. The database is unreachable.
2. Scalingo restarts the instance with the target version. The restart duration
   depends on the database size.
3. Once the instance has restarted, the database is reachable again.

**The database is unavailable from the moment the instance stops until it has
restarted.**

We usually roughly estimate the downtime caused by the operation between a few
seconds to a few minutes. In any cases, it shouldn't exceed 10 minutes.

#### For Multi-node Clusters (`Business` and `Enterprise`)

1. The MySQL® Routers are restarted one by one with the targeted version.
2. Scalingo restarts secondary instances with the target version while the
   primary continues to serve queries.
3. A failover makes an upgraded secondary instance the primary.
4. The former primary is restarted with the target version.
5. Once all instances and routers have restarted, the cluster is fully upgraded.

Existing connections are reset when routers restart and when the primary
instance changes. Your application must reconnect to continue querying the
database.

### Best Practices When Managing Major-Upgrades

Major-upgrades can break backward compatibility. Before upgrading production:

- Read the MySQL® changelogs linked from our release announcements. Check for
  changes that affect your database or application and update your application
  before upgrading.

- Test the upgrade before applying it to production:
  1. Provision a separate MySQL® Dedicated Resources database with the same
     version as production.
  2. Connect a staging application running the same code to this database.
  3. Load test data without production or customer data.
  4. Upgrade the test database to the target version.
  5. Run your application tests and check that it reconnects after connections
     are reset.
  6. Fix any issues before scheduling the production upgrade.

- [Create a dump][backing-up-dumping] of your production database just before
  upgrading it.

- [Put the app in maintenance mode][maintenance-mode] during the upgrade if
  downtime is expected.


## Upgrading

{% note %}
Upgrading a Scalingo for MySQL® Dedicated Resources database is only available
through the database dashboard.
{% endnote %}

### Using the Database Dashboard

1. From your web browser, open your [database dashboard][database-dashboard]
2. Click the **Settings** tab
3. Locate the **Database version** block
4. If an upgrade is available, the text in the block explains what will be
   done.
5. To launch the upgrade, click the **Upgrade to …** button


[maintenance-mode]: {% post_url platform/app/2000-01-01-custom-error-page %}#custom-maintenance-page
[database-dashboard]: {% post_url databases/mysql/dedicated-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-mysql-dashboard
[backing-up-dumping]: {% post_url databases/mysql/dedicated-resources/guides/2000-01-01-backing-up %}#dumping-the-database

[mysql84-prerequisites]: {% post_url databases/mysql/version-upgrades/2000-01-01-mysql-84-prerequisites %}
