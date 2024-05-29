---
title: Getting Started with Grafana on Scalingo
modified_at: 2019-12-20 10:00:00
tags: tutorial grafana metrics
index: 12
---

Grafana is an open source monitoring and visualization solution. It gives you
the ability to produce dashboards about your application metrics.

This tutorial will show you how to deploy a Grafana instance on Scalingo in
under 5 minutes.

## Deploying Grafana

### Planning your Deployment

- web 1L

- Grafana requires its own database to store its configuration. We usually
  advise to opt for a [PostgreSQL Starter/Business 512 addon](https://scalingo.com/databases/postgresql)
  for this purpose.

- Grafana doesn't is divided into a front end written in TypeScript and a back end
  written in Go. Consequently, you will need to use a [multi-buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-multi %})
  to build it on Scalingo.

### Using our One-Click Deploy Button

Click the One-Click Deploy button below to automatically deploy Grafana with
your Scalingo account:

[![Deploy](https://cdn.scalingo.com/deploy/button.svg)](https://dashboard.scalingo.com/deploy?source=https://github.com/Scalingo/grafana-scalingo)

### Using the Command Line

We maintain a repository called [grafana-scalingo](https://github.com/Scalingo/grafana-scalingo)
on GitHub to help you deploy Grafana on Scalingo. Here are the few steps you
will need to follow:

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

3. Scale the web container:

   ```bash
   scalingo --app my-grafana scale web:1:L
   ```

4. Create the database:

   ```bash
   scalingo --app my-grafana addons-add postgresql postgresql-starter-512
   ```

5. Set a few **mandatory** environment variables, from the command line, for
   example:

   ```bash
   scalingo --app my-grafana env-set BUILDPACK_URL=https://github.com/Scalingo/multi-buildpack
   scalingo --app my-grafana env-set NPM_CONFIG_PRODUCTION=false
   scalingo --app my-grafana env-set PLATFORM_ENV=production
   scalingo --app my-grafana env-set GF_DATABASE_URL=$SCALINGO_POSTGRESQL_URL
   scalingo --app my-grafana env-set GF_SERVER_HTTP_PORT=$PORT
   scalingo --app my-grafana env-set GF_PATH_PLUGINS=/app/plugins
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


## Updating Grafana

### Sticking With Scalingo Grafana Distribution

By default, Scalingo tries to install the latest version of Grafana **that we
have successfully tested and integrated**. We tag these versions with a
`-scalingo<n>` suffix (e.g. `v9.3.2-scalingo1`).

Consequently, to update Grafana, issue the following commands in your project
directory:

1. Make sure you are in the appropriate branch:

   ```bash
   git checkout <my_branch>
   ```

2. Fetch the available tags:

   ```bash
   git fetch --tags origin
   ```

3. Merge the tag in your branch:

   ```bash
   git merge tags/<tag_name>
   ```

4. Finally, deploy this new version:

   ```bash
   git push scalingo <my_branch>:master
   ```

### 

If you want to use a version that we haven't packaged yet, the procedure is
mostly:

1. In your repository, create an `upstream` repository, and retrieve the tags:

   ```w
   git remote add upstream https://github.com/grafana/grafana
   git fetch --tags upstream
   ```

2. Switch to a new branch:

   ```bash
   git checkout -b <my_branch>
   ```

3. Merge the tag you are interested in with your branch:

   ```bash
   git merge tags/<tag_name>
   ```

4. Fix the merge conflicts...

5. Finally, deploy your new version:

   ```bash
   git push scalingo <my_branch>:master
   ```


## Customizing your Deployment

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

[Grafana is fully configurable via environment variables](https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#override-configuration-with-environment-variables).
