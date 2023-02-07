---
title: Scheduled Jobs with Custom Clock Processes
nav: Custom Clock Processes
modified_at: 2023-02-01 17:00:00
tags: task-scheduling
index: 2
---

Scalingo provides a feature called *Custom Clock Processes* to help you run
tasks on a regular basis. Unlike jobs setup through the [Scalingo Scheduler]({% post_url platform/app/task-scheduling/2000-01-01-scalingo-scheduler %}),
custom clock processes do not suffer from many limitations.

## About Custom Clock Processes

Custom clock processes allow to define tasks so that they run periodically.
They give you full control over the schedule, periodicity and conditions on
which the jobs are launched, making them a powerful alternative to the Scalingo
Scheduler.

A custom clock process is basically a background process running indefinitely
in a container and waking up at specified interval(s) to launch some job(s).
This background process is responsible for controlling what job(s) must be
launched and when. It really acts as a job scheduler.

It's usually written in the language of your choice. This means that your
custom clock process can either share the same code base as your application's
or a dedicated one.

Custom clock processes also work with [Review Apps]({% post_url platform/app/2000-01-01-review-apps %}),
just like the parent application does.

### Limitations

Custom clock processes have very few limitations:
- For deployments: [deployment limits]({% post_url platform/deployment/2000-01-01-limits %})
- For containers: [containers limits]({% post_url platform/internals/2001-01-01-container-sizes#container-limits %})

They **do not** have the limitations imposed by the Scalingo Scheduler.
Consequently, they allow to:

- Run (very) long process. The jobs you run in your custom clock process
  container(s) don't have a limited lifespan.

- Run as many scheduled jobs as you want.

- Have full control over the schedule: if you want a task to repeat every
  minute, you can.

- Have a very precise schedule, if need be.

### Costs

The feature itself it completely free, but the container in which the
scheduler and the jobs are run is billed like any other container.

Consequently, billing of a custom clock process mainly depends on both the
container size chosen to run your tasks and on the container lifespan.

Your custom clock process is most probably to run 24/7, as opposed to the
Scalingo Scheduler's one-off containers that are short-lived. A custom clock
process can therefore be a bit more costly.

For example, if you setup your custom clock process to run in a 2XL container,
and you let it run for 3 days before scaling it down to zero, you will be
billed 3 days of a 2XL container.

## Working With Custom Clock Processes

### Defining Custom Clock Processes

Defining a custom clock process is done by adding a new **process type** in
the [`Procfile`]({% post_url platform/app/2000-01-01-procfile %}) of your
application.

In the following examples, the name `clock` is used to designate our custom
clock process type. But, except from `web`, `tcp` and `postdeploy`, which are
reserved by the platform, you can chose whatever you want. `scheduler`, `cron`,
`planner`, `timer`, `butler`, ... These are all valid names for your custom
clock process type.

The syntax is pretty straightforward:

```yaml
clock: <command_to_start_your_job_scheduler>
```

### Implementing Custom Clock Processes

The implementation of the custom clock process mainly depends on the language
or framework you want to use. A lot of languages and frameworks provide this
feature through dedicated libraries. Here are a few examples:

#### Using Ruby

The following gems may help you:
- [clockwork](http://rubygems.org/gems/clockwork)
- [resque-scheduler](https://rubygems.org/gems/resque-scheduler)
- [sidekiq-scheduler](https://rubygems.org/gems/sidekiq-scheduler) (Sidekiq
Enterprise has cron-like feature built-in)

##### Example Using the `clockwork` Gem

The following example leverages the `clockwork` gem to:
- run `frequent.job`every 10 seconds,
- run `less.frequent.job` every 3 minutes,
- run `hourly.job` every hours,
- run `midnight.job` every day at midnight.

`Procfile`:

```yaml
clock: bundle exec clockwork clock.rb
```

`clock.rb`:

```ruby
require 'clockwork'
require 'active_support/time' # Allow numeric durations (eg: 1.minutes)

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  # handler receives the time when job is prepared to run in the 2nd argument
  # handler do |job, time|
  #   puts "Running #{job}, at #{time}"
  # end

  every(10.seconds, 'frequent.job')
  every(3.minutes, 'less.frequent.job')
  every(1.hour, 'hourly.job')

  every(1.day, 'midnight.job', :at => '00:00')
end
```

#### Using PHP

The following packages may help you:
- [cron/cron](https://github.com/cron/cron) (generic)
- [the Laravel scheduler]({% post_url languages/php/2000-01-01-laravel %}#laravel-tasks-scheduler)
  (Laravel)
- [liebig/cron](https://packagist.org/packages/liebig/cron) (Laravel)
- [heartsentwined/zf2-cron](https://packagist.org/packages/heartsentwined/zf2-cron)
  (Zend Framework 2)
- [daycry/cronjob](https://github.com/daycry/cronjob) (CodeIgniter)

##### Example Using the `cron/cron` Package

The code is available in our [sample-php-cron](https://github.com/Scalingo/sample-php-cron)
repository.

This example leverages the `cron/cron` package to launch a job defined in the
`inc.php` file every 2 minutes.

`Procfile`:

```yaml
clock: php cron.php
```

`cron.php`:

```php
<?php
  require(__DIR__ . '/vendor/autoload.php');

  echo "[CRON] Starting tasks scheduler\n";

  function build_cron() {
    // Increment redis key every minute
    $inc_job = new \Cron\Job\ShellJob();
    $inc_job->setCommand('php inc.php');
    $inc_job->setSchedule(new \Cron\Schedule\CrontabSchedule('*/2 * * * *'));

    $resolver = new \Cron\Resolver\ArrayResolver();
    $resolver->addJob($inc_job);

    $cron = new \Cron\Cron();
    $cron->setExecutor(new \Cron\Executor\Executor());
    $cron->setResolver($resolver);

    return $cron;
  }

  $cron = build_cron();

  // Every 60 seconds, run the scheduler which will execute the tasks
  // which have to be started at the given minute.
  while(true) {
    echo "[CRON] Running tasks\n";
    $report = $cron->run();

    while ($cron->isRunning()) { }

    echo "[CRON] " . count($report->getReports()) . " tasks have been executed\n";

    foreach($report->getReports() as $job_report) {
      $output = $job_report->getOutput();
      foreach($output as $line) {
        echo "[CRON] " . $line;
    }

    sleep(60);
  }
?>
```

#### Using Node.js

The following packages may help you:
- [node-cron](https://www.npmjs.com/package/cron)
- [node-schedule](https://www.npmjs.com/package/node-schedule)

##### Example Using `node-cron` Package

The code is available in our [sample-node-express](https://github.com/Scalingo/sample-node-express)
repository.

This example leverages the `node-cron` package to:
- run `job1` every 2 minutes
- run `job2` every minute

Both jobs log a message.

`Procfile`:

```yaml
clock: node cron.js
```

`cron.js`:

```js
var cron = require('cron');

var job1 = new cron.CronJob({
  cronTime: '*/2 * * * *',
  onTick: function() {
    now = new Date();
    console.log(now + ': job 1 ticked');
  },
  start: true,
  timeZone: 'Europe/Paris'
});

var job2 = new cron.CronJob({
  cronTime: '* * * * *',
  onTick: function() {
    now = new Date();
    console.log(now + ': job 2 ticked');
  },
  start: true,
  timeZone: 'Europe/Paris'
});

console.log('Started 2 cron jobs')
```

### Enabling Custom Clock Processes

Once your application has been successfully deployed, scale your custom clock
process type to 1 to start your scheduler in its own dedicated container:

```bash
scalingo --app my-app scale clock:1
```

Moreover, since Scalingo expects a `web` process type to be defined (either by
you in the `Procfile`, or automatically by a buildpack), there is most
probably a `web` process type that would start with your application. **If you
don't need it**, you can disable it by scaling the `web` process type to zero
before or after your deployment:

```bash
scalingo --app my-app scale web:0
```

For more details about web-less applications, please refer to [our
documentation]({% post_url platform/app/2000-01-01-web-less-app %}).

### Disabling Custom Clock Processes

A custom clock process can be disabled anytime by scaling the corresponding
process type to zero:

```bash
scalingo --app my-app scale clock:0
```
