---
title: Get Started with Ruby on Scalingo
modified_at: 2026-01-02 12:00:00
tags: ruby sinatra tutorial getting-started-tutorial
index: 3
---

## Installing the tools

This tutorial is depicting how to deploy a Ruby application on Scalingo

{% note %}
  Note: This tutorial does not cover the Ruby on Rails installation, If you're looking to deploy a Ruby on Rails project, follow the [Get Started with Ruby on Rails tutorial]({% post_url languages/ruby/rails/2000-01-01-start %})
{% endnote %}

To be able to follow this tutorial, we assume that you have:

* A [Scalingo account](https://auth.scalingo.com/users/sign_up)
* Ruby version 2.3.5+ -- see the GoRails setup guide
  [window](https://gorails.com/setup/windows/10),
  [mac](https://gorails.com/setup/osx/10.13-high-sierra),
  [linux](https://gorails.com/setup/ubuntu/17.10)
* [Bundler](https://bundler.io/) installed locally: `gem install bundler`
* The [Scalingo cli](https://cli.scalingo.com/)

## Bootstrap your project

Let's start by creating a new Ruby application:

```bash
$ mkdir my-ruby-app
$ cd my-ruby-app
```

And create your `Gemfile`

```bash
$ bundle init
```

This will create a file name `Gemfile`. This file will be used for describing gem dependencies for
your Ruby application.


## Create your Ruby application

{% note %}
  For this example we will use the Sinatra HTTP framework, but any Ruby HTTP framework works on
  Scalingo.
{% endnote %}

Let's start by adding the `sinatra` gem to our `Gemfile` by adding the following line at the end of the file:
```Gemfile
gem 'sinatra', '~> 2.0', '>= 2.0.1'
```

And start the gem installation:

```bash
$ bundle install
```

Once installed, create a file name `app.rb` with the following content:

```ruby
require 'sinatra'

get '/' do
  'Hello World'
end
```

This will create a HTTP server using the Sinatra framework which will respond `Hello World` when asked for the `/` endpoint.

To run your application, use:

```bash
$ ruby app.rb
```

And open a browser to [localhost:4567](http://localhost:4567).

## Using a custom port

There is one issue with that code, it is that the application will always listen to the `4567` port.
But when deploying on Scalingo, the port that you should listen to is defined in the `PORT`
environment variable. We should adapt our code to use this environment variable:

```ruby
require 'sinatra'

set :port, ENV['PORT'] || 4567

get '/' do
  'Hello World'
end
```

This line will tell Sinatra to listen to the port `4567` or the port defined in the `PORT` environment variable if the `PORT` environment variable is defined.

You can try this by setting the `PORT` environment variable while launching your app:

```bash
PORT=3000 ruby app.rb
```

Now your app will be available at the following address: [localhost:3000](http://localhost:3000).

## Tell Scalingo how to start your application

The last step before the deployment is to tell Scalingo how to start your application.
This is done using a special file called [Procfile]({% post_url platform/app/2000-01-01-procfile %}).

Tell Scalingo to start the `web` process with the `ruby app.rb` command by creating a file called
`Procfile` with the following content:

```yaml
web: ruby app.rb
```

## Commit your change

It's now time to commit our changes:

```bash
$ git init
$ git add .
$ git commit -m "Initial commit"
```

## Create the app on Scalingo

Time to deploy our app! First we need to create our app on Scalingo. We can use the CLI with the
following syntax:

```
$ scalingo create my-ruby-app
```

## Deploy on Scalingo

Now all the hard work is done, push your application to Scalingo and let the magic happen:

```
$ git push scalingo master

       Fetching source code
-----> Compiling Ruby/Rack
# [...]
-----> Procfile declares types -> web

-----> Build complete, uploading deployment cache.
 Build complete, shipping your container...
 Waiting for your application to boot...
 <-- https://my-ruby-app.osc-fr1.scalingo.io -->
```

## Database migrations

To run a migration, you need to use a [post-deployment hook]({% post_url platform/app/2000-01-01-postdeploy-hook %}).

The Ruby application starts up before the schema has changed, but does not receive a query.

As a result, if operations are started before the migration has been executed, the application may load the schema `pre-migration`. A restart could be necessary after the migration.

The best practice is to perform non-destructive migrations, where a column rename is performed in several steps, rather than an `ALTER TABLE` renaming a column.

A good example in `strong_migrations` gem [documentation](https://github.com/ankane/strong_migrations#renaming-a-column).

{% include app_start_without_migration.md %}
