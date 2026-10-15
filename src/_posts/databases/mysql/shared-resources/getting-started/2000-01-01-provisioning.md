---
title: Provisioning a Scalingo for MySQL® Shared Resources Database
nav: Provisioning
modified_at: 2026-10-15 00:00:00
tags: databases mysql addon
index: 1
---

{% include database_architecture_models.md engine="MySQL®" %}

You can provision a MySQL® Shared Resources database as an application
add-on using the [dashboard](#using-the-dashboard),
[CLI](#using-the-command-line) or
[Terraform Provider](#using-the-terraform-provider).


## Provisioning

### Using the Dashboard

{% include database_provisioning_shared_resources_dashboard.md engine="MySQL®" %}

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list the plans available for `mysql`:
   ```bash
   scalingo addons-plans mysql
   ```
   The output should look like this:
   ```text
   +-----------------------+---------------+
   |          ID           |     NAME      |
   +-----------------------+---------------+
   | mysql-starter-512     | Starter 512M  |
   | mysql-starter-1024    | Starter 1G    |
   ...
   ```
3. Locate the `ID` corresponding to the plan you want to deploy (for example 
   `mysql-starter-512`)
4. Provision the addon:
   ```bash
   scalingo --app my-app addons-add mysql <plan_ID>
   ```
   The output should look like this:
   ```text
   -----> Addon mysql has been provisionned
          ID: my_app_wxyz
          Message from addon provider: Database is being provisioned
   ```
5. Wait a few seconds for the addon to be provisioned and enjoy!

### Using the Terraform Provider

1. Place the following `resource` block in your Terraform file to create the
   addon and attach it to your app:
   ```tf
   resource "scalingo_addon" "my-db" {
     provider_id = "mysql"
     plan = "mysql-starter-512"
     app = "${scalingo_app.my-app.id}"
   }
   ```
   In this example, we create a MySQL® Starter 512 addon named `my-db` and
   attach it to an app named `my-app` (which must exist). We could have done
   the same with another plan.
2. Run `terraform plan` and check if the result looks good
3. If so, run `terraform apply`
4. After a few seconds, your database is ready to use. Enjoy!


## Accessing the Scalingo for MySQL® Dashboard
{: #accessing-the-mysql-dashboard}

Every MySQL® addon comes with its dedicated dashboard, generally referred
to as **database dashboard**, which is the central place for administrative
tasks such as:

- [Monitoring the database][monitoring] through logs, metrics and statistics
- [Upgrading the database][upgrading] engine version
- [Managing database users][managing-users]
- [Using multiple databases][multiple-db]
- [Managing backups][backing-up]

{% include database_dashboard_access_shared_resources.md %}


[dashboard]: https://dashboard.scalingo.com/apps

[cli]: {% post_url tools/cli/2000-01-01-start %}

[monitoring]: {% post_url databases/mysql/shared-resources/guides/2000-01-01-monitoring %}
[upgrading]: {% post_url databases/mysql/shared-resources/guides/2000-01-01-upgrading %}
[managing-users]: {% post_url databases/mysql/shared-resources/guides/2000-01-01-managing-users %}
[multiple-db]: {% post_url databases/mysql/shared-resources/guides/2000-01-01-using-multiple-databases %}
[backing-up]: {% post_url databases/mysql/shared-resources/guides/2000-01-01-backing-up %}


