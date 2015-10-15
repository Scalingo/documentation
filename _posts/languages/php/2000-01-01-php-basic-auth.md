---
title: PHP: Secure your app with HTTP Basic Auth
modified_at: 2015-10-15 00:00:00
category: languages
tags: php, http, security, basic-auth
index: 6
permalink: /languages/php/basic-auth/
show_in_toc: true
---

# Secure your app with HTTP Basic Auth

## Introduction

Our PHP deployment stack is using Nginx and PHP-fpm to answer your application request.
If you want to setup basic auth in front of your app, there are two ways to do it.

Either you implement this in your application, here is an [example with Symfony2](http://symfony.com/doc/current/book/security.html),
or you have to configure the authentication before your application reaches the PHP code.

This article deals with this second case, to configure the HTTP basic auth independantly from your app.

## Configuration

### Nginx configuration

Create a directory `config` in your project:

{% highlight bash %}
mkdir config
{% endhighlight %>}

Edit the file `nginx-basic-auth.conf` in this directory with the following content:

{% highlight bash %}
location / {
    auth_basic           "Protected Site";
    auth_basic_user_file "/app/config/htpasswd;
}
{% endhighlight %>}

Create the `config/htpasswd` file with the couples user/encrypted password using the following command:

{% highlight bash %}
htpasswd -c config/htpassword username

# Then a prompt will ask for the password
{% endhighlight %>}

That's it with those two files, nginx will be able to ask for basic authentication, the last thing
you have to do is to instruct Scalingo's deployment process to use your configuration file.

### Deployment process configuration

This process requires you to edit the `composer.json` file of your project. Edit the file the following way:

{% highlight javascript %}
{
  ...
  "extra": {
    "paas": {
      "nginx-includes": ["config/nginx-basic-auth.conf"]
    }
  }
}
{% endhighlight %>}

> Tip: You can find more information about extra configuration in [the buildpack configuration page](%{ post_url /languages/php/2014-07-07-buildpack }).


## Redeploy your app

{% highlight bash %}
git add config/nginx-basic-auth.conf config/htpassword composer.json
git commit -m "setup basic auth"
git push scalingo master
{% endhighlight %>}

That's it basic auth will be asked when connecting to the website.
