---
title: PHP - Deploying a WordPress application
modified_at: 2016-07-28 00:00:00
category: languages
tags: php, http, framework, wordpress, deployment
---

## Detection

When a PHP application is deployed, we're looking if the `wp-settings.php`
file is present on the root folder of your app.

During the deployment process you'll see the following output, mentioning
that the framework has correctly been detected.

```bash
-----> Detected WordPress
...
-----> Setting up WordPress
```

## Configuration

By default WordPress do not use configuration file.
To add environment variable support you must edit the `wp-config.php` file
to listen to the `DATABASE_URL` environment variable.

Eg:

```php
$mysql_url = parse_url($_ENV["DATABASE_URL"]);
$db = substr($mysql_url['path'], 1);

define('DB_NAME', $db);
define('DB_USER', $mysql_url['user']);
define('DB_PASSWORD', $mysql_url['pass']);
define('DB_HOST', $mysql_url['host'] . ":" . $mysql_url['port']);
```

You must do the same things for all your salts and key.
We recommend using a common environment variable and set it to a random string.
So you must adapt your `wp-config.php` to use this variable.

```php
$key = $_ENV["SECURE_KEY"];
define('AUTH_KEY',         $key);
define('SECURE_AUTH_KEY',  $key);
define('LOGGED_IN_KEY',    $key);
define('NONCE_KEY',        $key);
define('AUTH_SALT',        $key);
define('SECURE_AUTH_SALT', $key);
define('LOGGED_IN_SALT',   $key);
define('NONCE_SALT',       $key);
```

The only thing left is to define the `SECURE_KEY` from the dashboard or by
using our CLI:

```bash
scalingo -a myapp env-set SECURE_KEY A_RANDOM_TOKEN_HERE
```

> You can generate a random token with the command: `openssl rand -hex 32`

## Plugins and updates

Since the container filesystem is volatile, plugins and addon should
be installed and updated within your git repository and never via
the web interface. You must de-activate autoupdate of all
your WordPress components.

To do that just add the following line to your `wp-config.php`

```php
define( 'AUTOMATIC_UPDATER_DISABLED', true );
```

## Uploads

The container filesystem is volatile and not synchronised through
all your instances. So the uploads should not be stored on
the filesystem itself. We recommend using an external service like amazon s3
to store them.
