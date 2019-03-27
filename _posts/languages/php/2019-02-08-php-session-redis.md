---
title: PHP Session with Redis
nav: Session with Redis
modified_at: 2019-03-22 00:00:00
tags: php redis
---

When deploying a PHP application on Scalingo, you should favor best practices which let you
horizontally scale your application. One of these practices is about PHP session.

## Issue with Default PHP Sessions

Out of the box, PHP sessions are stored on the filesystem. If you scale your application with
multiple containers, the PHP session will be local to one of the container. For instance, in the
typical case of an authenticated page, one request out of two will display the user as logged in.
The other requests will display the user as logged out. Moreover, after each restart or each
deployment, the sessions would be lost as new containers start with a fresh filesystem.

## Solutions

One of the solution could be to store the session in a cookie (with encryption to prevent the user
from modifying it). An other one is to store the session in a database. [Redis]({% post_url
databases/redis/2000-01-01-start %}) is especially suitable in such case.

{% note %}
Some PHP framework ease the process of using session in a database. It might be
interesting to take a look at your framework documentation. Here is an example
with the Laravel framework: [Laravel
documentation](https://laravel.com/docs/5.8/session).
{% endnote %}

On Scalingo, the PHP Redis extension is available. Activate it by modifying the `composer.json`
with:

```json
{
  // …
  "require": {
    "ext-redis": "*"
  }
}
```

Then, configure PHP to use the Redis session handler. Once again, modify the `composer.json` with:

```json
{
  // …
  "extra: {
    "paas": {
      "php-config": [
        "session.save_handler = redis",
        "session.save_path = 'tcp://host:port?auth=password'"
      ]
    }
  }
}
```

Customize the `session.save_path` value with the content of the `SCALINGO_REDIS_URL` environment
variable of your application. More information is available on the [official
repository](https://github.com/phpredis/phpredis/#php-session-handler).

Finally, redeploy your application. It is now handling PHP session through the Redis database!
