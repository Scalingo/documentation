---
title: PHP - Deploying a WordPress application
modified_at: 2016-07-28 00:00:00
category: php
tags: php, http, framework, wordpress, deployment languages
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

### HTTPS

By default, WordPress tries to detect if the website is reached with HTTPS, however in an environment like Scalingo, applications are behind a routing layer which acts as proxy, so by default WordPress won't detect it.

To fix this problem, you need to add the following in your `wp-config.php` file ([official documentation](https://codex.wordpress.org/Function_Reference/is_ssl#Notes)):

```php
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')
    $_SERVER['HTTPS'] = 'on';
```

Thanks to this snippet, WordPress will look at the HTTP header `X-Forwarded-Proto` set by our router to 'http' or 'https' whether the website is access with HTTP or HTTPS, have a look at our [routing documentation](http://doc.scalingo.com/internals/routing.html) for more information about this header.

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
the filesystem itself. We recommend using an external service like the
Amazon service: AWS S3 to store them.

You may want to have a look at a plugin such as 
[S3 Uploads](https://github.com/humanmade/S3-Uploads) to ease the storage 
of your uploads on S3. As usual, this plugin must be downloaded locally 
and pushed to our git repository, never via the web interface.
