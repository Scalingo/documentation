---
title: Run scheduled tasks
modified_at: 2016-01-18 12:22:00
category: app
tags: app
---

Running scheduled tasks on Scalingo should be done by yourself. We don't implement cron or cron-like features in our container system. Most langages have alternative that are listed below.

## Ruby

In Ruby you can use [clockwork](http://rubygems.org/gems/clockwork), [resque-scheduler](https://rubygems.org/gems/resque-scheduler) or [sidekiq-scheduler](https://rubygems.org/gems/sidekiq-scheduler) (Sidekiq Enterprise has cron-like feature built-in) for example.

With clockwork, you would end up with a Procfile similar to this one:

```ruby
web: bundle exec puma -t 1:3 -p $PORT
clock: bundle exec clockwork clock.rb
```

## PHP

TBD
