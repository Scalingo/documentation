---
title: PHP - Automatic HTTPS redirection
modified_at: 2017-01-12 00:00:00
category: languages
tags: php, https, security, nginx
---

## Introduction

By default, applications are reachable with HTTP and HTTPS, but you may want to
redirect your users to the HTTPS URL only.  Our PHP deployment stack is using
Nginx and PHP-fpm to answer your application request.  The redirection can be
done thanks with your PHP code, or the Nginx configuration. This article explains
how to handle it with Nginx.

## Configuration

### Nginx configuration

Create a directory `config` in your project:

```bash
mkdir config
```

Edit the file `nginx-https-redirection.conf` in this directory with the following content:

```bash
add_header Strict-Transport-Security max-age=31536000;

if ($http_x_forwarded_proto != "https") {
    rewrite ^ https://$host$uri permanent;
}
```

The first lines adds the [HSTS
header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security)
to order browsers to only navigate this website with HTTPS.

The second instruction looks if the Scalingo [routing layer]({% post_url internals/2015-03-22-routing %}) has transfered a HTTP request or HTTPS request. If it's
not HTTPS, it redirects the user to HTTPS.

The last thing you have to do is to instruct Scalingo's deployment process to
use your configuration file.

### Deployment process configuration

This process requires you to edit the `composer.json` file of your project.
Edit the file the following way:

```javascript
{
  ...
  "extra": {
    "paas": {
      "nginx-includes": ["config/nginx-https-redirection.conf"]
    }
  }
}
```

If you are not using composer, create a composer.json file with the previous content, and also create
a file `composer.lock` containing an empty JSON string `{}`

> Tip: You can find more information about extra configuration in [the PHP support page]({% post_url languages/php/2014-07-02-php %}).

## Redeploy your app

```bash
git add composer.json composer.lock config/nginx-https-redirection.conf
git commit -m "setup https redirection and HSTS header"
git push scalingo master
```

That's it, your app will be HTTPS-only.
