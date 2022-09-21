---
title: Getting Started with WordPress on Scalingo
modified_at: 2022-09-21 00:00:00
tags: php, http, framework, wordpress, deployment
index: 14
---

## Detection

When a PHP application is deployed, Scalingo checks the existence of
the `wp-settings.php` file at the root folder of your app.

During the deployment process, you'll see the following output
mentioning that the framework has correctly been detected:

```text
-----> Detected WordPress
-----> Setting up WordPress
...
```

Or for Bedrock WordPress:

```text
-----> Detected Bedrock WordPress
-----> Setting up Bedrock WordPress
...
```

## Bedrock: a Scalingo Friendly WordPress Boilerplate

WordPress is not well suited to be directly deployed on Scalingo. They do not follow the best modern practices
of web development such as [12 factor](https://12factor.net/).

The easiest way to get started with WordPress on Scalingo is to click on this button:

[![Deploy on
Scalingo](https://cdn.scalingo.com/deploy/button.svg)](https://my.osc-fr1.scalingo.com/deploy?source=https://github.com/Scalingo/scalingo-wordpress)

This one-click deploy button uses this [Scalingo Distribution](https://github.com/Scalingo/scalingo-wordpress).
It is based on [Bedrock](https://roots.io/bedrock/), and install everything for your WordPress
to work perfectly on a modern platform like Scalingo.

### Customize the Scalingo Distribution

You may need to customize a bit the above-mentioned distribution in order to add a plugin or a theme for instance.
Follow these instructions to get started:

1. Clone the distribution:

   ```bash
   git clone https://github.com/Scalingo/scalingo-wordpress
   cd scalingo-wordpress
   ```

2. Create the application on Scalingo

   Create the application through the dashboard with a MySQL addon or with the [Scalingo CLI](http://cli.scalingo.com):

   ```bash
   scalingo create my-app
   scalingo addons-add mysql mysql-sandbox
   ```

3. Create a S3 Bucket on AWS and configure IAM user correctly

   IAM user security policy example, with required actions:

   ```bash
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:PutObjectAclVersion",
            "s3:AbortMultipartUpload",
            "s3:ListBucket",
            "s3:GetObject"
          ],
          "Effect": "Allow",
          "Resource": "arn:aws:s3:::BUCKETNAME-HERE"
        },
        {
          "Action": [
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:PutObjectAclVersion",
            "s3:AbortMultipartUpload",
            "s3:ListBucket",
            "s3:GetObject"
          ],
          "Effect": "Allow",
          "Resource": "arn:aws:s3:::BUCKETNAME-HERE/*"
        }
      ]
    }
   ```

4. Update application environment variables

   Then, update your application environment through the dashboard or with the
   [Scalingo CLI](http://cli.scalingo.com) `scalingo env-set VARIABLE_NAME=VALUE`:

   * `DATABASE_URL`: Connection string to the MySQL database - `mysql://localhost:3306/wp-bedrock` - Automatically added with the Scalingo MySQL addon
   * `WP_ENV`: Set to environment (`development`, `staging`, `production`)
   * `WP_HOME`: Full URL to WordPress home (https://my-app.osc-fr1.scalingo.io)
   * `WP_SITEURL`: Full URL to WordPress including subdirectory (https://my-app.osc-fr1.scalingo.io/wp)
   * `S3_UPLOADS_BUCKET`: Name of the S3 bucket to upload files to
   * `S3_UPLOADS_KEY`: AWS Access Key ID for S3 authentication
   * `S3_UPLOADS_SECRET`: AWS Secret Key for S3 authentication
   * `S3_UPLOADS_REGION`: Region of the S3 bucket
   * `AUTH_KEY`, `SECURE_AUTH_KEY`, `LOGGED_IN_KEY`, `NONCE_KEY`, `AUTH_SALT`, `SECURE_AUTH_SALT`, `LOGGED_IN_SALT`, `NONCE_SALT`

   You can get some random salts on the [Roots WordPress Salt Generator](https://roots.io/salts.html).

5. Add themes in `web/app/themes` as you would for a normal WordPress site.

   ```bash
   # Optionally add theme to your git repository
   git add web/app/themes
   git commit -m "Add themes"
   ```

6. Add plugins using [Composer](https://getcomposer.org/) and [WordPress Packagist](https://wpackagist.org/search?q=&type=plugin&search=)

   Example to add the `Akismet` plugin:

   ```bash
   composer require --ignore-platform-reqs wpackagist-plugin/akismet
   ```

7. Deploy the application on Scalingo

   ```bash
   git push scalingo master
   ```

8. Access WP Admin at `https://my-app.osc-fr1.scalingo.io/wp/wp-admin`

9. Activate the `S3 Uploads` plugin on WP Admin plugins page and that's it.

## Deploying Pure WordPress on Scalingo

Even though it is not advised to deploy an out-of-the-box WordPress on Scalingo, there are some
situations where you do not have the choice. Here are a few things you must know before going down
that road.

### Configuration

By default WordPress uses a configuration file to configure a deployed
application. In order to add environment variables support, you must edit the
`config/application.php` file to read the `DATABASE_URL` environment variable.

This can be done by adding those lines:

```php
$mysql_url = parse_url($_ENV["DATABASE_URL"]);
$db = substr($mysql_url['path'], 1);
```

And changing the `DB_*` definitions to:

```php
Config::define('DB_NAME', $db);
Config::define('DB_USER', $mysql_url['user']);
Config::define('DB_PASSWORD', $mysql_url['pass']);
Config::define('DB_HOST', $mysql_url['host'] . ":" . $mysql_url['port']);
```

You must do the same things for all your salts and keys. We recommend using a
common environment variable and set it to a random string. You must adapt your
`config/application.php` to use this variable:

```php
$key = $_ENV["SECURE_KEY"];
Config::define('AUTH_KEY',         $key);
Config::define('SECURE_AUTH_KEY',  $key);
Config::define('LOGGED_IN_KEY',    $key);
Config::define('NONCE_KEY',        $key);
Config::define('AUTH_SALT',        $key);
Config::define('SECURE_AUTH_SALT', $key);
Config::define('LOGGED_IN_SALT',   $key);
Config::define('NONCE_SALT',       $key);
```

The only thing left is to define the `SECURE_KEY` from the dashboard or by
using our CLI:

```bash
scalingo --app my-app env-set SECURE_KEY=A_RANDOM_TOKEN_HERE
```

{% note %}
  You can generate a random token with the command: `openssl rand -hex 32`
{% endnote %}

### HTTPS

By default, WordPress tries to detect if the website is reached with HTTPS.
However in an environment like Scalingo, applications are behind a routing
layer which acts as proxy, which prevent WordPress to correctly detect the use
of HTTPS.

To fix this problem, you need to add the following in your `config/application.php` file
([official
documentation](https://developer.wordpress.org/reference/functions/is_ssl/)):

```php
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')
  $_SERVER['HTTPS'] = 'on';
```

Thanks to this snippet, WordPress will look at the HTTP header
`X-Forwarded-Proto` set by our router to 'http' or 'https' whether the website
is accessed with HTTP or HTTPS. Have a look at our [routing
documentation]({% post_url platform/internals/2000-01-01-routing %}) for more
information about this header.

### Plugins and Updates

Since the container file system is volatile, plugins and addon should be
installed and updated within your Git repository and never via the web
interface. You must de-activate auto-update of all your WordPress components.

To do that add the following line to your `config/application.php`:

```php
Config::define('AUTOMATIC_UPDATER_DISABLED', true);
```

### TLS Connection to MySQL

If you configured your MySQL with [Force TLS]({% post_url
databases/mysql/2000-01-01-start %}#force-tls-connections), it is mandatory
that your application connects to the database using TLS. With WordPress, you
need to add the following line in your `config/application.php`:

```php
Config::define('MYSQL_CLIENT_FLAGS', MYSQLI_CLIENT_SSL);
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
