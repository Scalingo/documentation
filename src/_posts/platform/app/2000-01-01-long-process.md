---
layout: page
title: Long Running Process
modified_at: 2026-01-02 12:00:00
---

## Problematic

On Scalingo, HTTP requests to your application need to be processed in [less than 30 seconds]({% post_url platform/networking/public/2000-01-01-routing %}#timeouts). More generally, this is a best practice for a HTTP request to be as short as possible. You may wonder what you need to do in case your application has a long process to execute in reaction to a user interaction. This page aims at explaining how you could achieve this in your application.

## The HTTP Status 202

Whenever your application needs to execute a long running process (more than a few seconds), it should
- Create a resource in your application database with a status such as `queued`.
- Publish a message on a message queue.
- Return a HTTP status code `202 Accepted` to the client. This status code means that the request has been accepted and will be processed asynchronously.

Asynchronously, a worker should handle the processing of the resource created in the database and update its status, from `processing` to `processed`. The client could poll the status of this resource at regular interval to determine when the process is over.

There is various message queue system depending on the programming language and the framework your application uses:

- Ruby: [Solid Queue]({% post_url languages/ruby/2000-01-01-solid-queue %}), [Delayed Job]({% post_url languages/ruby/2000-01-01-delayed-job %}), [Sidekiq]({% post_url languages/ruby/2000-01-01-sidekiq %}) or [Resque](https://github.com/resque/resque).
- PHP: [Symfony Messenger]({% post_url languages/php/2000-01-01-symfony %}#symfony-messenger) or [Laravel Tasks Scheduler]({% post_url languages/php/2000-01-01-laravel %})
- Node.js: [Bull](https://github.com/OptimalBits/bull).
- Python: [Celery]({% post_url languages/python/2000-01-01-celery-flask %}).
