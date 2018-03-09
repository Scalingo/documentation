---
title: Filter IPs allowed to access your app
nav: IPs Filtering
modified_at: 2016-06-24 00:00:00
tags: php, http, security, filtering
---

## Introduction

Our PHP deployment stack is using Nginx and PHP-FPM to answer your application
request. You can setup IP addresses filtering to allow only some IP address to
access your application.

## Configuration

### Nginx configuration

Create a directory `config` in your project:

```bash
mkdir config
```

Edit the file `nginx-ips-filtering.conf` in this directory with the following
content:

```bash
location / {
    allow <ip1>;
    allow <ip2>;
    deny all;
}
```

Last thing you need to do is to instruct Scalingo's deployment process to use
your configuration file.

### Deployment process configuration

{% assign nginx-include = "config/nginx-ips-filtering.conf" %}
{% include nginx_includes.md %}

## Redeploy your app

```bash
git add composer.json composer.lock config/nginx-ips-filtering.conf
git commit -m "setup ip filtering"
git push scalingo master
```

That's it, only the specified IP addresses will be able to access your app.
