---
title: Scalingo for PostgreSQL®
nav: Getting Started
modified_at: 2023-11-22 00:00:00
tags: databases postgresql addon
index: 2
---

## Adding Scalingo for PostgreSQL® to Your App

Once you have chosen the right plan for your needs, you are ready to provision
the addon. This can be done via our [dashboard](#using-the-dahboard),
our [CLI tool](#using-the-command-line) or via our
[Terraform Provider](#using-the-terraform-provider).

### Using the Dashboard

1. From your web browser, open your [dashboard](https://dashboard.scalingo.com/apps)
2. Click on the application for which you want to add a PostgreSQL database
3. Click on the **Resources** tab
4. Locate the **Addons** block and click on the **Add an addon** button
5. Select **PostgreSQL**® in the databases block and click the **Go to plan
   selection** button
6. Select the plan you want to provision
7. Click the **Finish** button
8. Give the platform a few seconds to ship your database and enjoy!

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo Command Line tool]({% post_url platform/cli/2000-01-01-start %})
2. From the command line, list the plans available for `postgresql`:
   ```bash
   scalingo --app my-app addons-plans postgresql
   ```
   The output should look like this:
   ```bash
   +----------------------------+---------------+
   |             ID             |     NAME      |
   +----------------------------+---------------+
   | postgresql-sandbox         | Sandbox       |
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
   ```bash
   -----> Addon postgresql has been provisionned
          ID: my_app_wxyz
          Message from addon provider: Database is being provisioned
   ```
5. Wait a few seconds for the addon to be provisioned and enjoy!

### Using the Terraform Provider

1. Place the following Resource block in your Terraform file to create the
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
