---
title: Changing Plan of a Scalingo for PostgreSQL® Shared Resources Database
nav: Changing Plan
modified_at: 2025-12-23 00:00:00
tags: databases postgresql addon
index: 3
---

At Scalingo, all databases addons plans are identified using a name made of two
or three parts separated by a dash (-). This name is made of:

1. a database ***type*** : `postgresql`
2. a ***class*** : either `starter` or `business` (learn more about
   [classes][databases-plans])
3. a ***size*** : specifying the amount of RAM available with the plan, in MB
   (only for starter and business classes).

You can change your Scalingo for PostgreSQL® Shared Resources Database addon 
plan whenever you want. The operation is launched instantly, no manual input is 
required.

The impact on your application and the downtime vary depending on several
factors such as the current plan being used and the one you wish to change for
(see below for further information).

{% warning %}
While switching to a more powerful plan is rather safe, you should take extra
care when changing for a less powerful plan: please make sure the new plan can
handle all your data and fits your application workload.
{% endwarning %}


## Understanding the Plan Change Process

### From Starter to Starter

When changing the size of a Starter plan, the platform reboots the existing
instance with the new size. This leads to a small service interruption
during which the database is not available. This shouldn't exceed a few seconds
though.

| From (class) | To (class) | To (size) | Downtime | Duration     |
| ------------ | ---------- | --------- | -------- | ------------ |
| Starter      | Starter    | Any       | **Yes**  | 2-10 seconds |

### From Starter to Business

When changing for a Business plan, the platform first starts a follower
instance with the targeted size. If necessary, it then reboots the primary
instance with the targeted size. There should be no downtime at all, thanks to
the failover mechanism included with the Business plan.

| From (class) | To (class) | To (size) | Downtime | Duration     |
| ------------ | ---------- | --------- | -------- | ------------ |
| Starter      | Business   | Any       | **No**   | Zero         |

### From Business to Starter

When changing for a lower class, the platform first powers the follower
instance off. When necessary, the remaining primary instance is rebooted with
the targeted new size. This can lead to a small service interruption during
which the database is not available. This shouldn't exceed a few seconds
though.

| From (class) | To (class) | To (size) | Downtime | Duration     |
| ------------ | ---------- | --------- | -------- | ------------ |
| Business     | Starter    | Same      | **No**   | Zero         |
| Business     | Starter    | Larger    | **Yes**  | 2-10 seconds |
| Business     | Starter    | Smaller   | **Yes**  | 2-10 seconds |

### From Business to Business

When changing the size of a Business plan, the platform first reboots the
primary instance with the targeted new size. It then reboots the follower
instance with the targeted new size. There's no downtime during this
operation, thanks to the failover mechanism included in the Business plan.

| From (class) | To (class) | To (size) | Downtime | Duration     |
| ------------ | ---------- | --------- | -------- | ------------ |
| Business     | Business   | Any       | **No**   | Zero         |


## Using the Dashboard

1. From your web browser, open your [dashboard][app-dashbaord]
2. Click on the application for which you want to scale the Scalingo for
   PostgreSQL® addon
3. Click on the **Resources** tab
4. Locate the **Addons** block and click on the **…** button
5. From the dropdown menu, select **Change plan**
6. Select the new plan
7. Click the **Finish** button
8. Validate by clicking the **Confirm plan change** button


## Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list the plans available for `postgresql`:
   ```bash
   scalingo addons-plans postgresql
   ```
   The output should look like this:
   ```text
   +----------------------------+---------------+
   |             ID             |     NAME      |
   +----------------------------+---------------+
   | postgresql-starter-512     | Starter 512M  |
   | postgresql-starter-1024    | Starter 1G    |
   ...
   ```
3. Locate the `ID` corresponding to the plan you want to scale to (for example
   `postgresql-business-1024`)
4. Change plan using the `addons-upgrade` sub-command:
   ```bash
   scalingo --app my-app addons-upgrade postgresql <plan_ID>
   ```
   The output should look like this:
   ```text
   -----> Addon ad-d0aa540a-5ed2-41f8-8bbe-91e3aff6623b has been upgraded
          Message from addon provider: Database plan is being changed
   ```


## Using the Terraform Provider

1. Update the `plan` property of the corresponding Resource block in your
   Terraform file to scale the addon:
   ```tf
   resource "scalingo_addon" "my-db" {
     provider_id = "postgresql"
     plan = "postgresql-business-1024"
     app = "${scalingo_app.my-app.id}"
   }
   ```
   In this example, we switch the `my-db` resource attached to the `my-app`
   application to a PostgreSQL Business 1024 addon.
2. Run `terraform plan` and check if the result looks good
3. If so, run `terraform apply`


[app-dashboard]: https://dashboard.scalingo.com/apps
[cli]: {% post_url tools/cli/2000-01-01-start %}
[databases-plans]: {% post_url databases/about/2000-01-01-overview %}#database-plans
