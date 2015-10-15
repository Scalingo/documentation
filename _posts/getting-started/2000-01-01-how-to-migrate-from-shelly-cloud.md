---
title: How to migrate from Shelly Cloud
modified_at: 2015-10-13 16:23:00
category: getting-started
tags: shelly cloud ror ruby rails tutorial
permalink: /how-to-migrate-from-shelly-cloud/
---

Scalingo's approach to Platform as a Service is closer to the Heroku model than the one from Shelly Cloud. It's very easy to understand and you'll be able to quickly migrate your Ruby on Rails project from Shelly Cloud to Scalingo.

In the following sections we'll get through the different bits of configuration present in your **Cloudfile** and explain what to do on Scalingo to achieve the same.

Once you've read that, you could take a look at our more generic [Getting Started with Rails]({% post_url /languages/ruby/2015-02-17-getting-started-with-rails %}) page.

## ruby_version

**Enabled by default** for all projects, **you don't need to do anything special**.

On Scalingo, you don't need to specify the Ruby version "externally" to your project. Just declare the version of Ruby of your choice in your Gemfile and the platform will automatically install the right version.

## environment

Shelly Cloud uses two specific environment variables, Scalingo allows you to have any number of environment variables.
If you want to add or remove some environment variables of your app, we suggest you to manage it from [Scalingo dashboard](https://my.scalingo.com/) "Mass edit" option.
You can also do it by using our [Command line client]({% post_url /cli/2015-09-18-command-line-tool %}) with the following commands:

* `scalingo -a myapp env-set MYVAR=myvalue`
* `scalingo -a myapp env-unset MYVAR`

More information about app environment can be found [here]({% post_url /app/2014-09-15-environment %}).

------------

Shelly Cloud allows you to have a "production" and a "staging" environment within the same app.  
On Scalingo, you will have to create as many apps as you need to simulate these environments, i.e using [Scalingo CLI]({% post_url /cli/2015-09-18-command-line-tool %}):

* `scalingo create myapp`
* `scalingo create myapp-production`
* `scalingo create myapp-staging`
* `scalingo create myapp-production`

You can manage your working environments and work in the same git project, by adding corresponding remotes to your `.git/config` file, i.e:

* `git remote add scalingo git@scalingo.com:myapp.git`
* `git remote add scalingo-production git@scalingo.com:myapp-production.git`
* `git remote add scalingo-staging git@scalingo.com:myapp-staging.git`
* `git remote add myapp-production git@scalingo.com:myapp-production.git`

Deploying your app on multiple environments:

* `git push scalingo master`
* `git push scalingo-production master`
* `git push scalingo-staging master`
* `git push myapp-production master`

## domains

To use your own domain on Shelly Cloud, you were used to add your domain to your `Cloudfile`.
On Scalingo, you will have to add it either:

* using our [CLI]({% post_url /cli/2015-09-18-command-line-tool %}) **->** `scalingo -a my-app domains-add mydomain.com`
* or using our [dashboard](https://my.scalingo.com/) **->** https://my.scalingo.com/apps/**my-app**/domains

For more informations about domains on Scalingo, take a look at our dedicated [domain name management page]({% post_url /app/2015-04-01-domain %}#configure-your-domain-name).

## spdy

SPDY is not yet available on Scalingo. If you need SPDY support, ping us on [support@scalingo.com](support@scalingo.com).

## websockets

Websocket is **enabled by default** for all projects, **you don't need to do anything special**.

## servers

To configure your servers on Scalingo, you will have to configure your settings independantly. We will see each point of the sample Cloudfile below:

Cloudfile:
{% highlight bash %}
servers:
  size:
  databases:
  processes:
{% endhighlight %}

### <u>size</u>

### <u>databases</u>

Databases on Scalingo are part of our [addons collection](https://scalingo.com/addons).<br>
Addons work with plans from 512MB (free tier) to 32G for a [MySQL database addon](https://scalingo.com/addons/scalingo-mysql) for example.<br>
You can add databases using:

* using our [CLI]({% post_url /cli/2015-09-18-command-line-tool %}) **->** `scalingo -a my-app addons-add scalingo-mysql`
* or using our [dashboard](https://my.scalingo.com/) **->** https://my.scalingo.com/apps/**my-app**/addons

### <u>processes</u>

On Scalingo, process definition is done through the Procfile file (take a look at our [dedicated Procfile page](/internals/procfile.html) for more informations).

format: `<container_name>: <command>`

Cloudfile implementation:
{% highlight bash %}
servers:
  puma: 1
{% endhighlight %}

Procfile equivalent:
{% highlight bash %}
web: bundle exec puma
{% endhighlight %}

Cloudfile implementation:
{% highlight bash %}
servers:
  thin: 1
{% endhighlight %}

Procfile equivalent:
{% highlight bash %}
web: bundle exec thin
{% endhighlight %}

Cloudfile implementation:
{% highlight bash %}
servers:
  processes:
    - "rake environment resque:work QUEUE=high"
    - "rake environment resque:work QUEUE=general"
    - "rake environment resque:work QUEUE=low_priority"
{% endhighlight %}

Procfile implementation:
{% highlight bash %}
worker_high: rake environment resque:work QUEUE=high
worker_general: rake environment resque:work QUEUE=general
worker_low: rake environment resque:work QUEUE=low_priority
{% endhighlight %}

You will then need to scale these workers to 1 at least (or more if you care about redundancy):

* using [Scalingo CLI]({% post_url /cli/2015-09-18-command-line-tool %}) **->**
  * `scalingo -a myapp scale worker_high:1`
  * `scalingo -a myapp scale worker_general:1`
  * `scalingo -a myapp scale worker_low:1`
* or using [Scalingo dashboard](https://my.scalingo.com/) **->** https://my.scalingo.com/apps/**my-app**/containers

Related link: [Ruby web server]({% post_url /languages/ruby/2015-06-23-web-server %}).

## Memcaching

On Shelly Cloud, each of your servers is running a Memcache server.  
On Scalingo, you can use Redis to fill the same purpose.
