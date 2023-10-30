---
title: Getting Started With Metabase on Scalingo
modified_at: 2023-11-13 16:00:00
tags: tutorial metabase
index: 13
---

Metabase is an open source Business Intelligence tool that allows you to build
dashboards and data visualization from your company data, without writing SQL
queries.

This tutorial will show you how to deploy a Metabase instance on Scalingo in
under 5 minutes.

## Deploying Metabase

### Planning your Deployment

- Metabase requires its own database to store its configuration and some
  metadata. We usually advise to use a [PostgreSQL Starter/Business 512 addon](https://scalingo.com/databases/postgresql)
  for this purpose.

- Depending on several factors such as the amount of data stored in your
  production database, its load, and the complexity of the Metabase queries you
  want to run, you may consider duplicating your production data to an
  additional database dedicated for Metabase use. Doing so would prevent
  Metabase to have a negative impact on your application's performances.
  [Our documentation]({% post_url platform/databases/2000-01-01-duplicate %})
  should help you with this additional task.

### Using our One-Click Deploy Button

Click the One-Click Deploy button below to automatically deploy Metabase with
your Scalingo account:

[![Deploy](https://cdn.scalingo.com/deploy/button.svg)](https://dashboard.scalingo.com/deploy?source=https://github.com/Scalingo/metabase-scalingo)

### Using the Command Line

We maintain a repository called [metabase-scalingo](https://github.com/Scalingo/metabase-scalingo)
on GitHub to help you deploy Metabase on Scalingo. Here are the few steps you
will need to follow:

1. Clone our repository:

   ```bash
   git clone https://github.com/Scalingo/metabase-scalingo
   cd metabase-scalingo
   ```

2. Create the application on Scalingo (to keep things simple in this tutorial,
   we will call it `my-app`):

   ```bash
   scalingo create my-app
   ```

   Notice that our Command Line automatically detects the git repository, and
   adds a git remote to Scalingo:

   ```bash
   git remote -v

   origin   https://github.com/Scalingo/metabase-scalingo (fetch)
   origin   https://github.com/Scalingo/metabase-scalingo (push)
   scalingo git@ssh.osc-fr1.scalingo.com:my-app.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:my-app.git (push)
   ```

3. Create the database:

   ```bash
   scalingo --app my-app addons-add postgresql postgresql-starter-512
   ```

4. Everything's ready, deploy to Scalingo:

   ```bash
   git push scalingo master
   ```


## Updating Metabase

By default, Scalingo tries to install the latest version of Metabase.

Consequently, updating Metabase only consists in triggering a new deployment of
your instance. To do so, create an empty commit and push it to Scalingo:

```bash
git commit --allow-empty -m "Update Metabase"
git push scalingo master
```

{% note %}
Scalingo tries to retrieve the latest version number by querying the GitHub
API, which is subject to API rate-limits. If the deployment fails, a simple
workaround consists in specifying the Metabase version you want ot deploy
([see below](#deploying-a-specific-version)).
{% endnote %}


## Customizing your Deployment

### Environment

[Metabase supports many environment variables](https://www.metabase.com/docs/latest/operations-guide/environment-variables.html).

Moreover, the buildpack makes use of the following environment variable(s).
They can be leveraged to customize your deployment:

- **`METABASE_VERSION`**\
  Allows to specify the version of Metabase to deploy.\
  Make sure to prefix the number with the letter **v**.\
  Defaults to `*`.
