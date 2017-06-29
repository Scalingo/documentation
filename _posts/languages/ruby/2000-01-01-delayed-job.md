---
title: Using Delayed Job (DJ) to Handle Background Tasks
modified_at: 2016-01-13 10:39:00
categories: languages ruby
tags: ruby gem async jobs delayed
---

## What is `delayed_job`?

Delayed Job let you run background tasks with your Rails application. It uses
your database as a queue to process background jobs. If your app has a high
database load using DelayedJob may not be a good background queueing library
for your project and you should have a look to
[Sidekiq](https://github.com/mperham/sidekiq) or
[Resque](https://github.com/resque/resque).

## Adding `delayed_job` to your Project

To get started using Delayed Job you need to configure your application.

```ruby
# With MySQL or PostgreSQL
gem 'delayed_job_active_record'

# OR if your using MongoDB
gem 'delayed_job_mongoid'
```

Then, run `bundle install` to install the gem.

If your using MySQL or PostgreSQL, you also need to apply migrations to your database:

```bash
rails generate delayed_job:active_record
rake db:migrate
```

That's it your application is ready, you can find more information on their
[Github page](https://github.com/collectiveidea/delayed_job)

## Adding 'delayedjob' container type in your Procfile

Once `delayed_job` has been installed, you need to add a new type of containers
in your application which will actually start delayed_job. Add the following
line to the [**Procfile**]({% post_url internals/2014-12-01-procfile %}) of
your project.  Create the file if it doesn't exist.

```yaml
delayedjob: bin/delayed_job run
```

<blockquote class="bg-danger">
Do not use <code>delayed_job start</code> to start the process.
<code>start</code> starts the process in background and our crash detection
system will consider it as crashed, it has to run in the foreground thanks to
the <code>run</code> command.
</blockquote>

All you have to do now is to write your jobs by following [DJ
documentation](https://github.com/collectiveidea/delayed_job) and deploy your
code:

```bash
git add Gemfile Gemfile.lock Procfile
git commit -m "Add delayed job"
git push scalingo master
```

The process won't be started directly, but by going to the dashboard of your
application or by running the `scalingo ps` command, you'll see that's the new
container type is present, just scale it to 1 to start it.
