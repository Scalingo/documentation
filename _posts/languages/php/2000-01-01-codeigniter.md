---
title: Deploying CodeIgniter on Scalingo
nav: CodeIgniter
modified_at: 2018-07-30 00:25:00
tags: php, http, framework, CodeIgniter, deployment
---

## Detection

When a PHP application is deployed, we're looking at the existence of a
`system/core/CodeIgniter.php` file to know if it is using a CodeIgniter.

During the deployment process you'll see the following output, mentioning that
the framework has correctly been detected.

```bash
-----> Detected CodeIgniter App
...
-----> Setting up CodeIgniter App
```

## Configuration

You need to configure a couple of files to use CodeIgniter on Scalingo. First modify
`application/config/config.php`:

```php
$config['base_url'] = 'https://test-code-igniter.scalingo.io/';
// …
$config['index_page'] = '';
// …
$config['uri_protocol']	= 'AUTO';
// …
$config['log_threshold'] = 1;
```

You probably also need to configure a SQL database. You first need to provision a new database such
as [MySQL]({% post_url databases/mysql/2000-01-01-start %}). Then configure CodeIgniter in
`application/config/database.php`:

```php
$url = parse_url(getenv('SCALINGO_MYSQL_URL'));
$active_group = 'production';
// ...
$db['production'] = array(
  'dsn'	=> getenv('SCALINGO_MYSQL_URL'),
  'hostname' => $url['host'] . ':' . $url['port'],
  'username' => $url['user'],
  'password' => $url['pass'],
  'database' => substr($url['path'], 1),
  'dbdriver' => 'mysqli',
  // …
  'db_debug' => (ENVIRONMENT !== 'production'),
  // …
);
```

## Log files

By default, we are getting the logs written on stdout and send them to our log aggregator system.
The PHP logging does not work the same way (since the standard output is what is sent back to the
browser), and CodeIgniter is using its own log files.

These files are named `application/logs/log-$(date).php` by default. Logs stored in those files are
visible in the _Logs_ section of the dashboard.
