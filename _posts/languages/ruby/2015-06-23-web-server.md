---
title: Ruby application server
modified_at: 2016-03-21 00:00:00
tags: ruby application server
---

## Ruby application web server

Ruby contains a default application web server named `WEBrick`. As it is always
present, most web framework use it by default. It's good enough in development,
but it has never been thought to be a production server.

## Do not use WEBrick

WEBrick has the following characteristics:

* Single threaded
* Single process

It can't handle several request in parallel, they are all in a single request
queue. As a result, very poor performance can be expected. To get the best of
your containers, you need to use a real production-ready application server.

## Using Puma as a production server

To handle several requests in parallel, we recommend [puma](https://puma.io).
To use it, just add it as dependency in your `Gemfile`:

```text
gem 'puma'
```

And configure how to launch your app by defining a `Procfile`:

```yaml
web: bundle exec puma -C config/puma.rb
```

The config file looks like the following:

```ruby
workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  ActiveRecord::Base.establish_connection
end
```

Thus you can easily change global settings by modifying the environment
variables `WEB_CONCURRENCY` and `MAX_THREAD` and restarting your app.
