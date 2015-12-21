---
title: PHP - Deploying a Symfony 2 application
modified_at: 2015-12-21 00:00:00
category: languages
tags: php, http, framework, symfony, assetic, deployment
---

## Detection

When a PHP application is deployed we're looking at the file 'composer.json' to
know if it is using a particular framework. For Symfony 2, we're looking if the
project has contains the module 'symfony/symfony' as dependency.

{% highlight javascript %}
{
  "require": {
    "symfony/symfony": "~2.8",
    // ....
  }
}
{% endhighlight %}

During the deployment process you'll see the following output, mentionning that
the framework has correctly been detected.

{% highlight bash %}
-----> Detected Symfony2 App
...
-----> Setting up Symfony2 App
{% endhighlight %}

```


## Log files

By default we are getting the logs written on stdout and send them to our
log aggregator system. With PHP it's not working exactly the same way and
symfony is using its own log files to write its logs.

When a symfony application is detected, we'll automatically add the following
files to the output of your application, you've nothing to do, you'll be able
to see the content of these log files in your app dashboard.

* `app/logs/prod.log`
* `app/logs/dev.log`

## Cache warmup

During the deployment process you'll see the following output:

{% highlight bash %}
       Warmuping cache
{% endhighlight %}

It means that we are preparing the cache of your application to avoid
making it at runtime and loosing performance. Underneath, the following
command is executed at each deployment:

{% highlight bash %}
php app/console cache:warmup --env=prod --no-debug
{% endhighlight %}

## Asset management with Assetic

If you are using to handle your assets, you may need to run a custom command
once Symfony has been installed, to do so, you need to add the following piece
of configuration in your `composer.json`

{% highlight javascript %}
{
  // ...,
  "extra": {
    "paas": {
      "compile": [
        "php app/console assetic:dump --env=prod --no-debug"
      ]
    }
  }
}
{% endhighlight %}

This piece of configuration is defining that after installing symfony, the 'assetic:dump'
command will be executed preparing your assets for your application.
