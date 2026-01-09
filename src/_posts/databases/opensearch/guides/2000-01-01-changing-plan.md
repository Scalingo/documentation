---
title: Changing Plan
nav: Changing Plan
modified_at: 2025-05-26 12:00:00
tags: databases opensearch addon
index: 3
---

At Scalingo, all databases addons plans are identified by a name made of two
or three parts, each separated by a dash (-). This name is made of:

1. a database ***type*** : `opensearch`
2. a ***class*** : either `starter` or `business` (learn more about
   [classes][db-plans]).
3. a ***size*** : specifying the amount of RAM available with the plan, in MB
   (only for starter and business classes).

You can change your Scalingo for OpenSearch® addon plan whenever you want. The
operation is launched instantly, no manual input is required.

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
instance with the new size. This leads to a service interruption during which
the database is not available. This shouldn't exceed a few minutes though.

| From (class) | To (class) | To (size) | Downtime | Duration    |
| ------------ | ---------- | --------- | -------- | ----------- |
| Starter      | Starter    | Any       | **Yes**  | 2-4 minutes |

### From Starter to Business

When changing for a Business plan, the platform first starts two new
instances with the targeted size. If necessary, it then reboots the existing
instance with the targeted size. OpenSearch® then does the necessary to
distribute the data, in accordance with the indexes setup. There should be no
downtime at all, thanks to the failover mechanism included with the Business
plan.

| From (class) | To (class) | To (size) | Downtime | Duration |
| ------------ | ---------- | --------- | -------- | -------- |
| Starter      | Business   | Any       | **No**   | Zero     |

### From Business to Starter

When changing for a lower class, the platform uses OpenSearch®'s API to exclude
the non cluster-manager nodes from the cluster. OpenSearch® does the necessary
to bring the data back to the cluster-manager node. It then powers off the
excluded nodes. The remaining node is then rebooted, which leads to a small
service interruption during which the database is not available. This shouldn't
exceed a few minutes though.

| From (class) | To (class) | To (size) | Downtime | Duration    |
| ------------ | ---------- | --------- | -------- | ----------- |
| Business     | Starter    | Same      | **Yes**  | 2-4 minutes |
| Business     | Starter    | Larger    | **Yes**  | 2-4 minutes |
| Business     | Starter    | Smaller   | **Yes**  | 2-4 minutes |

### From Business to Business

When changing the size of a Business plan, the platform first reboots the
cluster-manager node with the targeted new size. It then reboots the other
nodes with the targeted new size. There's no downtime during this
operation, thanks to the failover mechanism included in the Business plan.

| From (class) | To (class) | To (size) | Downtime | Duration |
| ------------ | ---------- | --------- | -------- | -------- |
| Business     | Business   | Any       | **No**   | Zero     |


## Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Click on the application for which you want to scale the Scalingo for
   OpenSearch® addon
3. Click on the **Resources** tab
4. Locate the **Addons** block and click on the **…** button
5. From the dropdown menu, select **Change plan**
6. Select the new plan
7. Click the **Finish** button
8. Validate by clicking the **Confirm plan change** button


## Using the Database Dashboard

1. From your web browser, [open your database dashboard][db-dashboard]
2. Click the **Settings** tab
3. In **General**, locate the **Database Plan** block
4. In this block, click the **Change plan** button
5. Select the new plan
6. Click the **Finish** button
7. Validate by clicking the **Confirm plan change** button


## Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list the plans available for `opensearch`:
   ```bash
   scalingo addons-plans opensearch
   ```
   The output should look like this:
   ```text
   +----------------------------+---------------+
   |             ID             |     NAME      |
   +----------------------------+---------------+
   | opensearch-starter-1024    | Starter 1G    |
   | opensearch-starter-2048    | Starter 2G    |
   ...
   ```
3. Locate the `ID` corresponding to the plan you want to scale to (for example
   `opensearch-business-2048`)
4. Change plan using the `addons-upgrade` sub-command:
   ```bash
   scalingo --app my-app addons-upgrade opensearch <plan_ID>
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
     provider_id = "opensearch"
     plan = "opensearch-business-2048"
     app = "${scalingo_app.my-app.id}"
   }
   ```
   In this example, we switch the `my-db` resource attached to the `my-app`
   application to a OpenSearch® Business 2048 addon.


[dashboard]: https://dashboard.scalingo.com/apps

[cli]: {% post_url tools/cli/2000-01-01-start %}
[db-plans]: {% post_url databases/about/2000-01-01-overview %}#database-plans
[db-dashboard]: {% post_url databases/about/2000-01-01-database-dashboard %}
