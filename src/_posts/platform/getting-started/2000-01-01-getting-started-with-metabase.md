---
title: Getting Started With Metabase on Scalingo
modified_at: 2023-09-11 16:00:00
tags: tutorial metabase
index: 13
---

Metabase is an open source business intelligence tool that allows you to build
dashboards and data visualization from your company data, without writing SQL
queries.

This tutorial will show you how to deploy a Metabase instance on Scalingo in
under 5 minutes.

## Deploying Metabase

### Planning your Deployment

- Metabase requires its own database to store its configuration and some metadata.
  We usually advise to use a [PostgreSQL Starter/Business 512 addon](https://scalingo.com/databases/postgresql)
  for this purpose.

- Depending on several factors such as the amount of data stored in your
  production database, its load and the complexity of the Metabase queries you
  want to run, you may consider duplicating your production data to an
  additional database, dedicated for Metabase use. [Our documentation]({% post_url platform/databases/2000-01-01-duplicate %})
  should help you with this additional task.

### Using our One-Click Deploy Button

Click the One-Click Deploy button below to automatically deploy Metabase with
your Scalingo account:

[![Deploy](https://cdn.scalingo.com/deploy/button.svg)](https://dashboard.scalingo.com/deploy?source=https://github.com/Scalingo/metabase-scalingo)

### Using the Command Line

We published a repository
[metabase-scalingo](https://github.com/Scalingo/metabase-scalingo) on GitHub to
help you deploy Metabase on Scalingo. Here are the few steps you will need to
follow to deploy Metabase on Scalingo:

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
   scalingo --app my-app addons-add postgresql postgresql-starte-512
   ```

4. Everything's ready, deploy to Scalingo:

   ```bash
   git push scalingo master
   ```

## Updating Metabase

To update your Metabase application to the latest version, you need to redeploy
the latest version of the code source.

This can be done via our CLI tool, for example:

```bash
scalingo --app my-app deploy https://github.com/Scalingo/metabase-scalingo/archive/refs/heads/master.tar.gz
```
