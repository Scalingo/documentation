---
title: Private Beta - Run Scheduled Tasks
nav: Cron Tasks
modified_at: 2021-10-11 14:00:00
tags: app
index: 15
---

{% warning %}
This feature is currently available only in private beta. Ask the support to get early access.
{% endwarning %}

Your application may need to execute some tasks at regular interval. The cron feature is here to help you run scheduled
tasks based on [one-off containers]({% post_url platform/app/2000-01-01-tasks %}).

As Scalingo is a highly distributed platform this feature is not based on the cron software. However the end goal is the same: execute tasks at precise time date interval. The syntax used to describe this interval is the same as in the cron software.

As Scalingo is a highly distributed platform this feature is not based on the cron software. However the end goal is
the same: execute tasks at precise time date interval. The syntax used to describe this interval is the same as in
the cron software.

Instead of running 24/7 a container to execute a task from time-to-time, the cron feature lets you start one-off
containers only when you need.

## Configuring Cron Tasks on Your Application

Configure cron tasks on your application by adding a `cron.json` file at the root of your application. The file will be
detected at the next deployment and the cron-like tasks will be automatically launched.

For instance, here is a file example of how to schedule a task every 10 minutes to execute the command
`rails orders:check` on a 2XL container:

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
  - The cron expression follows the [crontab standard](https://en.wikipedia.org/wiki/Cron#CRON_expression). You may
  find the website [crontab.guru](https://crontab.guru/#*/10_*_*_*_*) useful to write your own cron expression.
  - The command is any command you can execute in a one-off container
  (i.e. with the command `scalingo --app my-app run <command>`).
- `size`: specify the [container size]({% post_url platform/internals/2000-01-01-container-sizes %}) of the one-off
container executing the command. This key is optional, it defaults to M (512 MiB RAM).

**Your cron expression must be set with at least 10 minutes interval.**

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

## Delete Configured Cron Tasks

In order to delete a cron task, you must delete the associated entry in the `cron.json`.
If there is no more task, or if you want to remove all tasks, you can also remove the file.

The cron tasks configuration will be updated when redeploying the application.

## FAQ

### How To Enable Cron Tasks?

The cron feature is currently in beta state. It is possible to get access to it by asking the support.

### How To Disable Cron Tasks?

The cron feature can't be disabled, but you can remove your scheduled tasks by deleting the `cron.json` file.

### How Precise Is The Cron Feature?

In order to execute tasks on an application, we need to pull the application image which could take a few minutes
depending on its size.

### How Will I Be Billed?

The cron feature in itself is free.

The one-off containers launched to run the commands defined in your cron tasks will
be like other [one-off containers]({% post_url platform/app/2000-01-01-tasks %}). You will be billed for the type of
container you defined in your cron task (M is the default container size) and for the time it was executed.

For example if your cron task run during 5 minutes, you will be billed 5 minutes of an M container.
