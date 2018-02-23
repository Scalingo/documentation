---
title: Getting Started with PHP
modified_at: 2018-02-23 00:00:00
category: getting-started
tags: follow-the-light php
---

This tutorial will help you deploying a Go application in a few minutes. We will
also guide you through the different features Scalingo offers.

## Prerequisites

This tutorial assumes that you:

- created a [Scalingo account](https://scalingo.com/users/signup)
- followed the [First Steps]({% post_url getting-started/2015-06-02-first-steps
%}) guide to setup Git and SSH
- installed the [command line interface tool]({% post_url
cli/2015-09-18-command-line-tool %})

## Deploy an Application

### Prepare the Application Code

Let's start by getting an sample application code. First clone the repository of
the sample:

```bash
$ git clone https://github.com/Scalingo/sample-php-base.git
$ cd sample-php-base
```

You now have locally a functional Git repository that contains a simple PHP
application. Note the presence of a `composer.json` file at the root of the
project. Scalingo uses Composer for dependency management in PHP application.
The `composer.json` file also indicates to Scalingo that your application is
written in PHP.

The rest of the tutorial assumes that you are located in this `sample-php-base`
folder.

### Deploy the Application

In this step we will deploy the application on Scalingo to get it up and
running.

Create the app on Scalingo with:

```bash
$ scalingo create my-app
App 'my-app' has been created
Git repository detected: remote scalingo added
→ 'git push scalingo master' to deploy your app
```

When you create an app, a Git remote (called `scalingo`) is also created and
associated with your local Git repository.

Deploy the application with:

```bash
$ git push scalingo master
Counting objects: 13, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (9/9), done.
Writing objects: 100% (13/13), 1.29 KiB | 1.29 MiB/s, done.
Total 13 (delta 0), reused 13 (delta 0)
 <-- Start deployment of my-app -->
-----> Technology detected: PHP (composer.json)
-----> Bundling NGINX 1.10.1
-----> Bundling PHP 5.6.33
-----> Bundling extensions
       apcu
       phpredis
       mongodb
-----> Vendoring Composer
       Updating Composer
Updating to version ef46a8afa4f5d845befbc7be832432c4b30d6313.
    Downloading: 100%
Use composer self-update --rollback to return to version 921b3a0eba139820716f7aeefb553197c14656d8
-----> Installing application dependencies with Composer
Loading composer repositories with package information
Updating dependencies
Nothing to install or update
Generating optimized autoload files
-----> Setting up default configuration
-----> Vendoring binaries into slug
 Build complete, shipping your container...
 Waiting for your application to boot...
 <-- https://my-app.scalingo.io -->
To scalingo.com:my-app.git
 * [new branch]      master -> master
```

The application is now available online at [https://my-app.scalingo.io](https://my-app.scalingo.io).

## Logs

Your application generates logs readable with:

```text
$ scalingo logs
2018-02-23 16:46:15.402816225 +0100 CET [manager] container [web-1] (5a903746b8c6f1345e816352) started
2018-02-23 16:46:15.486461871 +0100 CET [web-1] Optimzing defaults for M container...
2018-02-23 16:46:15.520436746 +0100 CET [web-1] 4 processes at 196MB memory limit.
2018-02-23 16:46:15.580951966 +0100 CET [web-1] [23-Feb-2018 15:46:15] NOTICE: [pool web] pm.start_servers is not set. It's been set to 1.
2018-02-23 16:46:15.580957534 +0100 CET [web-1] [23-Feb-2018 15:46:15] NOTICE: [pool web] 'user' directive is ignored when FPM is not running as root
2018-02-23 16:46:16.527441714 +0100 CET [web-1] [23-Feb-2018 15:46:15] NOTICE: [pool web] pm.start_servers is not set. It's been set to 1.
2018-02-23 16:46:16.527446966 +0100 CET [web-1] [23-Feb-2018 15:46:15] NOTICE: [pool web] 'user' directive is ignored when FPM is not running as root
2018-02-23 16:46:16.527448255 +0100 CET [web-1] [23-Feb-2018 15:46:15] NOTICE: fpm is running, pid 33
2018-02-23 16:46:16.527448717 +0100 CET [web-1] [23-Feb-2018 15:46:15] NOTICE: ready to handle connections
```

Access the application once using a web browser and you will get a new line of
logs:

```
2018-02-23 16:47:52.536015907 +0100 CET [web-1] 90.63.216.93 - "GET / HTTP/1.1" 200 24989 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0"
```

## Scale

By default, the application runs on a single container.

You can check the number of containers running your application with:

```bash
$ scalingo ps
+------+--------+------+---------+
| NAME | AMOUNT | SIZE | COMMAND |
+------+--------+------+---------+
| web  | 1      | M    | -       |
+------+--------+------+---------+
```

If redundancy is important or if a high traffic is expected, scale the
application to use more containers. For instance, scale the application to use
three containers with:

```bash
$ scalingo scale web:3
Your application is being scaled to:
  web: 3 - M
Status: Done in 8.177 seconds
Your application has been scaled.
```

You can also check the application usage to better understand whether it is
important to scale or not with:

```
$ scalingo stats
+-------+-----+-----------------+----------------+
| NAME  | CPU |     MEMORY      |      SWAP      |
+-------+-----+-----------------+----------------+
| web-1 | 0%  | 4%  24MB/512MB  | 0%   0B/512MB  |
|       |     | Highest:  25MB  | Highest:   0B  |
|       |     |                 |                |
| web-2 | 0%  | 4%  24MB/512MB  | 0%   0B/512MB  |
|       |     | Highest:  25MB  | Highest:   0B  |
|       |     |                 |                |
| web-3 | 0%  | 4%  24MB/512MB  | 0%   0B/512MB  |
|       |     | Highest:  24MB  | Highest:   0B  |
+-------+-----+-----------------+----------------+
```

More information on the when and why to scale [on the dedicated page]({%
post_url app/2000-01-01-scaling %}).

## Deploy Modification of an App

In this step, we will see how to modify an application, and reflect your local
modification on the Scalingo application. We will add a dependency to
[Cowsay](https://github.com/alrik11es/cowsayphp), and modify the application to
use it.

First add the dependency with:

```bash
$ composer require alrik11es/cowsayphp
Using version ^1.2 for alrik11es/cowsayphp
./composer.json has been updated
Loading composer repositories with package information
Updating dependencies (including require-dev)
Package operations: 1 install, 0 updates, 0 removals
  - Installing alrik11es/cowsayphp (1.2.0): Downloading (100%)
Writing lock file
Generating autoload files
```

And replace the content of `index.php` to use this library:

```php
<?php
require_once __DIR__.'/vendor/autoload.php';

use Cowsayphp\Farm;
$whale = Farm::create(\Cowsayphp\Farm\Whale::class);
echo '<pre>'.$whale->say("Hi there!").'</pre>';
```

Commit your changes with:

```bash
$ git commit --all --message "Add Cowsay"
```

Now deploy to Scalingo, just as you did previously:

```bash
$ git push scalingo master
```

## Further Reading

- Addons
- One-off
- Configuration through the environment
- Automatic deployment with GitHub
- Procfile

