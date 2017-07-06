---
title: Deploy a ruby project developped on Windows
modified_at: 2015-06-23 00:00:00
categories: ruby
tags: ruby application server languages
---

## Context

Applications running in Scalingo's infrastructure are running on a distribution of Linux
with the architecture `amd64`. If you are using Windows to develop your application. Incompatibility
may occure.

When you are running `bundle install` to install the dependencies of your project, Bundler will
select the best versions possible for each gem you've listed in your `Gemfile`. Some of these gems
have special version for Windows.

> Gems with suffixes like `-mingw32 or -mswin` in your `Gemfile.lock` have special versions for Windows.

As Scalingo's stack is based on Linux, we can't install these precise versions.

## Specify explicitely your gems version

As a result, the `Gemfile.lock` won't be considered when a Windows machine is deploying a ruby application.
So you need to lock the versions manually.

```text
gem 'rails'
```

should become 

```text
gem 'rails', '4.2.0'
```

If the version has not been specified, it will let Bundler install the last version compatible for your
project. That's probably not what you want and may probably break your application. So you have to ensure
that all the gems in your `Gemfile` have a version specified.
