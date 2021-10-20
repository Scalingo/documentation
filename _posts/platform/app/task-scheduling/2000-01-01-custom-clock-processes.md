---
title: Custom Clock Processes
nav: Custom Clock Processes
modified_at: 2021-10-19 10:00:00
tags: task-scheduling
index: 2
---

With custom clock processes, you have the ability to specify custom schedule. You will also have other benefits like
environment parity between development and production, or time precision in your task scheduling.

## Definition of the Custom Clock

The implementation of the custom clock will vary depending on the used language. However, defining the clock process
is very simple and is done in the `Procfile`.

#### Example 

Here is an example of the process definition using the Ruby library`clockwork`:
```yaml
web: bundle exec puma -t 1:3 -p $PORT
clock: bundle exec clockwork clock.rb
```

## Start the Task Scheduler

Once your application has been deployed, scale your 'clock' to 1 to start the task
scheduler:

```bash
$ scalingo --app my-app scale clock:1
```

## Implementation

### Ruby

In Ruby you can use [clockwork](http://rubygems.org/gems/clockwork),
[resque-scheduler](https://rubygems.org/gems/resque-scheduler) or
[sidekiq-scheduler](https://rubygems.org/gems/sidekiq-scheduler) (Sidekiq
Enterprise has cron-like feature built-in) for example.

#### Example

The following example uses the `clockwork` package.

Its initialization is done in the file `clock.rb` and a new kind of container must be defined in the
`Procfile` of the project, the container type `clock`:

```yaml
clock: bundle exec clockwork clock.rb
```

The file which implements the cron-like process is defined in `clock.rb`:

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

For more information about using `clockwork`, please refer to the [rubydoc](https://www.rubydoc.info/gems/clockwork/2.0.4).

### PHP

With PHP, you can use the package [cron/cron](https://github.com/Cron/Cron),
otherwise each framework has its own task scheduler. You may want to use:

* [Laravel scheduler]({% post_url languages/php/2000-01-01-laravel %}#laravel-tasks-scheduler)
* [cron/cron](https://packagist.org/packages/cron/cron)
* [liebig/cron](https://packagist.org/packages/liebig/cron)
* [heartsentwined/zf2-cron](https://packagist.org/packages/heartsentwined/zf2-cron)

#### Example

A complete example project can be found [here](https://github.com/Scalingo/sample-php-cron)

It uses the package `cron/cron` to implement the tasks scheduler.
Its initialization is done in the file `cron.php` and a new kind of container is defined in the
`Procfile` of the project, the container type `clock`:

```yaml
clock: php cron.php
```

The file which implements the cron-like process is defined in `cron.php`:

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
    }
    sleep(60);
  }
?>
```

### Node.js

In Node.js you can use different package such as [node-cron](https://www.npmjs.com/package/cron)
or [node-schedule](https://www.npmjs.com/package/node-schedule).

#### Example

The following example uses the `node-cron` package.

Its initialization is done in the file `cron.js` and a new kind of container must be defined in the
`Procfile` of the project, the container type `clock`:

```yaml
clock: node cron.js
```

The file which implements the cron-like process is defined in `cron.js`:

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

With this example, the `job1` ticks every 2 minutes and the `job2` ticks every minute. Each job
display a message in the log of the application.

The code is available in [sample-node-express](https://github.com/Scalingo/sample-node-express).