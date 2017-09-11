---
title: Getting Started with Rails
modified_at: 2015-11-30 00:00:00
category: getting-started
tags: ruby rails tutorial getting-started-tutorial
index: 3
permalink: /languages/ruby/getting-started-with-rails/
---

## Initialize your application

```bash
$ rails new rails-app

#
# It creates file and run 'bundle install'
#

$ git init
$ git add .
$ git commit -m "Base rails application"
```

## Create your application on Scalingo

<blockquote class="bg-info">
  You can also use our web dashboard to achieve this operation
</blockquote>

```bash
$ scalingo create ruby-app
Git repository detected: remote scalingo added
→ 'git push scalingo master' to deploy your app
```

## Provision and configure your database

* Go on the [dashboard](https://my.scalingo.com/apps) of your application.
* Select the __Addons__ category
* Choose the database you want to use

### PostgreSQL

Add the gem `pg` to your `Gemfile`

### MySQL

Add the gem `mysql` to your `Gemfile`:

```ruby
gem 'mysql2', '~> v0.3.18'
```

Then set the following environment variable:

* `DATABASE_URL`
  → Copy the value of `SCALINGO_MYSQL_URL` and replace 'mysql://' by 'mysql2://'

{% include info_environment_how_to.md %}

### MongoDB

To use a MongoDB database your need to add the gem `mongoid` to your `Gemfile`

[Configure Mongoid]({% post_url languages/ruby/2014-10-17-configure-mongoid %})

## Setup your application logging

By default, rails application don't write their logs to STDOUT but in a custom file.
We expect your applications to write all their logging entries to STDOUT and STDERR
according to their nature, in accordance to the [12 factors](http://12factor.net)

* Add the following gem in your `Gemfile`: `gem "rails_12factor"`

## Finalize and deploy

```bash
$ bundle install
$ git add .
$ git commit -m "Configure application for Scalingo"
$ git push scalingo master
```

## Access your application

```bash
…
Waiting for your application to boot...
<-- https://ruby-app.scalingo.io -->
```

Yes a new application will render a 404 error `The page you were looking for doesn't exist.`,
but it's normal, there is nothing in the project, it's time to build your product!
