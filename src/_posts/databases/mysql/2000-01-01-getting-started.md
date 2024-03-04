---
title: Getting Started With Scalingo for MySQL®
nav: Getting Started
modified_at: 2024-03-04 00:00:00
tags: databases mysql addon
index: 2
---

## Adding Scalingo for MySQL® to Your App

Once you have chosen the right plan for your needs, you are ready to provision
the addon. This can be done via our [dashboard](#using-the-dahboard),
our [CLI tool](#using-the-command-line) or via our
[Terraform Provider](#using-the-terraform-provider).

### Using the Dashboard

1. From your web browser, open your [dashboard](https://dashboard.scalingo.com/apps)
2. Click on the application for which you want to add a MySQL® database
3. Click on the **Resources** tab
4. Locate the **Addons** block and click on the **Add an addon** button
5. Select **MySQL**® in the databases block and click the **Go to plan
   selection** button
6. Select the plan you want to provision
7. Click the **Finish** button
8. Give the platform a few seconds to ship your database and enjoy!

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, list the plans available for `mysql`:
   ```bash
   scalingo addons-plans mysql
   ```
   The output should look like this:
   ```text
   +-----------------------+---------------+
   |             ID        |     NAME      |
   +-----------------------+---------------+
   | mysql-sandbox         | Sandbox       |
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
   In this example, we create a MySQL Starter 512 addon named `my-db` and
   attach it to an app named `my-app` (which must exist). We could have done
   the same with another plan.
2. Run `terraform plan` and check if the result looks good
3. If so, run `terraform apply`
4. After a few seconds, your database is ready to use. Enjoy!


## Accessing the MySQL® Dashboard

Every MySQL® addon comes with its dedicated dashboard, generally referred
to as **database dashboard**, which is the central place for administrative
tasks such as:

- [Monitoring the database]({% post_url databases/mysql/2000-01-01-monitoring %})
  through logs, metrics and statistics
- [Upgrading the database]({% post_url databases/mysql/2000-01-01-managing %})
  engine version
- [Enabling specific features]({% post_url databases/mysql/2000-01-01-managing %})
- [Managing database users]({% post_url databases/mysql/2000-01-01-managing %})
- [Managing backups]({% post_url databases/mysql/2000-01-01-backing-up %})

You can access the database dashboard via the application dashboard:

1. From your web browser, open your [dashboard](https://dashboard.scalingo.com/apps)
2. Click on the application for which you want to manage your database
3. Click on the **Overview** tab
4. Locate the **Addons** block and click on the **Dashboard** button next to
   the database you want to manage.
