---
title: Ruby
category: languages
date: 23/06/2015
tags: programming, dev, ruby, language
---

# Ruby

Ruby is entirely supported by Scalingo, furthermore, custom support is added
for the Rails framework in all its versions.

* [Getting Started with Rails](/languages/ruby/getting-started-with-rails.html)

## Buildpack

The buildpack is based on `bundler` and will install the dependencies defined
in the `Gemfile` and `Gemfile.lock` of your project. ([source of the
buildpack](https://github.com/Scalingo/heroku-buildpack-ruby))

## Ruby application

### Ruby app detection

Presence of a `Gemfile`

## Rack based application

### Rack app detection

Presence of a `config.ru`

### Rack environment

When a rack application is detected, the following environment variable will be set:

* `RACK_ENV` → `production`

## Rails application

### Rails app detection

#### Rails 2

Presence of a `config/environment.rb`

#### Rails 3, Rails 4

Presence of a `config/application.rb`

### Rails environment

* `RACK_ENV` → `production`
* `RAILS_ENV` → `production`

## Specifying a custom ruby runtime

If your need to install a custom version of ruby, you can achieve that by specifying
it in your Gemfile:

### Ruby MRI 2.2.0

```ruby
ruby "2.2.0"
```

### JRuby 2.0.0

```ruby
ruby "2.0.0", :engine => "jruby", :engine_version => "1.7.20"
```

## List of the compatible runtimes

### MRI

* `2.2.2`
* `2.2.1`
* `2.2.0`
* `2.1.5`
* `2.1.4`
* `2.1.3`
* `2.1.2`
* `2.1.1`
* `2.1.0`
* `2.0.0`
* `1.9.3`
* `1.9.2`
* `1.8.7`

### Jruby

* `1.7.18`: Ruby versions: `1.8.7`, `1.9.3`, `2.0.0`
* `1.7.19`: Ruby versions: `1.8.7`, `1.9.3`, `2.0.0`
* `1.7.20`: Ruby versions: `1.8.7`, `1.9.3`, `2.0.0`
