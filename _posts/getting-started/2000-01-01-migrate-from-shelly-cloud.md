---
title: Migrate from Shelly Cloud
modified_at: 2015-10-13 16:23:00
category: getting-started
tags:
- shelly cloud
- ror
- ruby on rails
permalink: /migrate-from-shelly-cloud/
---

Scalingo's approach to Platform as a Service is closer to the Heroku model than the one from Shelly Cloud. It's very easy to understand and you'll be able to quickly migrate your Ruby on Rails project from Shelly Cloud to Scalingo.

In the following sections we'll get through the different bits of configuration present in your **Cloudfile** and explain what to do on Scalingo to achieve the same.

One you've read that, you could take a look at our more generic [Getting Started with Rails]({% post_url /languages/ruby/2015-02-17-getting-started-with-rails %}) page.

## ruby_version

**Enabled by default** for all projects, **you don't need to do anything special**.

On Scalingo, you don't need to specify the Ruby version "externally" to your project. Just declare the version of Ruby of your choice in your Gemfile and the platform will automatically install the right version.

## environment

## domains


## spdy

SPDY is not yet available on Scalingo. If you really need SPDY support, ping us on [support@scalingo.com](support@scalingo.com).

## websockets

Websocket is **enabled by default** for all projects, **you don't need to do anything special**.

## servers
