---
title: OpenSearch® Dashboards
nav: OpenSearch® Dashboards
modified_at: 2025-05-19 12:00:00
tags: opensearch logs dashboards
index: 40
---


OpenSearch® Dashboards is a visualization and user interface tool for
OpenSearch®, mostly derived from Elastic's Kibana. It provides users with an
intuitive and interactive interface to analyze, visualize, search, and monitor
large datasets stored in the database indexes. It also supports the creation of
custom dashboards, charts, graphs, and tables that can reflect real-time
updates from data sources indexed by OpenSearch®.

In a logging stack, OpenSearch® Dashboards acts a visualization solution. Its
role is to give an efficient access to the data stored in the database indexes.

{% assign img_url = "https://cdn.scalingo.com/documentation/diagram_documentation_opensearch_dashboards.png" %}
{% include mdl_img.html %}


## Deploying

### Using the Command Line

We maintain a [buildpack][opensearch-dashboards-buildpack] on GitHub to help
you deploy OpenSearch® Dashboards on Scalingo. Here are the few steps to
follow:


1. Clone our repository:
   ```bash
   git clone https://github.com/Scalingo/opensearch-dashboards-scalingo
   cd opensearch-dashboards-scalingo
   ```

2. Create the application on Scalingo:
   ```bash
   scalingo create my-osd
   ```

3. Instruct the platform to use the appropriate buildpack:
   ```bash
   scalingo --app my-osd env-set BUILDPACK_URL="https://github.com/Scalingo/opensearch-dashboards-buildpack"
   ```

4. Set the `OPENSEARCH_URL` environment variable to the URL of the OpenSearch®
   database you want to use:
   ```bash
   scalingo --app my-osd env-set OPENSEARCH_URL="<opensearch_url>"
   ```

5. (optional) Scale the container to an L size:
   ```bash
   scalingo --app my-osd scale web:1:L
   ```

6. Everything's ready, deploy to Scalingo:
   ```bash
   git push scalingo master
   ```

### Using the Terraform Provider

{% note%}
The following code blocks are given as examples.\
You will have to adjust some values to suit your needs.
{% endnote %}

1. Start by forking our [OpenSearch® Dashboards
   repository][opensearch-dashboards-scalingo]

2. Place the following block in your Terraform file to create the app:
   ```tf
   resource "scalingo_app" "my-osd" {
     name        = "my-osd"
     force_https = true

     environment = {
       BUILDPACK_URL  = "https://github.com/Scalingo/opensearch-dashboards-buildpack"
       OPENSEARCH_URL = "<opensearch_url>"
     }
   }
   ```

3. Link the app to your forked repository:

   ```tf
   data "scalingo_scm_integration" "github" {
     scm_type = "github"
   }

   resource "scalingo_scm_repo_link" "default" {
     auth_integration_uuid = data.scalingo_scm_integration.github.id
     app                   = scalingo_app.my-osd.id
     source                = "https://github.com/<username>/opensearch-dashboards-scalingo"
     branch                = "master"
   }
   ```

4. (optional) Instruct the platform to run the `web` process type in a single
   L container:

   ```tf
   resource "scalingo_container_type" "web" {
     app    = scalingo_app.my-osd.id
     name   = "web"
     size   = "L"
     amount = 1
   }
   ```

5. Once Terraform is done, your OpenSearch® Dashboards instance is provisioned
   and ready to be deployed. The deployment itself requires an extra manual
   step:

   1. Head to [your dashboard][dashboard]
   2. Click on your OpenSearch® Dashboards application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button
   6. After a few seconds, your OpenSearch® Dashboards instance is finally up
      and running!


## Updating

By default, Scalingo deploys a version of OpenSearch® Dashboards that is
compatible with the OpenSearch® instances we provide.

Consequently, updating OpenSearch® Dashboards consists in triggering a new
deployment of your instance.

### Using the Command Line

1. In your OpenSearch® Dashboards repository, create an empty commit and push it
   to Scalingo:

   ```bash
   git commit --allow-empty --message="Update OpenSearch® Dashboards"
   git push scalingo master
   ```

### Using the Terraform Provider

1. Head to [your dashboard][dashboard]
2. Click on your OpenSearch® Dashboards application
3. Click on the **Deploy** tab
4. Click on **Manual deployment** in the left menu
5. Click the **Trigger deployment** button
6. After a few seconds, your updated OpenSearch® Dashboards instance is ready!


## Customizing

### Environment

The following environment variable(s) can be leveraged to customize your
deployment:

- **`OPENSEARCH_DASHBOARDS_VERSION`**\
  Version of OpenSearch Dashboards to deploy.\
  Defaults to `2.19.1`


[dashboard]: https://dashboard.scalingo.com/apps/
[opensearch-dashboards-buildpack]: https://github.com/Scalingo/opensearch-dashboards-buildpack
[opensearch-dashboards-scalingo]: https://github.com/Scalingo/opensearch-dashboards-scalingo
