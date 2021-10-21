---
title: Private Beta - Scalingo Scheduler - Run Scheduled Tasks
nav: Scalingo Scheduler
modified_at: 2021-10-19 10:00:00
tags: app
index: 15
---

{% warning %}
This feature is currently available only in private beta. Ask the support to get early access.
{% endwarning %}

Scalingo Scheduler is here to help you run scheduled tasks at regular intervals.

The syntax used to describe this interval is the same as in the cron software.

Scalingo Scheduler launches tasks as [one-off containers]({% post_url platform/app/2000-01-01-tasks %}) in detached mode. Therefore the related one-off documentation and their detached mode applies.

{% warning %}
Scheduled tasks execution is expected but not guaranteed. Scalingo Scheduler is known to occasionally (but rarely) miss the execution of scheduled jobs. If scheduled tasks are a critical component of your application, it is recommended to [run a custom clock process]() instead for more reliability, control, and visibility.
{% endwarning %}

## Defining Tasks

Scheduled tasks are defined by adding a `cron.json` file at the root of your application's source code.

The file will be read at the next deployment and the tasks will be launched automatically.

It must be a **valid JSON file** in the format specified below.

Each job is configured as a JSON object with two keys:

- `command`: contains both the cron expression and the command to execute:
  - The cron expression follows the [crontab standard](https://en.wikipedia.org/wiki/Cron#CRON_expression). You may
  find the website [crontab.guru](https://crontab.guru/#*/10_*_*_*_*) useful to write your own cron expression.
  - The command is any command you can execute in a one-off container
  (i.e. with the command `scalingo --app my-app run <command>`).
- `size`: specify the [container size]({% post_url platform/internals/2000-01-01-container-sizes %}) of the one-off
container executing the command. This key is optional, it defaults to M (512 MiB RAM).

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

**Your cron expression must be set with at least a 10 minutes interval.**


### Costs

Scalingo Scheduler in itself is free.

The one-off containers launched to run the commands will be billed like other [one-off containers]({% post_url platform/app/2000-01-01-tasks %}).

You will be billed for the type of container you defined in your task (M is the default container size) and for the time it was executed.

For example if your task run during 5 minutes, you will be billed 5 minutes of an M container.

## Long-running Tasks

Scheduled tasks are meant to execute short running tasks.

A one-off container started by Scalingo Scheduler will not run longer than its scheduling interval. For example, for a job that runs every 10 minutes, one-offs will be terminated after running for 10 minutes.

If your tasks may last more than the in-between interval of two tasks we suggest to enqueue those tasks into a background job queue.

Note that there is some jitter in the dyno termination scheduling. This means that two dynos running the same job may overlap for a brief time when a new one is started.

## Get The List Of Current Scheduled Tasks

Get the list of tasks configured on your application using the Scalingo CLI:

```
scalingo --app my-app cron-tasks
+---------------------------------+------+
|            COMMAND              | SIZE |
+---------------------------------+------+
| */10 * * * * rails orders:check | 2XL  |
+---------------------------------+------+
```

## Mofify or Delete Scheduled Tasks

In order to modify or delete a cron task, you must modify or delete the associated entry in the `cron.json` and push your code to trigger a new deployment.

The list of tasks will be updated when the application will be redeployed.

If there is no more task, or if you want to remove all tasks, you can also remove the file.

## FAQ

### How To Enable Scalingo Scheduler?

Scalingo Scheduler will be enabled automatically as soon as a `cron.json` file is present.

### How To Disable Scalingo Scheduler?

Once you commited a `cron.json` it's not possible to disable tasks. 

If you wish to control the execution of tasks differently between environment (think about staging apps or [review apps]({% post_url
platform/app/2000-01-01-review-apps %})) we suggest to modify the tasks related code to detect the environment where they are executed.

### How Precise Is Scalingo Scheduler?

Execution time can be delayed by a few minutes. Indeed in order to execute tasks on an application we need to pull the application image which could take a few minutes depending on its size. 

If you need more precision we suggest to [run a custom clock process]().
