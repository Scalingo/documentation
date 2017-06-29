---
title: PHP - Filter IPs allowed to access your app
modified_at: 2016-06-24 00:00:00
category: languages
tags: php, http, security, filtering
---

## Introduction

Our PHP deployment stack is using Nginx and PHP-fpm to answer your application request.
You can setup IPs filtering to allow only some IP to access your app.

## Configuration

### Nginx configuration

Create a directory `config` in your project:

```bash
mkdir config
```

Edit the file `nginx-ips-filtering.conf` in this directory with the following content:

```bash
location / {
    allow <ip1>;
    allow <ip2>;
    deny all;
}
```

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
      "nginx-includes": ["config/nginx-ips-filtering.conf"]
    }
  }
}
```

If you are not using composer, create a composer.json file with the previous content, and also create
a file `composer.lock` containing an empty JSON string `{}`

> Tip: You can find more information about extra configuration in [the PHP support page]({% post_url languages/php/2014-07-02-php %}).


## Redeploy your app

```bash
git add composer.json composer.lock config/nginx-ips-filtering.conf
git commit -m "setup ip filtering"
git push scalingo master
```

That's it, only the IPs you've specified will be able to access your app.
