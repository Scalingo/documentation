---
title: Run Scheduled Tasks
modified_at: 2016-01-28 12:22:00
tags: app
index: 15
---

Running scheduled tasks on Scalingo should be done by yourself. We don't
implement cron or cron-like features in our container system. Most languages
have alternatives. We list some of them below:

## Ruby

In Ruby you can use [clockwork](http://rubygems.org/gems/clockwork),
[resque-scheduler](https://rubygems.org/gems/resque-scheduler) or
[sidekiq-scheduler](https://rubygems.org/gems/sidekiq-scheduler) (Sidekiq
Enterprise has cron-like feature built-in) for example.

With clockwork, you would end up with a Procfile similar to this one:

```yaml
web: bundle exec puma -t 1:3 -p $PORT
clock: bundle exec clockwork clock.rb
```

Once your application has been deployed, scale your 'clock' to 1 to start the task
scheduler:

```bash
scalingo --app my-app scale clock:1
```

## PHP

With PHP, you can use the package [`cron/cron`](https://github.com/Cron/Cron),
otherwise each framework has its own task scheduler. You may want to use:

* [Laravel scheduler]({% post_url languages/php/2000-01-01-laravel %}#laravel-tasks-scheduler)
* [https://packagist.org/packages/cron/cron](https://packagist.org/packages/cron/cron)
* [https://packagist.org/packages/liebig/cron](https://packagist.org/packages/liebig/cron)
* [https://packagist.org/packages/heartsentwined/zf2-cron](https://packagist.org/packages/heartsentwined/zf2-cron)

### Example

A complete example project can be found at the following address:
[https://github.com/Scalingo/sample-php-cron](https://github.com/Scalingo/sample-php-cron)

It uses the package [`cron/cron`](https://github.com/Cron/Cron) to implement the tasks scheduler.
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

  // Every 60 seconds, run the scheduler which will execute the tasks
  // which have to be started at the given minute.
  while(true) {
    $cron = build_cron();

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

## Node.js

In Node.js you can use different package such as [`node-cron`](https://www.npmjs.com/package/cron)
or [`node-schedule`](https://www.npmjs.com/package/node-schedule).

### Example

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

With this example, the `job1` ticks every 2 minutes and the `job2` ticks every minute. Each job just
display a message in the log of the application.

The code is available in [sample-node-express](https://github.com/Scalingo/sample-node-express).
