---
title: Changing Plan of a Scalingo for PostgreSQL® Dedicated Resources Database
nav: Changing Plan
modified_at: 2026-02-13 12:00:00
tags: databases postgresql dedicated
index: 3
---

At Scalingo, all databases addons plans are identified using a name made of two
or three parts separated by a dash (-). This name is made of:

1. a database ***type*** : `postgresql`
2. a ***class*** : either `starter`, `business` or `enterprise` (learn more about
   [service classes][service-classes])
3. a ***size*** : specifying the amount of RAM available with the plan, in MB.

You can change your Scalingo for PostgreSQL® Dedicated Resources Database plan 
whenever you want. The operation is launched instantly, no manual input is
required.

Service class changes are supported in both directions (scale-out or scale-in)
for a given size. However, size/resources changes are supported only in a
scale-up direction: moving to a smaller size is not supported.

The impact on your application and the downtime vary depending on several
factors such as the current plan being used and the one you wish to change for
(see below for further information).


## Understanding the Plan Change Process

Plan changes can combine two dimensions:

- Topology:
  - **Single-node** (`Starter`)
  - **Multi-node cluster** (`Business` and `Enterprise`)
- Size (RAM per node)

### Single-node to Single-node (Scale-up)

This covers `Starter` to `Starter` when increasing size. The platform reboots
the existing instance with the new size.

| From topology | To topology | To size | Downtime | Typical duration |
|---------------|-------------|---------|----------|------------------|
| Single-node (`Starter`) | Single-node (`Starter`) | Larger only | **Yes** | ~15 minutes |

### Single-node to Multi-node Cluster (Scale-out)

This covers moves from `Starter` to `Business` or `Enterprise`. The platform
creates additional node(s) and configures replication/failover.

| From topology | To topology | To size | Downtime | Typical duration |
|---------------|-------------|---------|----------|------------------|
| Single-node (`Starter`) | Multi-node (`Business`/`Enterprise`) | Same or Larger | **No** | ~15 minutes |

### Multi-node Cluster to Multi-node Cluster

This covers `Business` <-> `Enterprise`, as well as size increases within the
same class.

| From topology | To topology | To size | Downtime | Typical duration |
|---------------|-------------|---------|----------|------------------|
| Multi-node (`Business`/`Enterprise`) | Multi-node (`Business`/`Enterprise`) | Same or Larger | **No** | ~15 minutes |

### Multi-node Cluster to Single-node (Scale-in)

This covers moves from `Business` or `Enterprise` to `Starter`.

| From topology | To topology | To size | Downtime | Typical duration |
|---------------|-------------|---------|----------|------------------|
| Multi-node (`Business`/`Enterprise`) | Single-node (`Starter`) | Same | **No** | ~2-3 minutes |
| Multi-node (`Business`/`Enterprise`) | Single-node (`Starter`) | Larger | **Yes** | ~15 minutes |
| Multi-node (`Business`/`Enterprise`) | Single-node (`Starter`) | Smaller | Not supported | N/A |


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
   scalingo addons-plans postgresql-ng
   ```
   The output should look like this:
   ```text
   ┌─────────────────────────────────┬─────────────────┐
   │               ID                │      NAME       │
   ├─────────────────────────────────┼─────────────────┤
   │ postgresql-dr-starter-4096      │ Starter 4G      │
   │ postgresql-dr-starter-8192      │ Starter 8G      │
   │ postgresql-dr-starter-16384     │ Starter 16G     │
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
   resource "scalingo_database" "my-dedicated-database" {  
     name       = "my-dedicated-database"  
     technology = "postgresql-ng"  
     plan       = "postgresql-dr-business-4096"  
   }  
   ```
   In this example, we switch the `my-dedicated-database` resource to a dedicated PostgreSQL Business 4096 addon.
2. Run `terraform plan` and check if the result looks good
3. If so, run `terraform apply`


[cli]: {% post_url tools/cli/2000-01-01-start %}
[service-classes]: {% post_url databases/about/2000-01-01-overview %}#service-classes
