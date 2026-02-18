---
title: Deploying n8n
logo: n8n
category: automation
products:
  - Scalingo for PostgreSQL®
modified_at: 2025-08-12
---

n8n is an open-source workflow automation tool that lets you connect apps,
APIs, and databases without heavy coding. It works like a visual editor where
you drag, drop, and link *nodes* to create automated workflows. It supports
both scheduled and event-driven automations.\\
n8n can interact with more than 200 services, and allows to run custom scripts
or API calls when necessary, making it a great solution for data syncing,
process automation, or no-code integrations.


## Planning your Deployment

- By default, n8n uses SQLite to save credentials, past executions, and
  workflows. Since [using SQLite on Scalingo is not an option][sqlite], you'll
  have to provision a Scalingo for PostgreSQL® addon. We usually advise to
  start with a [Scalingo for PostgreSQL® Starter or Business 512
  addon][db-postgresql], and change for a more powerful plan later if need be.

- Depending on several factors such as the amount of data processed by your n8n
  workflows, the way your workflows are built, and the number of workflows you
  run at the same time, n8n can consume a lot of RAM. We usually advise to
  start with an XL container, and change for a more or less powerful plan
  later, depending on your usage.

- The Enterprise edition of n8n provides some interesting features, such as
  custom variables, external secrets, Single Sign-On, version control with Git,
  or muti-main mode. Depending on your use case, purchasing an Enterprise
  license might really worth it. See [full comparison][n8n-editions] for more
  details.

### Deployment Example

At Scalingo we are using n8n everyday to run tedious tasks. These tasks handle
quite a lot of data, and save us a lot of time. Since we rely on it for our
business, we also want to have a resilient and effective solution.

Our current setup is as follow:

- We are running an Enterprise edition, so we can benefit from all the nice
  features.
- We are running in [queue mode], with a [multi-main] setup, which allows us to
  [scale-out] when needed, and have better performances.
- 2 x 2XL containers for the `web` process type
- 2 x 2XL containers for the `worker` process type, which handle our queues
- 1 x Scalingo for PostgreSQL® Business 2G addon
- 1 x Scalingo for Caching Business 1G addon


## Deploying

### Using the Command Line

We maintain a repository called [n8n-scalingo] on GitHub to help you deploy n8n
on Scalingo. Here are the few additional steps you will need to follow:

1. Clone our repository:

   ```bash
   git clone https://github.com/Scalingo/n8n-scalingo
   cd n8n-scalingo
   ```

2. Create the application on Scalingo:

   ```bash
   scalingo create my-n8n
   ```

   Notice that our Command Line automatically detects the git repository, and
   adds a git remote to Scalingo:

   ```bash
   git remote -v

   origin   https://github.com/Scalingo/n8n-scalingo (fetch)
   origin   https://github.com/Scalingo/n8n-scalingo (push)
   scalingo git@ssh.osc-fr1.scalingo.com:my-n8n.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:my-n8n.git (push)
   ```

3. Provision a Scalingo for PostgreSQL® Starter 512 addon:

   ```bash
   scalingo --app my-n8n addons-add postgresql postgresql-starter-512
   ```

4. (optional) Instruct the platform to run the `web` process type in a single
   XL container:

   ```bash
   scalingo --app my-n8n scale web:1:XL
   ```

5. Set a few **mandatory** environment variables:\\
   These must be set with the given values:

   ```bash
   scalingo --app my-n8n env-set N8N_PORT=\$PORT
   scalingo --app my-n8n env-set N8N_PROTOCOL=https
   scalingo --app my-n8n env-set DB_TYPE=postgresdb
   ```

   **When running in queue mode**, the following one must be set:

   ```bash
   scalingo --app my-n8n env-set N8N_ENCRYPTION_KEY=<SOME RANDOM STRING>
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

1. Start by forking our [n8n repository][n8n-scalingo]

2. Place the following block in your Terraform file to create the app:

   ```terraform
   resource "scalingo_app" "my-n8n" {
     name        = "my-n8n"
     stack_id    = "scalingo-22"
     force_https = true

     environment = {
       N8N_PROTOCOL       = "https",
       N8N_PORT           = "$PORT",
       DB_TYPE            = "postgresdb",
       N8N_ENCRYPTION_KEY = "<SOME RANDOM STRING>"
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
     app                   = scalingo_app.my-n8n.id
     source                = "https://github.com/<username>/n8n-scalingo"
     branch                = "master"
   }
   ```

4. Provision a Scalingo for PostgreSQL® Starter 512 addon and attach it to your
   app:

   ```terraform
   resource "scalingo_addon" "my-n8n-postgresql" {
     app         = scalingo_app.my-n8n.id
     provider_id = "postgresql"
     plan        = "postgresql-starter-512"
   }
   ```

5. (optional) Instruct the platform to run the `web` process type in a single
   XL container:

   ```terraform
   resource "scalingo_container_type" "web" {
     app    = scalingo_app.my-n8n.id
     name   = "web"
     size   = "XL"
     amount = 1
   }
   ```

6. Run `terraform plan` and check if the result looks good

7. If so, run `terraform apply`

8. Once Terraform is done, your n8n instance is ready to be deployed:
   1. Head to your [dashboard]
   2. Click on your n8n application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button
   6. After a few seconds, your n8n instance is finally up and running!


## Updating

n8n is a Node.js application, distributed via its own package called `n8n`.
Updating to a newer version mainly consists in updating your requirements in
the `package.json` file of your n8n repository.

1. In your n8n repository, ask `npm` to bump the n8n package version:\\
   To update to the `latest` version:

   ```bash
   npm install n8n --package-lock-only
   ```

   To update to the `next` version:

   ```bash
   npm install n8n@next --package-lock-only
   ```

   To update to a specific version:

   ```bash
   npm install n8n@<version> --package-lock-only
   ```

2. Commit the update:

   ```bash
   git add package.json
   git add package-lock.json
   git commit -m "Upgrade to ..."
   ```

### Using the Command Line

1. Make sure you've successfully followed [the first steps](#updating)
2. Push the changes to Scalingo:
   ```bash
   git push scalingo master
   ```

### Using the Terraform Provider

1. Make sure you've successfully followed [the first steps](#updating)
2. Push the changes to your repository:

   ```bash
   git push origin master
   ```

3. Head to your [dashboard]
4. Click on your n8n application
5. Click on the **Deploy** tab
6. Click on **Manual deployment** in the left menu
7. Click the **Trigger deployment** button
8. After a few seconds, your updated n8n instance is ready!


## Customizing

### Environment

[n8n supports a lot of environment variables][n8n-env].


[n8n-editions]: https://docs.n8n.io/hosting/community-edition-features/
[n8n-env]: https://docs.n8n.io/hosting/configuration/environment-variables/
[queue mode]: https://docs.n8n.io/hosting/scaling/queue-mode/
[multi-main]: https://docs.n8n.io/hosting/scaling/queue-mode/#multi-main-setup

[n8n-scalingo]: https://github.com/Scalingo/n8n-scalingo

[db-postgresql]: https://www.scalingo.com/databases/postgresql
[dashboard]: https://dashboard.scalingo.com/apps/
[one-click]: https://dashboard.scalingo.com/create/app?source=https://github.com/Scalingo/n8n-scalingo

[sqlite]: {% post_url databases/2000-01-01-sqlite %}
[scale-out]: {% post_url platform/app/scaling/2000-01-01-scaling %}
