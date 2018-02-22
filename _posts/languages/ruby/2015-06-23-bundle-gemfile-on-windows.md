---
title: Deploy a ruby project developped on Windows
modified_at: 2015-06-23 00:00:00
categories: languages ruby
tags: ruby application server
---

## Context

Applications running in Scalingo's infrastructure are running on a distribution
of Linux with the architecture `amd64`. If you are using Windows to develop
your application, incompatibility may occur.

When you are running `bundle install` to install the dependencies of your
project, Bundler will select the best versions possible for each gem you've
listed in your `Gemfile`. Some of these gems have special version for Windows.

{% note %}
  Gems with suffixes like `-mingw32 or -mswin` in your `Gemfile.lock` have special versions for Windows.
{% endnote %}

As Scalingo's stack is based on Linux, we can't install these precise versions.

## Specify explicitly your gems version

As a result, the `Gemfile.lock` won't be considered when a Windows machine is
deploying a Ruby application. So you need to lock the versions manually by
modifying the `Gemfile`:

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
