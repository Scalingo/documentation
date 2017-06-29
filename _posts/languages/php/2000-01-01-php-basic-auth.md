---
title: PHP - Secure your app with HTTP Basic Auth
modified_at: 2016-06-24 00:00:00
category: languages
tags: php, http, security, basic-auth
permalink: /languages/php/basic-auth/
---

## Introduction

Our PHP deployment stack is using Nginx and PHP-fpm to answer your application request.
If you want to setup basic auth in front of your app or a part of your app, there are two ways to do it.

Either you implement this in your application, here is an [example with Symfony2](http://symfony.com/doc/current/book/security.html),
or you have to configure the authentication before your application reaches the PHP code.

This article deals with this second case, to configure the HTTP basic auth independantly from your app.

## Configuration

### Nginx configuration

Create a directory `config` in your project:

```bash
mkdir config
```

Edit the file `nginx-basic-auth.conf` in this directory with the following content:

For the complete website:

```bash
auth_basic           "Protected Site";
auth_basic_user_file "/app/config/htpasswd";
```

Part of a website, here everything under `/wp-admin`:

```bash
location ~ /wp-admin {
  auth_basic           "Protected Site";
  auth_basic_user_file "/app/config/htpasswd";
}
```

Create the `config/htpasswd` file with the couples user/encrypted password using the following command:

```bash
htpasswd -c config/htpasswd username

# Then a prompt will ask for the password
```

That's it with those two files, nginx will be able to ask for basic authentication, the last thing
you have to do is to instruct Scalingo's deployment process to use your configuration file.

### Deployment process configuration

This process requires you to edit the `composer.json` file of your project. Edit the file the following way:

```javascript
{
  ...
  "extra": {
    "paas": {
      "nginx-includes": ["config/nginx-basic-auth.conf"]
    }
  }
}
```

If you are not using composer, create a composer.json file with the previous content, and also create
a file `composer.lock` containing an empty JSON string `{}`

> Tip: You can find more information about extra configuration in [the PHP support page]({% post_url languages/php/2014-07-02-php %}).


## Redeploy your app

```bash
git add config/nginx-basic-auth.conf config/htpasswd composer.json
git commit -m "setup basic auth"
git push scalingo master
```

That's it basic auth will be asked when connecting to the website.
