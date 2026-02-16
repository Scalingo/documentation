---
title: Getting Started with Jupyter Notebook on Scalingo
modified_at: 2026-02-10 12:00:00
tags: tutorial jupyter notebook 
index: 14
---

Jupyter Notebook is an open-source web application that allows to create
and share documents called *notebooks* that combine live code, equations,
visualizations, and narrative text. Users can run code step by step, inspect
outputs instantly, and modify their work dynamically. This makes it ideal for
learning, data analysis, or scientific computing.

## Planning your Deployment

- By default, Jupyter Notebook stores notebooks on the local filesystem. Since
  Scalingo's filesystem is ephemeral, we will replace the local filesystem
  with a [Scalingo for PostgreSQL®][db-postgresql] addon to persist the
  notebooks. We usually advise to start with a Scalingo for PostgreSQL® Starter
  512 addon, and upgrade to a more powerful plan later if need be.

- To make Jupyter Notebook store notebooks in the PostgreSQL® database, we will
  use [`pgcontents`][pgcontents], a Postgres-backed storage system for Jupyter.

  This means:
  - Notebooks survive application restarts.
  - Notebooks benefit from Scalingo's automated database backups.
  - No data loss due to Scalingo's ephemeral filesystem.

- Depending on several factors such as the size of your datasets, the complexity
  of your computations, and the number of notebooks you run at the same time,
  Jupyter Notebook can consume a lot of RAM.

## Deploying

### Using the Command Line

We maintain a repository called [jupyter-scalingo][jupyter-scalingo]
on GitHub to help you deploy Jupyter Notebook on Scalingo. Here are the few
additional steps you will need to follow:

1. Clone our repository:
   ```bash
   git clone https://github.com/Scalingo/jupyter-scalingo
   cd jupyter-notebook-persistence
   ```

2. Create the application on Scalingo:
   ```bash
   scalingo create my-jupyter
   ```

   Notice that our Command Line automatically detects the git repository, and
   adds a git remote to Scalingo:
   ```bash
   git remote -v

   origin   https://github.com/Scalingo/jupyter-scalingo (fetch)
   origin   https://github.com/Scalingo/jupyter-scalingo (push)
   scalingo git@ssh.osc-fr1.scalingo.com:my-jupyter.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:my-jupyter.git (push)
   ```

3. Provision a Scalingo for PostgreSQL® Starter 512 addon:
   ```bash
   scalingo --app my-jupyter addons-add postgresql postgresql-starter-512
   ```

4. (optional) Instruct the platform to run the `web` process type in a single
   L container:

   ```bash
   scalingo --app my-jupyter scale web:1:L
   ```

5. Set a **mandatory** environment variables:

   Set the password to access Jupyter Notebook:

   ```bash
   scalingo --app my-jupyter env-set JUPYTER_NOTEBOOK_PASSWORD=<YOUR_SECURE_PASSWORD>
   ```

6. Everything's ready, deploy to Scalingo:

   ```bash
   git push scalingo main
   ```

## Updating

Jupyter Notebook is a Python application, distributed via its own package
called `jupyter`. Updating to a newer version mainly consists in updating your
requirements in the `requirements.txt` file of your Jupyter repository.

1. In your Jupyter repository, update the `requirements.txt` file with the
   desired version:
   ```
   jupyter==<NEW_VERSION>
   ```

2. Commit the update:
   ```bash
   git add requirements.txt
   git commit -m "Upgrade to Jupyter <NEW_VERSION>"
   ```

### Using the Command Line

* Make sure you've successfully followed the first steps
* Push the changes to Scalingo:

  ```bash
  git push scalingo main
  ```

## Customizing

### Environment

Jupyter Notebook supports several environment variables to customize its
behavior.

Moreover, the deployment makes use of the following environment variable(s).
They can be leveraged to customize your deployment:

* **`SCALINGO_UID`**
  This variable sets the UID for your Scalingo PostgreSQL® account.

* **`JUPYTER_NOTEBOOK_PASSWORD`**
  Sets the password to access the Jupyter Notebook interface.
  Jupyter Notebook will start if this variable is not set; you will then have to
  enter your token.

* **`JUPYTER_TOKEN`** (mandatory)
  Sets the token to access the Jupyter Notebook interface.
  Jupyter Notebook will not start if this variable is not set.

### Installing Additional Python Packages

To install additional Python packages, add them to the `requirements.txt` file
at the root of your repository:

```
jupyter
numpy
pandas
matplotlib
scikit-learn
```

Then, commit and push your changes to trigger a new deployment.

### Using an Object Storage

If you want to store large files or share notebooks across multiple projects, it
is **possible** to use an external S3-compatible object storage, such as
Outscale Object Storage.

{% note %}
By default, JupyterLab uses **pgcontents** with PostgreSQL® to persist notebooks.
Using S3 storage is **entirely optional**. PostgreSQL® is sufficient for most use
cases on Scalingo.
{% endnote %}

For reference and further details about using S3 storage with JupyterLab, you
can check out the [S3ContentsManager documentation][jupyter-s3].

[jupyter-scalingo]: https://github.com/Scalingo/jupyter-scalingo
[pgcontents]: https://github.com/quantopian/pgcontents
[jupyter-s3]: https://github.com/cloudbutton/s3contents
[db-postgresql]: {% post_url databases/postgresql/getting-started/2000-01-01-provisioning %}

