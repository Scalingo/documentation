---
title: Provisioning a Scalingo for OpenSearch® Addon
nav: Provisioning
modified_at: 2025-04-23 12:00:00
tags: databases opensearch addon
index: 1
---


Once you have chosen the right plan for your needs, you are ready to provision
the addon. This can be done via our [dashboard](#using-the-dahboard),
our [CLI tool](#using-the-command-line) or via our
[Terraform Provider](#using-the-terraform-provider).


## Using the Dashboard

1. From your web browser, open your [dashboard][dashboard]
2. Click on the application for which you want to add an OpenSearch® database
3. Click on the **Resources** tab
4. Locate the **Addons** block and click on the **Add an addon** button
5. Select **OpenSearch**® in the databases block and click the **Go to plan
   selection** button
6. Select the plan you want to provision
7. Click the **Finish** button
8. Give the platform a few seconds to ship your database and enjoy!


## Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, list the plans available for `opensearch`:
   ```bash
   scalingo --app my-app addons-plans opensearch
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
3. Locate the `ID` corresponding to the plan you want to deploy (for example 
   `opensearch-starter-2048`)
4. Provision the addon:
   ```bash
   scalingo --app my-app addons-add opensearch <plan_ID>
   ```
   The output should look like this:
   ```text
   -----> Addon opensearch has been provisionned
          ID: my_app_wxyz
          Message from addon provider: Database is being provisioned
   ```
5. Wait a few seconds for the addon to be provisioned and enjoy!


## Using the Terraform Provider

1. Place the following `resource` block in your Terraform file to create the
   addon and attach it to your app:
   ```tf
   resource "scalingo_addon" "my-db" {
     provider_id = "opensearch"
     plan = "opensearch-starter-2048"
     app = "${scalingo_app.my-app.id}"
   }
   ```
   In this example, we create an OpenSearch Starter 2048 addon named `my-db`
   and attach it to an app named `my-app` (which must exist). We could have
   done the same with another plan.


[dashboard]: https://dashboard.scalingo.com/apps
[cli]: {% post_url tools/cli/2000-01-01-start %}
[monitoring]: {% post_url databases/opensearch/guides/2000-01-01-monitoring %}
[managing-users]: {% post_url databases/opensearch/guides/2000-01-01-managing-users %}
[backing-up]: {% post_url databases/opensearch/guides/2000-01-01-backing-up %}
