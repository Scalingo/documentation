---
title: Deploying WordPress on Scalingo
nav: Wordpress
modified_at: 2016-07-28 00:00:00
tags: php, http, framework, wordpress, deployment
index: 99
---

## Detection

When a PHP application is deployed, we're looking if the `wp-settings.php` file
is present at the root folder of your app.

During the deployment process you'll see the following output, mentioning that
the framework has correctly been detected.

```bash
-----> Detected WordPress
...
-----> Setting up WordPress
```

## Configuration

By default WordPress use configuration file to configure a deployed
application. In order to add environment variable support, you must edit the
`wp-config.php` file to read the `DATABASE_URL` environment variable.

Example:

```php
$mysql_url = parse_url($_ENV["DATABASE_URL"]);
$db = substr($mysql_url['path'], 1);

define('DB_NAME', $db);
define('DB_USER', $mysql_url['user']);
define('DB_PASSWORD', $mysql_url['pass']);
define('DB_HOST', $mysql_url['host'] . ":" . $mysql_url['port']);
```

You must do the same things for all your salts and keys. We recommend using a
common environment variable and set it to a random string. You must adapt your
`wp-config.php` to use this variable:

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

{% note %}
  You can generate a random token with the command: `openssl rand -hex 32`
{% endnote %}

### HTTPS

By default, WordPress tries to detect if the website is reached with HTTPS.
However in an environment like Scalingo, applications are behind a routing
layer which acts as proxy, which prevent WordPress to correctly detect the use
of HTTPS.

To fix this problem, you need to add the following in your `wp-config.php` file
([official
documentation](https://codex.wordpress.org/Function_Reference/is_ssl#Notes)):

```php
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')
    $_SERVER['HTTPS'] = 'on';
```

Thanks to this snippet, WordPress will look at the HTTP header
`X-Forwarded-Proto` set by our router to 'http' or 'https' whether the website
is accessed with HTTP or HTTPS. Have a look at our [routing
documentation]({% post_url platform/internals/2000-01-01-routing %}) for more
information about this header.

## Plugins and updates

Since the container file system is volatile, plugins and addon should be
installed and updated within your Git repository and never via the web
interface. You must de-activate auto-update of all your WordPress components.

To do that just add the following line to your `wp-config.php`

```php
define( 'AUTOMATIC_UPDATER_DISABLED', true );
```

## Uploads

The container file system is volatile and not synchronized through all your
instances. So the uploads should not be stored on the file system itself. We
recommend using an external service like the Amazon service: AWS S3 to store
them.

You may want to have a look at a plugin such as [S3
Uploads](https://github.com/humanmade/S3-Uploads) to ease the storage of your
uploads on S3. As usual, this plugin must be downloaded locally and pushed to
our Git repository, never via the web interface.
