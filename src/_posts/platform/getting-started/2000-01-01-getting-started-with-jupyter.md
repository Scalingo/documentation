---
title: Getting Started with Jupyter Notebook on Scalingo
modified_at: 2026-02-10 12:00:00
tags: tutorial jupyter notebook 
index: 14
---


Jupyter Notebook is an open-source web application that allows to create
and share documents called *notebooks* that combine live code, equations, visualizations, and narrative text. Users can run code step by step, inspect outputs instantly, and modify their work dynamically. This makes it ideal for learning, data analysis, or scientific computing.


## Planning your Deployment

By default, Jupyter Notebook stores notebooks on the local filesystem. Since
Scalingo's filesystem is ephemeral, you'll have to provision a
[Scalingo for PostgreSQL®][db-postgresql] addon to persist your notebooks. We
usually advise to start with a Scalingo for PostgreSQL® Starter 512 addon, and
upgrade to a more powerful plan later if need be.


Depending on several factors such as the size of your datasets, the complexity
of your computations, and the number of notebooks you run at the same time,
Jupyter Notebook can consume a lot of RAM.


## Deploying

### Using the Command Line


We maintain a repository called [jupyter-notebook-persistence][jupyter-notebook-persistence]
on GitHub to help you deploy Jupyter Notebook on Scalingo. Here are the few
additional steps you will need to follow:


1. Clone our repository:
   ```bash
   git clone https://github.com/Amyti/jupyter-notebook-persistence
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


- Make sure you've successfully followed the first steps
- Push the changes to Scalingo:
  ```bash
  git push scalingo main
  ```


## Customizing


### Environment


Jupyter Notebook supports several environment variables to customize its
behavior.

Moreover, the deployment makes use of the following environment variable(s).
They can be leveraged to customize your deployment:

- **`SCALINGO_UID`**\\
  This variable will set your UID for your scalingo postgresql account.

- **`JUPYTER_NOTEBOOK_PASSWORD`** \\
  Sets the password to access the Jupyter Notebook interface.
  Jupyter Notebook will start if this variable is not set, you just have to enter your token.

- **`JUPYTER_TOKEN`**(mandatory)\\
  Sets the token to access the Jupyter Notebook interface.\\
  Jupyter Notebook will not start if this variable is not set.

- **`DATABASE_URL`** (automatically set)\\
  This variable is automatically set when you provision a Scalingo for
  PostgreSQL® addon. It is used to store notebooks persistently in the
  database.


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

If you want to store large files or share notebooks across multiple projects, it is **possible** to use an external S3-compatible object storage, such as Outscale Object Storage.

{% note %}
By default, JupyterLab uses **pgcontents** with PostgreSQL® to persist notebooks.\\
Using S3 storage is **entirely optional**. PostgreSQL® is sufficient for most use cases on Scalingo.
{% endnote %}

For reference and further details about using S3 storage with JupyterLab, you can check out the [S3ContentsManager documentation](https://github.com/cloudbutton/s3contents).




## Persistent Storage


By default, notebooks are stored in a PostgreSQL database to ensure persistence
across container restarts and redeployments. This is achieved using
[pgcontents][pgcontents], a Postgres-backed storage system for Jupyter.

This means:

- Notebooks survive application restarts
- Notebooks benefit from Scalingo's automated database backups
- No data loss due to Scalingo's ephemeral filesystem



[jupyter-notebook-persistence]: https://github.com/Amyti/jupyter-notebook-persistence
[pgcontents]: https://github.com/quantopian/pgcontents
[db-postgresql]: https://doc.scalingo.com/databases/postgresql/getting-started/provisioning
[dashboard]: https://dashboard.scalingo.com/apps/
