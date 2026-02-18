---
title: Deploying Metabase
logo: metabase
category: analytics
products:
  - postgresql
modified_at: 2025-08-12
---

Metabase is an open-source Business Intelligence tool that allows you to build
dashboards and data visualization from your company data, without writing SQL
queries.


## Planning your Deployment

- Metabase requires its own database to store its configuration and some
  metadata. We usually advise to use a [Scalingo for PostgreSQL® Starter or
  Business 512 addon][db-postgresql] for this purpose.

- Depending on several factors such as the amount of data stored in your
  production database, its load, and the complexity of the Metabase queries you
  want to run, you may consider duplicating your production data to an
  additional database dedicated for Metabase use. Doing so would prevent
  Metabase to have a negative impact on your application's performances.
  [Our documentation][db-duplicate] should help you with this additional task.


## Deploying

### Using our One-Click Deploy Button

Click the One-Click Deploy button below to automatically deploy Metabase with
your Scalingo account:

[![Deploy](https://cdn.scalingo.com/deploy/button.svg)][one-click]

### Using the Command Line

We maintain a repository called [metabase-scalingo]
on GitHub to help you deploy Metabase on Scalingo. Here are the few additional
steps you will need to follow:

1. Clone our repository:
   ```bash
   git clone https://github.com/Scalingo/metabase-scalingo
   cd metabase-scalingo
   ```

2. Create the application on Scalingo:
   ```bash
   scalingo create my-metabase
   ```

   Notice that our Command Line automatically detects the git repository, and
   adds a git remote to Scalingo:
   ```bash
   git remote -v

   origin   https://github.com/Scalingo/metabase-scalingo (fetch)
   origin   https://github.com/Scalingo/metabase-scalingo (push)
   scalingo git@ssh.osc-fr1.scalingo.com:my-metabase.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:my-metabase.git (push)
   ```

3. Provision a Scalingo for PostgreSQL® Starter 512 addon:
   ```bash
   scalingo --app my-metabase addons-add postgresql postgresql-starter-512
   ```

4. (optional) Instruct the platform to run the `web` process type in a single
   XL container:
   ```bash
   scalingo --app -my-metabase scale web:1:XL
   ```

5. Everything's ready, deploy to Scalingo:
   ```bash
   git push scalingo master
   ```

### Using the Terraform Provider

{% note%}
The following code blocks are given as examples.\\
Please adjust the values to suit your needs.
{% endnote %}

1. Start by forking our [Metabase repository][metabase-scalingo]

2. Place the following block in your Terraform file to create the app:
   ```terraform
   resource "scalingo_app" "my-metabase" {
     name        = "my-metabase"
     stack_id    = "scalingo-22"
     force_https = true
   }
   ```

3. Link the app to your forked repository:
   ```terraform
   data "scalingo_scm_integration" "github" {
     scm_type = "github"
   }

   resource "scalingo_scm_repo_link" "default" {
     auth_integration_uuid = data.scalingo_scm_integration.github.id
     app                   = scalingo_app.my-metabase.id
     source                = "https://github.com/<username>/metabase-scalingo"
     branch                = "master"
   }
   ```

4. Provision a Scalingo for PostgreSQL® Starter 512 addon and attach it to your
   app:
   ```terraform
   resource "scalingo_addon" "my-metabase-db" {
     app         = scalingo_app.my-metabase.id
     provider_id = "postgresql"
     plan        = "postgresql-starter-512"
   }
   ```

5. (optional) Instruct the platform to run the `web` process type in a single
   XL container:
   ```terraform
   resource "scalingo_container_type" "web" {
     app    = scalingo_app.my-metabase.id
     name   = "web"
     size   = "XL"
     amount = 1
   }
   ```

6. Run `terraform plan` and check if the result looks good

7. If so, run `terraform apply`

8. Once Terraform is done, your Metabase instance is ready to be deployed:
   1. Head to your [dashboard]
   2. Click on your Metabase application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button
   6. After a few seconds, your Metabase instance is finally up and running!


## Updating

By default, Scalingo tries to install the latest version of Metabase.

Consequently, updating Metabase only consists in triggering a new deployment of
your instance.

{% note %}
Scalingo tries to retrieve the latest version number by querying the GitHub
API, which is subject to API rate-limits. If the deployment fails, a simple
workaround consists in specifying the Metabase version you want to deploy
([see below](#environment)).
{% endnote %}

### Using the Command Line

1. In your Metabase repository, create an empty commit and push it to Scalingo:
   ```bash
   git commit --allow-empty -m "Update Metabase"
   git push scalingo master
   ```

### Using the Terraform Provider

1. Head to your [dashboard]
2. Click on your Metabase application
3. Click on the **Deploy** tab
4. Click on **Manual deployment** in the left menu
5. Click the **Trigger deployment** button
6. After a few seconds, your updated Metabase instance is ready!


## Customizing

### Environment

[Metabase supports many environment variables][metabase-env].

Moreover, the buildpack makes use of the following environment variable(s).
They can be leveraged to customize your deployment:

- **`METABASE_VERSION`**\\
  Allows to specify the version of Metabase to deploy.\\
  Make sure to prefix the number with the letter **v**.\\
  Defaults to `*`.


[metabase-env]: https://www.metabase.com/docs/latest/operations-guide/environment-variables.html
[metabase-scalingo]: https://github.com/Scalingo/metabase-scalingo

[db-postgresql]: https://www.scalingo.com/databases/postgresql
[dashboard]: https://dashboard.scalingo.com/apps/
[one-click]: https://dashboard.scalingo.com/create/app?source=https://github.com/Scalingo/metabase-scalingo

[db-duplicate]: {% post_url platform/databases/2000-01-01-duplicate %}
