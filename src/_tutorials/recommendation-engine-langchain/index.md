---
title: Deploy a Recommendation Engine with PostgreSQL and pgvector
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
vector similarity search using the **pgvector extension**.

In this tutorial, we will deploy a simple **movie recommendation system** using
PostgreSQL® with pgvector on Scalingo and a small Python API.

## Planning your Deployment

Before deploying your recommendation engine, you need the following components:

- A **Scalingo for PostgreSQL® addon** to store embeddings and perform
  similarity searches. You can find the documentation [here][scalingo-postgres].

- A **Python application** that generates embeddings and exposes a
  recommendation API (FastAPI in this tutorial).

- A **dataset of movies** containing titles and descriptions.

- An **embedding model** to convert text into vector representations.

The full example application used in this tutorial is available on GitHub: 
[filmreco-scalingo][github-filmreco]

The recommendation workflow follow these steps:

1. Generate embeddings for each movie description.
2. Store these embeddings in PostgreSQL® using pgvector.
3. Generate embeddings for user queries.
4. Retrieve the most similar movies using vector similarity search.

## Deploying the API

### Using the Command Line

1. Clone our repository:

   ```bash
   git clone https://github.com/Scalingo/filmreco-scalingo
   cd filmreco-scalingo
   ```

2. Create the application on Scalingo:

   ```bash
   scalingo create my-filmreco
   ```

   Notice that our Command Line automatically detects the git repository, and
   adds a git remote to Scalingo:

   ```bash
   git remote -v

   origin   https://github.com/Scalingo/filmreco-scalingo (fetch)
   origin   https://github.com/Scalingo/filmreco-scalingo (push)
   scalingo git@ssh.osc-fr1.scalingo.com:my-filmreco.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:my-filmreco.git (push)
   ```

3. Provision a Scalingo for PostgreSQL® Starter 512 addon:

   ```bash
   scalingo --app my-n8n addons-add postgresql postgresql-starter-512
   ```

4. Everything's ready, deploy to Scalingo:

   ```bash
   git push scalingo main
   ```

  Scalingo detects the Python environment, installs dependencies and start the application. Your recommendation API is now deployed.

## Loading the Dataset

To populate the database with movies and embeddings, open a secure database tunnel:

   ```bash
   scalingo --app my-filmreco db-tunnel
   ```
Export the url to the env **DATABASE_URL** Then run the setup script included in the repository:

   ```bash
   pipenv run python3 setup.py
   ```

The script enables the pgvector extension, creates the `movies` table and insert the embeddings from the dataset to our database.

## Querying the Recommendation Engine

You can now open your application deployed on Scalingo and enter a prompt to retrieve the most similar movie using pgvector similarity search.

You now have a basic recommendation system running on Scalingo using Python, pgvector, and LangChain. You can build on this project to implement product recommendations, document similarity search, and more.



[github-filmreco]: https://github.com/Scalingo/filmreco-scalingo
[scalingo-postgres]: https://doc.scalingo.com/databases/postgresql/about/overview