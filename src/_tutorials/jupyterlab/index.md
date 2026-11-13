---
title: Deploying JupyterLab
logo: jupyterlab
category: analytics
products:
  - Scalingo for PostgreSQL®
permalink: /tutorials/jupyterlab
modified_at: 2026-11-13
last_reviewed_at: 2026-11-13
published: true
---

[JupyterLab][jupyter] is an open-source web application that allows to create
and share documents called *notebooks* that combine live code, equations,
visualizations, and narrative text. Users can run code step by step, inspect
outputs instantly, and modify their work dynamically. This makes it ideal for
learning, data analysis, or scientific computing.


## Planning your Deployment

- By default, JupyterLab stores notebooks on the local filesystem. Since
  [Scalingo's filesystem is ephemeral][filesystem], this is not an option. In
  this tutorial, the local filesystem is replaced with a [Scalingo for
  PostgreSQL®][db-postgresql] addon to persist the notebooks. We usually advise
  to start with a Scalingo for PostgreSQL® Starter 512 addon, and upgrade to a
  more powerful plan later if need be.

- To make JupyterLab store notebooks in the PostgreSQL® database, we use a
  Python module called [`pgcontents`][pgcontents]. This module is a
  PostgreSQL-backed implementation of [IPEP 27][ipep-27], and aims at providing
  a drop-in replacement for IPython's standard filesystem-backed storage
  system. Put in others words, `pgcontents` allows to replace all local
  filesystem storage operations with database-backed storage ones.

  Leveraging this ensures:
  - Notebooks survive application restarts.
  - Notebooks benefit from Scalingo's automated database backups.
  - No data loss due to Scalingo's ephemeral filesystem.

{% note %}
The [`pgcontents`][pgcontents] Python module is quite old, and hasn't received
any updates in years. Use it with caution, ideally after reviewing its code!
{% endnote %}

- Depending on several factors such as the size of your datasets, the
  complexity of your computations, and the number of notebooks you run at the
  same time, JupyterLab can consume a lot of RAM. We consequently advise to
  deploy an L container, and [change for a more powerful one][container-sizing]
  later if needed.

- JupyterLab supports two main authentication mechanisms to secure access to an
  instance:
  - Token authentication: Access is granted to anyone who possesses the valid
    authentication token.
  - Password authentication: Access is protected by a user-defined password,
    which JupyterLab stores as a hash in its local configuration file.

  Given that user-defined passwords are stored on the container's ephemeral
  storage, they woud not survive reboots, scaling, etc. As a consequence, we
  will use token-based authentication exclusively. Password authentication will
  be fully disabled for this demo.

  For more information about JupyterLab authentication mechanisms and security,
  please refer to [the official documentation][jupyter-security].

  {:#token}
  A cryptographically secure random token can be generated using the following
  command:
  ```bash
  openssl rand -hex 24
  ```

## Deploying

### Using the Command Line

1. Sparse-checkout the `scalingo-labs` repository, and extend it by downloading
   the directory containing the code for this demo:
   ```bash
   git clone --sparse https://github.com/Scalingo/scalingo-labs
   cd scalingo-labs
   git sparse-checkout set jupyterlab
   cd jupyterlab
   ```

2. Create a new git repository from the downloaded `jupyerlab` directory:
   ```bash
   git init
   git add .
   git commit --message "Initialize JupyterLab project"
   ```

3. Create the application on Scalingo:
   ```bash
   scalingo create my-jupyter
   ```

4. Provision a Scalingo for PostgreSQL® Starter 512 addon:
   ```bash
   scalingo --app my-jupyter addons-add postgresql postgresql-starter-512
   ```

5. (optional) Instruct the platform to run the `web` process type in a single
   L container:
   ```bash
   scalingo --app my-jupyter scale web:1:L
   ```

6. Set the [token](#token) that grants access to JupyterLab:
   ```bash
   scalingo --app my-jupyter env-set JUPYTER_TOKEN=<token>
   ```

7. Everything's ready, deploy to Scalingo:
   ```bash
   git push scalingo main
   ```

### Using the Terraform Provider

1. Start by creating a new repository in your SCM, using the files we provide
   in the [dedicated repository subdirectory][jupyter-scalingo].

2. Create the application:
   ```tf
   resource "scalingo_app" "my-jupyter" {
     name        = "my-jupyter"
     stack_id    = "scalingo-26"
     force_https = true

     environment = {
       JUPYTER_TOKEN="<token>"
     }
   }
   ```
   Set `token` to [a randomly generated token](#token).

3. Link the app to your repository:
   ```tf
   data "scalingo_scm_integration" "github" {
     scm_type = "github"
   }

   resource "scalingo_scm_repo_link" "default" {
     auth_integration_uuid = data.scalingo_scm_integration.github.id
     app                   = scalingo_app.my-jupyter.id
     source                = "https://github.com/<username>/jupyter-scalingo"
     branch                = "main"
   }
   ```

4. Provision a Scalingo for PostgreSQL® Starter 512 addon:
   ```tf
   resource "scalingo_addon" "my-jupyter-db" {
     app         = scalingo_app.my-jupyter.id
     provider_id = "postgresql"
     plan        = "postgresql-starter-512"
   }
   ```

5. (optional) Instruct the platform to run the `web` process type in a single L
   container:
   ```tf
   resource "scalingo_container_type" "web" {
     app    = scalingo_app.my-jupyter.id
     name   = "web"
     size   = "L"
     amount = 1
   }
   ```

6. Once Terraform is done, your JupyterLab instance is ready to be deployed:
   1. Head to your [dashboard]
   2. Click on your JupyterLab application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button
   6. After a few seconds, your JupyterLab is finally up and running!


## Updating

JupyterLab is a Python application, distributed via its own package called
[`jupyterlab`][jupyterlab-package]. Updating to a newer version mainly consists
in updating this package:

1. In your repository, ask `uv` to either update:

   - To the latest version available:
     ```bash
     uv sync --upgrade-package jupyterlab
     ```

   - To a specific version:
     ```bash
     uv add 'jupyterlab>=<NEW_VERSION>'
     ```

2. Commit the update:
   ```bash
   git add pyproject.toml uv.lock
   git commit --message="Upgrade JupyterLab to <NEW_VERSION>"
   ```

### Using the Command Line

1. Make sure you've successfully followed [the first steps](#updating)
2. Push the changes to Scalingo:
   ```bash
   git push scalingo main
   ```

### Using the Terraform Provider

1. Make sure you've successfully followed [the first steps](#updating)
2. Push the changes to your repository:
   ```bash
   git push origin main
   ```
3. Head to your [dashboard]
4. Click on your JupyterLab application
5. Click on the **Deploy** tab
6. Click on **Manual deployment** in the left menu
7. Click the **Trigger deployment** button
8. After a few seconds, your updated JupyterLab instance is ready!


## Customizing

While JupyterLab supports several environment variables to customize its
behavior, most of its configuration lies in different configuration files, such
as `jupyter_server_config.py`. These files are written in Python.

To generate a list of all available options, generate a configuration file from
a [one-off container][one-off], and inspect it:

1. After a first successful deployment, launch a one-off:
   ```shell
   scalingo --app my-jupyter run bash
   ```

2. From the one-off, generate the configuration file:
   ```shell
   jupyter lab --generate-config
   ```

### Environment

The deployment process uses the following environment variable:

* **`JUPYTER_TOKEN`**
  Allows to specify the token that protects the JupyterLab interface.\\
  Defaults to being unset, which falls back to JupyterLab generating a random
  token itself (not recommended).


[jupyter]: https://jupyter.org/
[pgcontents]: https://github.com/quantopian/pgcontents
[ipep-27]: https://github.com/ipython/ipython/wiki/IPEP-27:-Contents-Service
[jupyter-scalingo]: https://github.com/Scalingo/scalingo-labs/tree/main/jupyterlab
[jupyterlab-package]: https://pypi.org/project/jupyterlab/
[jupyter-security]: https://jupyter-server.readthedocs.io/en/stable/operators/security.html

[dashboard]: https://dashboard.scalingo.com/

[container-sizing]: {% post_url platform/app/scaling/2000-01-01-choosing-container-size %}
[filesystem]: {% post_url platform/app/2000-01-01-filesystem %}
[db-postgresql]: {% post_url databases/postgresql/shared-resources/getting-started/2000-01-01-provisioning %}
[one-off]: {% post_url platform/app/2000-01-01-tasks %}
