---
title: Using Delayed Job (DJ) to Handle Background Tasks
nav: Delayed Job
modified_at: 2016-01-13 10:39:00
tags: ruby gem async jobs delayed
---

## What is `delayed_job`?

Delayed_job lets you run background tasks with your Rails application. It uses your database as a queue to process
background jobs. Since Rails 8, [Solid Queue]({% post_url languages/ruby/2000-01-01-solid-queue %}) is the default 
background job processor for Rails applications.

If your app has a high database load, using a database-backed background job library may not be a good choice for your
project and you should have a look at [Sidekiq]({% post_url languages/ruby/2000-01-01-sidekiq %}) or [Resque](https://github.com/resque/resque).

## Adding `delayed_job` to your Project

To get started using delayed_job you need to configure your application.

```ruby
# With MySQL® or PostgreSQL®
gem 'delayed_job_active_record'

# OR if you're using MongoDB®
gem 'delayed_job_mongoid'
```

Then, run `bundle install` to install the gem.

If you are using MySQL® or PostgreSQL®, you also need to apply migrations to your
database:

```bash
rails generate delayed_job:active_record
rake db:migrate
```

That's it, your application is ready! You can find more information on their
[GitHub page](https://github.com/collectiveidea/delayed_job).

## Adding 'delayedjob' container type in your Procfile

Once `delayed_job` has been installed, you need to add a new type of containers
in your application which will actually start delayed_job. Add the following
line to the [`Procfile`]({% post_url platform/app/2000-01-01-procfile %}) of
your project. Create the file if it doesn't exist.

```yaml
delayedjob: bin/delayed_job run
```

{% warning %}
  Do not use <code>delayed_job start</code> to start the process.
  <code>start</code> starts the process in background and our crash detection
  system will consider it as crashed, it has to run in the foreground thanks to
  the <code>run</code> command.
{% endwarning %}

All you have to do now is to write your jobs by following [delayed_job
documentation](https://github.com/collectiveidea/delayed_job) and deploy your
code:

```bash
git add Gemfile Gemfile.lock Procfile
git commit -m "Add delayed job"
git push scalingo master
```

The process won't be started directly, but by going to the dashboard of your
application or by running the `scalingo ps` command, you'll see that the new
container type is present. Scale it to 1 to start it.
