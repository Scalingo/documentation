---
title: Secure Your App with HTTP Basic Auth
nav: Basic Auth
modified_at: 2019-08-23 00:00:00
tags: php http security basic-auth
---

## Introduction

Our PHP deployment stack is using Nginx and PHP-FPM to answer your application
request. If you want to setup basic authentication in front of your app or a part of
your app, there are two ways to do it.

Either you configure the authentication before your application reaches the PHP
code or you implement this in your application. Here is an example of the
latter [with Symfony2](http://symfony.com/doc/current/book/security.html).

We present in this article how to configure the HTTP basic auth, independently
from your application.

## Configuration

### Nginx Configuration

Create a directory `config` in your project:

```bash
mkdir config
```

Edit the file `nginx-basic-auth.conf` in this directory with the following content:

1. For the complete website:

```nginx
auth_basic           "Protected Site";
auth_basic_user_file "/app/config/htpasswd";
```

2. Part of a website, here everything under `/wp-admin`:

```nginx
location ~ /wp-admin {
  auth_basic           "Protected Site";
  auth_basic_user_file "/app/config/htpasswd";
}
```

3. Depending on the hostname. Useful if you host a staging and a production
   application on Scalingo and just want to protect the staging application with
   basic auth:

```nginx
if ($host ~ "app-staging.osc-fr1.scalingo.io" ) {
    set $auth_basic "Protected Site";
}
if ($host ~ "app.osc-fr1.scalingo.io" ) {
    set $auth_basic off;
}
auth_basic $auth_basic;
auth_basic_user_file /app/config/htpasswd;
```

Create the `config/htpasswd` file with the couples user/encrypted password
using the following command:

```bash
htpasswd -c config/htpasswd username

# Then a prompt will ask for the password
```

That's it with those two files, Nginx will be able to ask for basic auth! Last
thing you need to do is to instruct Scalingo's deployment process to use your
configuration file.

### Deployment Process Configuration

{% assign nginx-include = "config/nginx-basic-auth.conf" %}
{% include nginx_includes.md %}

## Redeploy Your App

```bash
git add config/nginx-basic-auth.conf config/htpasswd composer.json
git commit -m "setup basic auth"
git push scalingo master
```

That's it basic auth will be asked when connecting to the website.
