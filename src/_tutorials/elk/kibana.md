---
title: Kibana
is_series: true
series: Deploying an Elastic Stack
series_index: 3
modified_at: 2025-08-13
---

**Kibana** is a powerful web-based data visualization tool providing everything
needed to explore data and build useful and efficient dashboards.


## Deploying

### Using the Command Line

We maintain a repository called [kibana-scalingo] on GitHub to help you deploy
Kibana on Scalingo. Here are the few steps you will have to follow:

1. Clone our repository:

   ```bash
   git clone https://github.com/Scalingo/kibana-scalingo
   cd kibana-scalingo
   ```

2. Create the application on Scalingo:

   ```bash
   scalingo create my-kibana
   ```

   Notice that our Command Line automatically detects the git repository, and
   adds a git remote to Scalingo:

   ```bash
   git remote -v

   origin   https://github.com/Scalingo/kibana-scalingo (fetch)
   origin   https://github.com/Scalingo/kibana-scalingo (push)
   scalingo git@ssh.osc-fr1.scalingo.com:my-kibana.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:my-kibana.git (push)
   ```

3. Set a few environment variables:

   ```bash
   scalingo --app my-kibana env-set BUILDPACK_URL="https://github.com/Scalingo/kibana-buildpack"
   scalingo --app my-kibana env-set ELASTICSEARCH_URL="<elasticsearch-db-url>"
   ```

4. Deploy:

   ```bash
   git push scalingo master
   ```

### Using the Terraform Provider

1. Start by forking our [Kibana repository][kibana-scalingo]

2. Place the following block in your Terraform file to create the app:

   ```terraform
   resource "scalingo_app" "my-kibana" {
     name        = "my-kibana"
     force_https = true

     environment = {
       BUILDPACK_URL     = "https://github.com/Scalingo/kibana-buildpack"
       ELASTICSEARCH_URL = "<elasticsearch-db-url>"
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
     app                   = scalingo_app.my-kibana.id
     source                = "https://github.com/<username>/kibana-scalingo"
     branch                = "master"
   }
   ```

4. Run `terraform plan` and check if the result looks good

5. If so, run `terraform apply`

6. Once Terraform is done, your Kibana instance is provisioned and ready to
   be deployed. This requires an extra manual step:
   1. Head to your [dashboard]
   2. Click on your Kibana application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button
   6. After a few seconds, your Kibana instance is finally up and running!


## Configuring the Index Patterns

Once deployed and running, Kibana requires at least one index pattern to be
configured. This pattern allows Kibana to know which indices of Elasticsearch®
it has to watch.

1. From Kibana's home screen, select **Manage** in the upper right menu
2. Click on **Index Patterns** in the menu on the left side
3. Click the **Create index pattern** button
4. Fill the **Index pattern name** with the appropriate value\\
   If you are following our guides and examples, the value should be
   `unicorns-*`
5. Kibana does a quick check to validate the index is indeed existing.
6. If a time field exists for this index, Kibana suggests to use it. Chose
   whether it's appropriate or not for your case\\
   If you are following our guides and examples, select `@timestamp` in the
   dropdown
7. Click the **Create index pattern** button to validate


## Updating

By default, Scalingo deploys a version of Kibana that is compatible with the
Elasticsearch® instances we provide.

Consequently, updating Kibana consists in triggering a new deployment of your
instance.

{% note %}
- Scalingo provides a version of Kibana that is compatible with the latest
  Elasticsearch® `7.10.x` version. Our repository won't be updated as long as
  we are [stuck with this constraint][elk-constraint].
- However, you can use the dedicated [environment variable](#environment)
  to deploy a specific version of your choice. This may require some
  adjustments though.
{% endnote %}

### Using the Command Line

1. In your Kibana repository, create an empty commit and push it to Scalingo:

   ```bash
   git commit --allow-empty -m "Update Kibana"
   git push scalingo master
   ```

### Using the Terraform Provider

1. Head to your [dashboard]
2. Click on your Kibana application
3. Click on the **Deploy** tab
4. Click on **Manual deployment** in the left menu
5. Click the **Trigger deployment** button
6. After a few seconds, your updated Kibana instance is ready!


## Customizing

### Environment

The following environment variables can be leveraged to customize your
deployment:

- **`KIBANA_USER`**\\
  Username for Kibana authentication.

- **`KIBANA_PASSWORD`**\\
  Password for Kibana authentication.

- **`KIBANA_VERSION`**\\
  Version of Kibana to deploy.\
  Defaults to `7.10.2`

- **`ELASTICSEARCH_TLS_CA_URL`**\\
  URL of the CA certificate used to established a TLS connection with the
  Elasticsearch® database. Can be found on the database dashboard.\
  Mandatory if you enabled the force TLS option on your Elasticsearch®
  database.\\
  Defaults to not being set.

- **`ES_SSL_VERIFICATION_MODE`**\\
  If you're using a custom hostname not handled by the TLS certificate, please
  set this environment variable to `none`.\\
  Defaults to not being set.


[kibana-scalingo]: https://github.com/Scalingo/kibana-scalingo

[dashboard]: https://dashboard.scalingo.com/apps/
[one-click]: https://dashboard.scalingo.com/create/app?source=https://github.com/Scalingo/kibana-scalingo


[elk-constraint]: {% post_url platform/getting-started/getting-started-with-elk/2000-01-01-overview %}#planning-your-deployment
