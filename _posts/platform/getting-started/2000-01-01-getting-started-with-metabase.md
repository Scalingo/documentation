---
title: Getting started with Metabase on Scalingo
modified_at: 2019-12-20 10:00:00
tags: tutorial metabase
index: 13
---

Metabase is an open source tool to query your company data without writing SQL
queries.

This tutorial will show you how to deploy a Metabase instance on Scalingo in
under 5 minutes.

## Metabase Deployment

We published a repository
[metabase-scalingo](https://github.com/Scalingo/metabase-scalingo) on GitHub to
help you deploy Metabase on Scalingo. Deploying a Metabase instance is now at a
click range:

[![Deploy](https://cdn.scalingo.com/deploy/button.svg)](https://my.scalingo.com/deploy?source=https://github.com/Scalingo/metabase-scalingo)

## Deployment by Cloning the Repository

You first need to create an application on Scalingo. Let's say its name is
`my-app`.

Then, clone our repository and add the Scalingo git remote:

```bash
$ git clone https://github.com/Scalingo/metabase-scalingo
$ cd metabase-scalingo
$ git remote add scalingo git@ssh.osc-fr1.scalingo.com:my-app.git
```

We now need to slightly configure the Scalingo application. First, this
application needs to use the [multi-buildpacks]({% post_url
platform/deployment/buildpacks/2000-01-01-multi %}). Add the `BUILDPACK_URL`
environment variable:

```bash
$ scalingo --app my-name env-set BUILDPACK_URL=https://github.com/Scalingo/multi-buildpack.git
```

You also need to add a PostgreSQL addon to your application. A "Starter 512"
plan would be enough.

Last, deploy your application with:

```bash
$ git push scalingo master
```

## Update the Metabase Instance

Metabase ships regularly new versions. In order to update, go to the application's dashboard, in the “Code” tab, and click “Deploy” on the `master` branch as the screenshot shows:

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_metabase_update.png" %}
{% include mdl_img.html %}

You can also use the CLI and run:

```bash
scalingo app --my-name integration-link-manual-deploy master
```
