---
title: Access your app environment
nav: Environment
modified_at: 2015-12-02 00:00:00
index: 5
tags: php, configuration, environment
---

## Context

The Scalingo model of configuration includes using the environment instead of
writing hard-coded configuration files which are handled in the source code
repository of a project. You can see and modify them from your
[dashboard](https://dashboard.scalingo.com) or with our [command line utility]({%
post_url platform/cli/2000-01-01-start %})

## Read a variable from the environment

To read an environment variable, you have to read from the
`$_ENV` associative array. For instance if you want to read the variable
`MONGO_URL`:

```php
$mongo_url_str = $_ENV["MONGO_URL"];
$mongo_url = parse_url($mongo_url_str);

/*
 * Then configure your app with
 *   Hostname:      $mongo_url.host
 *   Port:          $mongo_url.port
 *   Username:      $mongo_url.user
 *   Password:      $mongo_url.pass
 *   Database Name: substr($mongo_url.path, 1) after removing prefixed '/'
 */

```
