---
title: Using Solid Queue to Handle Background Tasks
nav: Solid Queue
modified_at: 2025-12-30 00:00:00
tags: ruby rails async jobs solid-queue
---

## What is Solid Queue?

[Solid Queue](https://github.com/rails/solid_queue) is the default background job processing library for Rails 8. It uses your database (PostgreSQL®, MySQL®, or SQLite) to manage the job queue, eliminating the need for a separate Redis® OSS instance for many use cases.

## Configuration for Rails 8

When using Solid Queue on Scalingo, you need to ensure that your database configuration in `config/database.yml` correctly references the `DATABASE_URL` environment variable for both the primary database and the queue database.

By default, Rails 8 might expect a separate database for the queue, but on Scalingo, you typically use the same database for both.

Update your `config/database.yml`:

```yaml
production:
  primary: &default
    adapter: postgresql # or mysql2 (the adapter name for MySQL)
    encoding: unicode
    url: <%= ENV['DATABASE_URL'] %>
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

  queue:
    <<: *default
    url: <%= ENV['DATABASE_URL'] %>
```

## Adding "worker" container type in your Procfile

To process background jobs, you need to run the Solid Queue worker process. Add the following line to your [`Procfile`]({% post_url platform/app/2000-01-01-procfile %}):

```yaml
worker: bin/jobs
```

{% note %}
- `bin/jobs` is the recommended method for Solid Queue 1.0+ (created by `rails generate solid_queue:install`)
- You can also use `bundle exec rake solid_queue:start`
{% endnote %}

## Deployment

After updating your `config/database.yml` and `Procfile`, deploy your application:

```bash
git add config/database.yml Procfile
git commit -m "Configure Solid Queue for Scalingo"
git push scalingo master
```

{% note %}
Solid Queue requires a migration to create the necessary tables in your database. These migrations are typically added when you install Solid Queue or when you create a new Rails 8 application. Make sure they are executed using a [post-deployment hook]({% post_url platform/app/2000-01-01-postdeploy-hook %}).
{% endnote %}

Once deployed, you need to scale the `worker` container to at least 1 to start processing jobs:

```bash
scalingo --app my-app scale worker:1
```
