---
title: Building a Recommendation Engine with pgvector
logo: postgresql
category: ai
products:
  - Scalingo for PostgreSQL®
permalink: /tutorials/pgvector-recommendation
modified_at: 2026-03-06
---

Recommendation systems are widely used in modern applications to suggest
relevant content to users. They are commonly powered by **vector embeddings**
and **similarity search**.

Instead of relying on a dedicated vector database, PostgreSQL® can perform
vector similarity search using the **pgvector** extension.

In this tutorial, we deploy a simple **movie recommendation system** using
PostgreSQL® with pgvector on Scalingo and a small Python API.

## Planning your Deployment

- In this tutorial, we choose to deploy both the backend and frontend of
  the application on a single `web` container of size M.

- Performing similarity search requires a vector-capable database. In this
  tutorial, we choose [Scalingo for PostgreSQL®
  addon][scalingo-postgres] with the **pgvector** extension enabled for this
  role.

- [The application][github-filmreco] is written in [Python][scalingo-python],
  using Flask, FastAPI and [LangChain][langchain] to query the embeddings.

The recommendation workflow follows these steps:

1. Generate embeddings for each movie description.
2. Store these embeddings in the Scalingo for PostgreSQL® database, using pgvector.
3. Generate embeddings for user queries.
4. Retrieve the most similar movies using vector similarity search.

## Deploying the Application

### Using the Command Line

1. Clone our repository:

   ```bash
   git clone https://github.com/Scalingo/filmreco
   cd filmreco
   ```

2. Create the application on Scalingo:

   ```bash
   scalingo create my-filmreco
   ```

   Notice that our Command Line automatically detects the git repository, and
   adds a git remote to Scalingo:

   ```bash
   git remote -v

   origin   https://github.com/Scalingo/filmreco (fetch)
   origin   https://github.com/Scalingo/filmreco (push)
   scalingo git@ssh.osc-fr1.scalingo.com:my-filmreco.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:my-filmreco.git (push)
   ```

3. Provision a Scalingo for PostgreSQL® Starter 512 addon:

   ```bash
   scalingo --app my-filmreco addons-add postgresql postgresql-starter-512
   ```

4. Everything's ready, deploy to Scalingo:

   ```bash
   git push scalingo main
   ```

  Scalingo detects the Python environment, installs dependencies and starts the application. Your recommendation API is deployed.

## Loading the Dataset

To populate the database with movies and embeddings, run the setup script as a one-off task:

   ```bash
   scalingo --app my-filmreco run python3 setup.py
   ```

The script enables the pgvector extension, creates the `movies` table and inserts the embeddings from the dataset to our database. The `DATABASE_URL` environment variable is automatically available in the one-off context.

For more information about running one-off tasks, refer to the [Scalingo documentation on tasks][scalingo-tasks].

## Querying the Recommendation Engine

Open your deployed application on Scalingo and enter a prompt to retrieve the most similar movie using pgvector similarity search.

You now have a working recommendation system built with Python, pgvector, and LangChain on Scalingo. With this setup, you can start experimenting with more advanced use cases such as product recommendations, document similarity search, or other semantic search applications.



[github-filmreco]: https://github.com/Scalingo/filmreco
[scalingo-postgres]: https://doc.scalingo.com/databases/postgresql/about/overview
[scalingo-python]: https://doc.scalingo.com/languages/python
[scalingo-tasks]: https://doc.scalingo.com/platform/app/tasks
[langchain]: https://www.langchain.com/langchain