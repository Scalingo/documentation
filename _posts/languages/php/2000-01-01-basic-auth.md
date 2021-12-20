---
title: Secure Your PHP App with HTTP Basic Auth
nav: Basic Auth
modified_at: 2021-10-28 00:00:00
tags: php http security basic-auth
---

## Introduction

Our PHP deployment stack is using Nginx and PHP-FPM to answer your application
request. If you want to setup basic authentication in front of your app or a part of
your app, there are two ways to do it.

Either you configure the authentication before your application reaches the PHP
code or you implement this in your application. Here is an example of the
latter [with Symfony](http://symfony.com/doc/current/book/security.html).

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

4. Create the couples user/encrypted password and set it on your Scalingo app:

    ```bash
    scalingo env-set --app my-app HTPASSWD_CONTENT=`htpasswd -n username`
    # Then a prompt will ask for the password
    ```

That’s it with the Nginx configuration. Last thing you need to do is to instruct Scalingo’s deployment process to use your configuration file.

### Deployment Process Configuration

This process requires you to edit the `composer.json` file of your project.
Edit the file the following way:

```json
{
  ...
  "extra": {
    "paas": {
      "compile": ["echo $HTPASSWD_CONTENT > config/htpasswd"],
      "nginx-includes": ["config/nginx-basic-auth.conf"]
    }
  }
}
```

If you are not using composer, create a `composer.json` file with the previous
content, and also create a file `composer.lock` containing an empty JSON
dictionary `{}`.

{% note %}
Tip: You can find more information about extra configuration in [the PHP
support page]({% post_url languages/php/2000-01-01-start %}).
{% endnote %}

## Redeploy Your App

```bash
git add config/nginx-basic-auth.conf config/htpasswd composer.json
git commit -m "setup basic auth"
git push scalingo master
```

That's it basic auth will be asked when connecting to the website.
