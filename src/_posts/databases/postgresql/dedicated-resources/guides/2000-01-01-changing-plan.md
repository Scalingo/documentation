---
title: Changing Plan of a Scalingo for PostgreSQL® Dedicated Resources Database
nav: Changing Plan
modified_at: 2026-02-13 12:00:00
tags: databases postgresql dedicated
index: 3
---

At Scalingo, all databases plans are identified using a name made of two or 
three parts separated by a dash (-). This name is made of:

1. a database ***type*** : `postgresql`
2. a ***class*** : either `starter`, `business` or `enterprise` (learn more about
   [service classes][service-classes])
3. a ***size*** : specifying the amount of RAM available with the plan, in MB.

You can change your Scalingo for PostgreSQL® Dedicated Resources Database plan 
whenever you want. The operation is launched instantly, no manual input is
required.

Service class changes are supported in both directions (scale-out or scale-in)
for a given size. **However, size/resources changes are supported only in a
scale-up direction: moving to a smaller size is not supported.**

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

1. From your web browser, open your [dashboard][database-dashboard]
2. Click on the **Settings** tab
3. Locate the **Database plan** block and click on the **Change plan** button
4. Select the new plan
5. Click the **Finish** button
6. Validate by clicking the **Confirm plan change** button


## Using the Command Line (Preview)

Because Dedicated Resources databases are not yet generally available,
you must first enable preview features to use the related CLI commands:

```sh
export SCALINGO_PREVIEW_FEATURES=true
```

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list your databases:
   ```bash
   scalingo databases
   ```
3. Locate the `ID` of the database you want to scale (for example
   `my-dedicated-database`).
4. From the command line, list the plans available for `postgresql-ng`:
   ```bash
   scalingo database-list-plans postgresql-ng
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
5. Locate the `ID` corresponding to the plan you want to scale to (for example
   `postgresql-dr-starter-8192`)
6. Change plan with:
   ```bash
   scalingo database-upgrade <database_ID> <plan_ID>
   ```
   Example:
   ```bash
   scalingo database-upgrade 699d6312565f770d0a6cdab3 postgresql-dr-starter-8192
   ```
   The output should look like this:
   ```text
   -----> Your postgresql-ng database 699d6312565f770d0a6cdab3 ('my-dedicated-database') is being upgraded…
   ```

Optionally you can use `--wait` in order to make the command synchronous.
```bash
scalingo database-upgrade --database 699d6312565f770d0a6cdab3 --wait postgresql-dr-starter-8192
```

## Using the Terraform Provider

1. Update the `plan` property of the corresponding Resource block in your
   Terraform file to scale the database:
   ```tf
   resource "scalingo_database" "my-dedicated-database" {  
     name       = "my-dedicated-database"  
     technology = "postgresql-ng"  
     plan       = "postgresql-dr-starter-8192"  
   }  
   ```
   In this example, we switch the `my-dedicated-database` resource to a dedicated PostgreSQL Starter 8192 database.
2. Run `terraform plan` and check if the result looks good
3. If so, run `terraform apply`


[cli]: {% post_url tools/cli/2000-01-01-start %}
[service-classes]: {% post_url databases/about/2000-01-01-overview %}#service-classes
[database-dashboard]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard
