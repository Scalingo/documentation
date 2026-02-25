---
title: Scalingo Scheduler - Run Scheduled Tasks
nav: Scalingo Scheduler
modified_at: 2026-02-24 16:00:00
tags: task-scheduling
index: 1
---

Scalingo provides a feature called *Scalingo Scheduler* to help you run tasks
on a regular basis.

## About the Scalingo Scheduler

The Scalingo Scheduler allows to define tasks so that they run periodically at
fixed times, dates, or intervals. It can be leveraged to do a variety of tasks
such as sending a newsletter every morning, exporting data every hour, checking
for new orders every 15 minutes, ...

The Scalingo Scheduler launches tasks in one-off containers running in detached
mode. Therefore, [the related one-off documentation]({% post_url platform/app/2000-01-01-tasks %})
fully applies.

The Scalingo Scheduler also works with [Review Apps]({% post_url platform/app/2000-01-01-review-apps %}),
meaning that review apps have the same scheduled tasks as their parent
application.

### Limitations

The following limitations currently exist, be it for security, performance or
stability reasons:

- The Scalingo Scheduler has been designed to run short to medium lived tasks
  (in opposition to long living ones that could last days). Consequently,
  **scheduled tasks won't run more than 12 hours**. They are automatically
  killed as soon as they reach this limit.

- Moreover, a one-off container started by the Scalingo Scheduler will not run
  longer than its scheduling interval. For example, a scheduled task set up to
  run every 10 minutes will be terminated after running for 10 minutes. A
  scheduled task set to run every day will be killed after running for
  12 hours (see above).

- The smallest scheduling interval is set to 10 minutes. For example, the
  Scalingo Scheduler won't let you set up a task to run every 5 minutes (the
  deployment will fail).

- **A maximum of 5 tasks** can be scheduled through the Scalingo Scheduler.
  Please get in touch with the support if you need more, they will study your
  request and advise you.

- Task execution is expected but **not guaranteed**. The Scalingo Scheduler is
  known to occasionally (but rarely) miss the execution of a scheduled job.

- Execution time can be delayed by a maximum of 10% of the interval between 2
  tasks (up to 20 minutes).

  * `*/10 * * * *` (every 10 minutes): task will be executed every 10 to 11
    minutes;
  * `0 */1 * * *` (every hour): task will be executed between minute 0 and
    minute 6 of each hour;
  * `0 0 * * *`: (everyday at midnight): task will be executed between 00:00
    and 00:20 UTC.

- Two one-off containers running the same scheduled task may overlap for a
  brief time if the task is not finished when a new one is started.

{% note %}
All these limitations can be circumvented by using a
[custom clock process]({% post_url platform/app/task-scheduling/2000-01-01-custom-clock-processes %}).
{% endnote %}

### Costs

Although the Scalingo Scheduler itself is free, the one-off containers in which
the commands are run are billed like any other
[one-off container]({% post_url platform/app/2000-01-01-tasks %}).

Consequently, billing depends on the type of container you defined in your task
(M is the default container size) and on the job lifespan.

For example, if your job runs during 5 minutes, you will be billed 5 minutes of
an M container.

## Working with the Scalingo Scheduler

### Enabling the Scalingo Scheduler

The Scalingo Scheduler is enabled automatically as soon as a valid `cron.json`
file is present at the root of your application.

### Disabling the Scalingo Scheduler

For now, it's not possible to disable scheduled tasks without modifying or
removing the `cron.json` file and triggering a new deployment thereafter.

To disable scheduled tasks on a specific environment (for example, if you want
to disable your scheduled tasks on your staging app), please see
[Dealing with Multiple Environments](#dealing-with-multiple-environments).

### Defining Tasks

Scheduled tasks are defined in the `cron.json` file stored at the root of your
application's source code. The platform automatically detects and reads the
file during deployment, and sets up the tasks according to the given schedule.

The `cron.json` file must be a **valid JSON file** in the format specified
below.

Each job is configured as a JSON object with two keys:

- `command`: contains both the cron expression and the command to execute:
  - The cron expression follows the **[crontab standard](https://en.wikipedia.org/wiki/Cron#CRON_expression)**.
    You may find the website [crontab.guru](https://crontab.guru/#*/10_*_*_*_*)
    useful to write your own cron expression. Note that we do not support the
    non standard `@-ly` syntax.
  - The command is any command you can execute in a one-off container
    (i.e. with the command `scalingo --app my-app run <command>`).
- `size`: specify the [size]({% post_url platform/internals/2000-01-01-container-sizes %})
  of the one-off container executing the command. This key is optional and
  defaults to M (512 MiB RAM).

**All dates are expressed in UTC**. For instance, if you are located in Paris
or Berlin (CET timezone, UTC+1) and you want a scheduled task to be executed at
10:00 in your local time, your cron expression should mention 09:00. For Athens
(EET, UTC+2), your cron expression should mention 08:00 to achieve the same
result.

#### Examples

Schedule a task to run every morning at 8AM CET:

```json
{
  "jobs": [
    {
      "command": "0 7 * * * /bin/send-newsletter"
    }
  ]
}
```

Schedule a task to run `rails orders:check` every 10 minutes in a 2XL
container:

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

### Listing Scheduled Tasks

You can list your scheduled tasks by using the Scalingo CLI:

```bash
$ scalingo --app my-app cron-tasks
+---------------------------------+------+------------------------+---------------------+
|            COMMAND              | SIZE |     LAST EXECUTION     |    NEXT EXECUTION   |
+---------------------------------+------+------------------------+---------------------+
| */10 * * * * rails orders:check | 2XL  | No previous executions | 2023/01/31 14:10:00 |
+---------------------------------+------+------------------------+---------------------+
```

### Dealing with Multiple Environments

If you wish to control the execution of tasks differently between environments
(for example, if you want to run your scheduled tasks differently on your
staging apps or on your [review apps]({% post_url platform/app/2000-01-01-review-apps %}))
we suggest to modify the task's code to [detect the environment]({% post_url platform/app/2000-01-01-environment %}#runtime-environment-variables)
where they are executed.

### Updating or Removing Scheduled Tasks

To modify or remove a scheduled task, you must modify or delete the associated
entry in the `cron.json` file and push your updated file to Scalingo. This will
trigger a new deployment, allowing the platform to handle your changes.

If there is no more task, or if you want to remove all tasks, you can also
remove the file.

### Reading Scheduled Tasks Logs

Logs for scheduled tasks are included in the [application logs]({% post_url platform/app/2000-01-01-logs %}), 
next to other containers logs.
