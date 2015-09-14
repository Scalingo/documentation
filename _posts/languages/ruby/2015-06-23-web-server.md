---
title: Ruby application server
modified_at: 2015-06-23 00:00:00
category: languages
tags: ruby, application, server,
---

## Ruby application web server

Ruby contains a default application web server named `WEBrick`. As it is always present, most web framework use it by default. It's good enough in
development, but it has never been thought to be a production server.

## Do not use WEBrick

`WEBrick` has the following caracteristics:

* Single threaded
* Single process

It can't handle several request in parallel, they are all in a single request queue. As a result, very pool performance can be expected. To get
the best of your containers, you need to use a real production-ready application server.

## Production web server

To handle several requests in parallel, we recommend [puma](http://puma.io). To use it, just add it as dependency in your Gemfile:

{% highlight text %}
gem 'puma'
{% endhighlight %}
