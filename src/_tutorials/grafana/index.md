---
title: Deploying Grafana
logo: grafana
category: analytics
products:
  - Scalingo for PostgreSQL®
  - Multi-buildpack
modified_at: 2025-08-12
---

Grafana is an open-source platform for visualizing and monitoring data from
various sources. It lets you create interactive dashboards with charts, graphs,
and alerts. It's commonly used for infrastructure, application and business
metrics monitoring.


## Planning your Deployment

- Grafana requires its own database to store its configuration. We usually
  advise to opt at least for a [PostgreSQL® Starter or Business 512
  addon][db-postgresql] for this purpose.

- While Grafana's officially recommends to have a minimum of 512MB of RAM, we
  usually advise to have a bit more, and go with at least one L container (with
  1GB of RAM) to host your Grafana instance.


## Deploying

### Using the Command Line

We maintain a repository called [grafana-scalingo] on GitHub to help you deploy
Grafana on Scalingo. Here are the few additional steps you will need to follow:

1. Clone our repository:
   ```bash
   git clone https://github.com/Scalingo/grafana-scalingo
   cd grafana-scalingo
   ```

2. Create the application on Scalingo:
   ```bash
   scalingo create my-grafana
   ```

   Notice that our Command Line automatically detects the git repository, and
   adds a git remote to Scalingo:
   ```bash
   git remote -v

   origin   https://github.com/Scalingo/grafana-scalingo (fetch)
   origin   https://github.com/Scalingo/grafana-scalingo (push)
   scalingo git@ssh.osc-fr1.scalingo.com:my-grafana.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:my-grafana.git (push)
   ```

3. Provision a Scalingo for PostgreSQL® Starter 512 addon:
   ```bash
   scalingo --app my-grafana addons-add postgresql postgresql-starter-512
   ```

4. (optional) Instruct the platform to run the `web` process type in a single L
   container:
   ```bash
   scalingo --app my-grafana scale web:1:L
   ```

5. Set a few **mandatory** environment variables:\\
   These must be set with the given values:
   ```bash
   scalingo --app my-grafana env-set GF_SERVER_HTTP_PORT=\$PORT
   scalingo --app my-grafana env-set GF_PATHS_PLUGINS=/app/plugins
   ```

   The following ones must be set to the appropriate values:
   ```bash
   scalingo --app my-grafana env-set GF_SERVER_ROOT_URL=https://my-grafana.osc-fr1.scalingo.io
   scalingo --app my-grafana env-set GF_SECURITY_ADMIN_USER=<set this to whatever suits you>
   scalingo --app my-grafana env-set GF_SECURITY_ADMIN_PASSWORD=<set this to whatever suits you>
   ```

6. Everything's ready, deploy to Scalingo:
   ```bash
   git push scalingo master
   ```

### Using the Terraform Provider

{% note%}
The following code blocks are given as examples.\\
Please adjust the values to suit your needs.
{% endnote %}

1. Start by forking our [Grafana repository][grafana-scalingo]

2. Place the following block in your Terraform file to create the app:
   ```terraform
   resource "scalingo_app" "my-grafana" {
     name        = "my-grafana"
     stack_id    = "scalingo-22"
     force_https = true

     environment = {
       GF_SERVER_HTTP_PORT        = "$PORT",
       GF_PATHS_PLUGINS           = "/app/plugins",
       GF_SERVER_ROOT             = <URL OF YOUR APP>,
       GF_SECURITY_ADMIN_USER     = <ADMIN USER>,
       GF_SECURITY_ADMIN_PASSWORD = <PASSWORD FOR ADMIN USER>
     }
   }
   ```

3. Link the app to your forked repository:
   ```terraform
   data "scalingo_scm_integration" "github" {
     scm_type = "github"
   }

   resource "scalingo_scm_repo_link" "default" {
     auth_integration_uuid = data.scalingo_scm_integration.github.id
     app                   = scalingo_app.my-grafana.id
     source                = "https://github.com/<username>/grafana-scalingo"
     branch                = "master"
   }
   ```

4. Provision a Scalingo for PostgreSQL® Starter 512 addon and attach it to your
   app:
   ```terraform
   resource "scalingo_addon" "my-grafana-postgresql" {
     app         = scalingo_app.my-grafana.id
     provider_id = "postgresql"
     plan        = "postgresql-starter-512"
   }
   ```

5. (optional) Instruct the platform to run the `web` process type in a single L
   container:
   ```terraform
   resource "scalingo_container_type" "web" {
     app    = scalingo_app.my-grafana.id
     name   = "web"
     size   = "L"
     amount = 1
   }
   ```

6. Run `terraform plan` and check if the result looks good
7. If so, run `terraform apply`
8. Once Terraform is done, your Grafana instance is ready to be deployed:
   1. Head to your [dashboard]
   2. Click on your Grafana application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button
   6. After a few seconds, your Grafana instance is finally up and running!


## Updating

By default, Scalingo tries to install the latest version of Grafana.

Consequently, updating Grafana only consists in triggering a new deployment of
your instance.

### Using the Command Line

1. In your Grafana repository, create an empty commit and push it to Scalingo:
   ```bash
   git commit --allow-empty -m "Update Grafana"
   git push scalingo master
   ```

### Using the Terraform Provider

1. Head to your [dashboard]
2. Click on your Grafana application
3. Click on the Deploy tab
4. Click on Manual deployment in the left menu
5. Click the Trigger deployment button
6. After a few seconds, your updated Grafana instance is ready!


## Customizing

### Adding Plugins

Grafana plugins extend its functionality by adding new data sources,
visualization panels, or app integrations. They let you connect to more
systems, display custom charts, or bundle dashboards with specific tools.

#### Adding Publicly Available Plugins

1. From the [Grafana plugins][grafana-plugins] website, identify the name of
   the plugins you are interested in. It's generally available from the
   **installation** tab of the plugin.

2. Put these names in the `GRAFANA_PLUGINS` environment variable of your
   Grafana app.\\
   For multiple plugins, use a comma (`,`) as separator. For example:
   ```
   GRAFANA_PLUGINS="grafana-clock-panel,esnet-arcdiagram-panel"
   ```

#### Adding Private Plugins

1. Put your unzipped plugins in a directory named `plugins`, at the root of
   your Grafana project. The buildpack automatically picks them during
   deployment.

### Storing Images on External Services

Grafana supports automatic rendering of panels as PNG images. This feature can
be used to display images along with notifications.

To make Grafana send images on an S3 bucket, please use the following
environment variables:

```bash
GF_EXTERNAL_IMAGE_STORAGE_PROVIDER=s3
GF_EXTERNAL_IMAGE_STORAGE_S3_ACCESS_KEY=<Fill this field>
GF_EXTERNAL_IMAGE_STORAGE_S3_BUCKET=<Fill this field>
GF_EXTERNAL_IMAGE_STORAGE_S3_REGION=<Fill this field>
GF_EXTERNAL_IMAGE_STORAGE_S3_SECRET_KEY=<Fill this field>
```

### Environment

[Grafana is fully configurable via environment variables][grafana-env].

Moreover, the buildpack makes use of the following environment variable(s).
They can be leveraged to customize your deployment:

- **`GRAFANA_VERSION`**\\
  Allows to specify the Grafana version to deploy.\\
  Defaults to the version set in the buildpack.

- **`GRAFANA_PLUGINS`**\\
  A list of plugin names to install.\\
  Separate names with a comma.\\
  Defaults to being empty.


[grafana-env]: https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#override-configuration-with-environment-variables
[grafana-plugins]: https://grafana.com/grafana/plugins/
[grafana-scalingo]: https://github.com/Scalingo/grafana-scalingo

[db-postgresql]: https://www.scalingo.com/databases/postgresql

[dashboard]: https://dashboard.scalingo.com
[one-click]: https://dashboard.scalingo.com/create/app?source=https://github.com/Scalingo/grafana-scalingo
