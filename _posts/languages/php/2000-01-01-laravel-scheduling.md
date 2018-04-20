---
title: Laravel Command Scheduler
modified_at: 2018-04-20 00:00:00
tags: php, laravel, scheduling
---

The Laravel PHP framework includes a command scheduler for asynchronous tasks. However, Laravel's
[documentation](https://laravel.com/docs/5.6/scheduling#introduction) states you need to add a cron
entry which is not possible on Scalingo.

This documentation page guides you to let your application use the Laravel command scheduler on
Scalingo. The following command must be added to your app. It calls the Laravel scheduler every
minutes. It requires you to start [another process]({% post_url platform/app/2000-01-01-procfile %})
in your application.

```php
<?php

namespace App\Console\Commands;

use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Artisan;

class SchedulerDaemon extends Command
{
  /**
   * The name and signature of the console command.
   *
   * @var string
   */
  protected $signature = 'schedule:daemon {--sleep=60}';

  /**
   * The console command description.
   *
   * @var string
   */
  protected $description = 'Call the scheduler every minute.';

  /**
   * Execute the console command.
   *
   * @return mixed
   */
  public function handle()
  {
      while (true) {
          $this->line('<info>[' . Carbon::now()->format('Y-m-d H:i:s') . ']</info> Calling scheduler');

          $this->call('schedule:run');

          sleep($this->option('sleep'));
      }
  }
}
```

Don't forget to add the following line to the `Procfile` of your application:

```
scheduler: php artisan schedule:daemon
```

Based on an article on [Neon
Tsunami](https://www.neontsunami.com/posts/laravel-scheduler-on-heroku).
