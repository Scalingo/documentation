---
title: Run Scheduled Tasks
nav: Cron Tasks
modified_at: 2021-09-07 00:00:00
tags: app
index: 15
---

{% warning %} 
This feature is currently available only in private beta. Ask the support to be added to the waitlist. 
{% endwarning %}

Your application may need to execute some tasks at regular interval. The cron feature is here to help you run scheduled tasks based on [one-off containers]({% post_url platform/app/2000-01-01-tasks %}).

Instead of running 24/7 a container to execute a task from time-to-time, the cron feature lets you start one-off containers only when you need.

## Configuring Cron Tasks on Your Application

Configure cron tasks on your application by adding a `cron.json` file at the root of your application. The file will be detected at the next deployment and the cron task will be configured for your application.

For instance, here is a file example of how to schedule a task every 10 minutes to execute the command `rails orders:check` on a 2XL container:

```json
{
  "jobs": [
    {
      "command": "*/10 * * * * rails orders:check",
      "size": "2XL"
    }
  ]
}
```

Each job is configured as a JSON object with two keys:
- `command`: contains both the cron expression and the command to execute:
  - The cron expression follows the [crontab standard](https://en.wikipedia.org/wiki/Cron#CRON_expression). You may find the website [crontab.guru](https://crontab.guru/#*/10_*_*_*_*) useful to write your own cron expression.
  - The command is any command you can execute in a one-off container (i.e. with the command `scalingo --app my-app run <command>`).
- `size`: specify the [container size]({% post_url platform/internals/2000-01-01-container-sizes %}) of the one-off container executing the command. This key is optional, it defaults to M (512 MiB RAM).

## Get Configured Cron Tasks

Get the list of tasks configured on your application using the Scalingo CLI:

```
scalingo --app my-app cron-tasks
+--------------------------+------+
|         COMMAND          | SIZE |
+--------------------------+------+
| */10 * * * * echo biniou |      |
+--------------------------+------+
```
