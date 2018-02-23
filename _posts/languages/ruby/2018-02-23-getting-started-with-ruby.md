---
title: Getting Started with Ruby
modified_at: 2018-02-23 00:00:00
category: getting-started
tags: ruby sinatra tutorial getting-started-tutorial
index: 3
permalink: /languages/ruby/getting-started-with-ruby/
---

## Installing the tools

This tutorial will show you how to deploy a ruby app in minutes.

Note: This tutorial does not cover the rails installation, if you want to start a rails project use our [getting started with rails tutorial]({% post_url languages/ruby/2015-02-17-getting-started-with-rails %})

To be able to follow this tutorial, we assume that you have:

* A [Scalingo account](https://scalingo.com/users/signup)
* Ruby version 2.3.5+ -- see the gorails setup guide [window](https://gorails.com/setup/windows/10), [mac](https://gorails.com/setup/osx/10.13-high-sierra), [linux](ihttps://gorails.com/setup/ubuntu/17.10)
* [Bundler](http://bundler.io/) installed locally: `gem install bundler`
* The [Scalingo cli](http://cli.scalingo.com/)

## Bootstrap your project

Let's start by creating a new ruby application:

```bash
$ mkdir my-ruby-app
$ cd my-ruby-app
```

And create your `Gemfile`

```bash
$ bundle init
```

This will create a file name `Gemfile`. This file will be used for describing gem dependencies for your ruby application.


## Create your ruby application

<blockquote class="bg-info">
For this example we will use the sinatra http framework but any ruby http framework works on Scalingo
</blockquote>

Let's start by adding the `sinatra` gem to our `Gemfile` by adding the following line at the end of the file:
```Gemfile
gem 'sinatra', '~> 2.0', '>= 2.0.1'
```

And start the gem installation:

```bash
$ bundle install
```

Once install create a file name `app.rb` with the following content:

```ruby
require 'sinatra'

get '/' do
  'Hello World'
end
```

This will create a http server using the sinatra framework which will respond `Hello World` when asked for the `/` endpoint.

You can try it by running:

```bash
$ ruby app.rb
```

And openning a browser to [localhost:4567](http://localhost:4567).

## Using a custom port

There is one issue with that code, it is that the application will always listen to the `4567` port. But when deploying on Scalingo, the port that you should listen to is defined in the `PORT` environment variable.

We should adapt our code to use this environment variable:

```ruby
require 'sinatra'

set :port, ENV['PORT'] || 4567

get '/' do
  'Hello World'
end
```

This line will tell sinatra to listen to the port `4567` or the port defined in the `PORT` environment variable if the `PORT` environment variable is defined.

You can try this by setting the `PORT` environment variable while launching your app:

```bash
PORT=3000 ruby app.rb
```

Now your app will be available at the following address: [localhost:3000](http://localhost:3000).

## Tell Scalingo how to start your application

The last step before the deployment is to tell Scalingo how to start your application.
This is done using a special file call [Procfile]({% post_url internals/2014-12-01-procfile %}).

To tell Scalingo to start the `web` process with the `ruby app.rb` command by creating a file called `Procfile` with the following content:

```Procfile
web: ruby app.rb
```

## Commit your change

It's now time to commit our changes:

```
$ git init
$ git add .
$ git commit -m "Initial commit"
```

## Create the app on Scalingo

Time do deploy our app! First we need to create our app on Scalingo.

To create our app, we can use the CLI with the following syntax:

```
$ scalingo create my-ruby-app
```

## Deploy on Scalingo

Now all the hardwork is done, just push your application to Scalingo and let the magic happen.

```
$ git push scalingo master

       Fetching source code
-----> Compiling Ruby/Rack
# [...]
-----> Procfile declares types -> web

-----> Build complete, uploading deployment cache.
 Build complete, shipping your container...
 Waiting for your application to boot...
 <-- https://my-ruby-app.staging.scalingo.io -->
```

## Where to go next

You now know how to deploy a ruby app,

Here are some link that you could find useful:

* Need to store data? Look at our [database addons]({% post_url databases/2014-11-24-databases %})
* Want your own [domain name]({% post_url app/2015-04-01-domain %})?
* Using GitHub? Our [GitHub integration]({% post_url integrations/2000-01-01-github-integration %}) will make your life easier.

