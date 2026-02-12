---
title: Provisioning a Scalingo for PostgreSQL® Dedicated Resources Database
nav: Provisioning
modified_at: 2026-02-12 12:00:00
tags: databases postgresql dedicated
index: 1
---


Once you have chosen the right plan for your needs, you are ready to provision
the addon. This can be done via our 
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

### Using the Command Line (TO UPDATE)

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list the plans available for `postgresql`:
   ```bash
   scalingo --app my-app addons-plans postgresql-ng
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
3. Locate the `ID` corresponding to the plan you want to deploy (for example 
   `postgresql-starter-512`)
4. Provision the addon:
   ```bash
   scalingo --app my-app addons-add postgresql <plan_ID>
   ```
   The output should look like this:
   ```text
   -----> Addon postgresql has been provisionned
          ID: my_app_wxyz
          Message from addon provider: Database is being provisioned
   ```
5. Wait a few seconds for the addon to be provisioned and enjoy!

### Using the Terraform Provider (To Update)

1. Place the following `resource` block in your Terraform file to create the
   addon and attach it to your app:
   ```tf
   resource "scalingo_addon" "my-db" {
     provider_id = "postgresql"
     plan = "postgresql-starter-512"
     app = "${scalingo_app.my-app.id}"
   }
   ```
   In this example, we create a PostgreSQL Starter 512 addon named `my-db` and
   attach it to an app named `my-app` (which must exist). We could have done
   the same with another plan.
2. Run `terraform plan` and check if the result looks good
3. If so, run `terraform apply`
4. After a few seconds, your database is ready to use. Enjoy!

### Using the Kubernetes Operator (To Update)

XXX


## Accessing the Scalingo for PostgreSQL® Dashboard

Every PostgreSQL® addon comes with its dedicated dashboard, generally referred
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

[pg-dr-monitoring]: {% post_url databases/postgresql/shared-resources/guides/2000-01-01-monitoring %}
[pg-dr-upgrading]: {% post_url databases/postgresql/shared-resources/guides/2000-01-01-upgrading %}
[pg-dr-managing-extensions]: {% post_url databases/postgresql/extensions/2000-01-01-managing-extensions %}
[pg-dr-managing-users]: {% post_url databases/postgresql/shared-resources/guides/2000-01-01-managing-users %}
[pg-dr-backing-up]: {% post_url databases/postgresql/shared-resources/guides/2000-01-01-backing-up %}
