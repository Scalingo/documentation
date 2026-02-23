---
title: Provisioning a Scalingo for PostgreSQL® Dedicated Resources Database
nav: Provisioning
modified_at: 2026-02-13 12:00:00
tags: databases postgresql dedicated
index: 1
---


Once you have chosen the right plan for your needs, you are ready to provision
the database. This can be done via our 
[dashboard](#using-the-dahboard), our 
[CLI tool](#using-the-command-line), our
[Terraform Provider](#using-the-terraform-provider), or via our 
[Kubernetes Operator](#usint-the-kubernetes-operator).


## Provisioning

### Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Select the **Project** where you want to create the database
3. Click the arrow next to **Create an application**, then click
   **Database Dedicated Resources**
4. In the **Databases engines** section, select 
   **PostgreSQL Dedicated Resources** and confirm your choice
5. Enter a database name, then select or confirm the appropriate **Project** and
   **Region**
6. Select the plan you want to provision and confirm your selection
7. Click the **Create database** button
8. Database provisioning typically takes 15–30 minutes

### Using the Command Line (Preview)

Because Dedicated Resources databases are not yet generally available,
you must first enable preview features to use the related CLI commands:

```sh
export SCALINGO_PREVIEW_FEATURES=true
```


1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list the plans available for `postgresql`:
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
3. Locate the `ID` corresponding to the plan you want to deploy (for example 
   `postgresql-dr-starter-4096`)
4. Provision the database:
   ```bash
   scalingo database-create --type postgresql-ng --plan <plan_ID> <database_name>
   ```
   The output should look like this:
   ```text
   -----> Your postgresql-ng database 698e082f968c27dfb8a27521 ('my-dedicated-database') is being provisioned…
   ```
5. Database provisioning typically takes 15–30 minutes

Optionally you can use `--wait` in order to make the command synchronous.
```bash
scalingo database-create --type postgresql-ng --plan <plan_ID> --wait sfdsfsdf
```

### Using the Terraform Provider (To Update)

1. Place the following `resource` block in your Terraform file to create the
   database and attach it to your app:
   ```tf
   resource "scalingo_database" "my-dedicated-database" {
     name       = "my-dedicated-database"
     technology = "postgresql-ng"
     plan       = "postgresql-dr-starter-4096"
   }
   ```
   In this example, we create a dedicated PostgreSQL Starter 4096 database named `my-dedicated-database`. We could have done the same with another plan.
2. Run `terraform plan` and check if the result looks good
3. If so, run `terraform apply`
4. Database provisioning typically takes 15–30 minutes

### Using the Kubernetes Operator (To Update)

XXX


## Accessing the Scalingo for PostgreSQL® Dashboard

Every PostgreSQL® database comes with its dedicated dashboard, generally referred
to as **database dashboard**, which is the central place for administrative
tasks such as:

- [Monitoring the database][pg-dr-monitoring] through logs, metrics and statistics
- [Upgrading the database][pg-dr-upgrading] engine version
- [Enabling specific features][pg-dr-managing-extensions]
- [Managing database users][pg-dr-managing-users]
- [Managing backups][pg-dr-backing-up]

You can access the database dashboard from the main dashboard:

1. From your web browser, open your [dashboard][dashboard]
2. Open the **Project** containing the database you want to manage
3. In the **Databases** section, click the database name


[dashboard]: https://dashboard.scalingo.com/apps
[architecture-models]: {% post_url databases/about/2000-01-01-architecture-models %}

[cli]: {% post_url tools/cli/2000-01-01-start %}

[pg-dr-monitoring]: {% post_url databases/postgresql/dedicated-resources/guides/2000-01-01-monitoring %}
[pg-dr-upgrading]: {% post_url databases/postgresql/dedicated-resources/guides/2000-01-01-upgrading %}
[pg-dr-managing-extensions]: {% post_url databases/postgresql/extensions/2000-01-01-managing-extensions %}
[pg-dr-managing-users]: {% post_url databases/postgresql/dedicated-resources/guides/2000-01-01-managing-users %}
[pg-dr-backing-up]: {% post_url databases/postgresql/dedicated-resources/guides/2000-01-01-backing-up %}
