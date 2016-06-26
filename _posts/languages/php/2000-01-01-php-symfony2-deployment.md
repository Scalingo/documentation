---
title: PHP - Deploying a Symfony 2 or Symfony 3 application
modified_at: 2016-06-27 00:25:00
category: languages
tags: php, http, framework, symfony, assetic, deployment
---

## Detection

When a PHP application is deployed, we're looking at the `composer.json` file to know if it is using a particular framework. For Symfony 2 and 3, we're looking if the Composer dependencies contain `symfony/symfony`. If so, your app is deployed as a Symfony application.

```javascript
{
  "require": {
    "symfony/symfony": "~2.8",
    // ....
  }
}
```

During the deployment process you'll see the following output, mentioning that the framework has correctly been detected.

```bash
-----> Detected Symfony2 App
...
-----> Setting up Symfony2 App
```

## Configuration

Symfony configuration is used to handle its configuration with different `.yml`
files.  However this is not always a good practice: especially when it concerns
credentials.  You don't want your production credentials being stored in a file
stored in your GIT repository.

The solution is to use environment variables to interpolate constants. Here is
an example of doctrine configuration yaml file:

```yml
doctrine:
    dbal:
        driver    pdo_mysql
        dbname:   symfony_project
        user:     '%database.user%'
        password: '%database.password%'
```

Note the values `%database.user%` and `%database.password%` they are constants
you can define from your environment:

```bash
SYMFONY__DATABASE__USER=database-user
SYMFONY__DATABASE__PASSWORD=database-secret
```

You will find more information in the [Symfony Documentation Center](https://symfony.com/doc/current/cookbook/configuration/external_parameters.html)

## Log files

By default, we are getting the logs written on stdout and send them to our log aggregator system. With PHP it's not working exactly the same way (since the standard output is what is sent back to the browser), and Symfony is using its own log files.

These files are named `var/logs/dev.log` and `var/logs/prod.log` (`app` instead of `var` in Symfony 2 applications) by default. The logs stored in those files are visible in the _Logs_ section of the dashboard.

## Cache warmup

Towards the end of the deployment process, you will see the following output:

```bash
Warmuping cache
```

It means that we are preparing the cache of your application, to avoid making it at runtime and loosing performance. Under the hood, the following command is executed (replace `app` with `bin` in Symfony 3):

```bash
app/console cache:warmup --env=prod --no-debug
```

By default, this command executes the default _cache warmers_ that the framework provides. You can add your own cache warmers: [learn more about Symfony's cache warmup here](http://blog.whiteoctober.co.uk/2014/02/25/symfony2-cache-warmup-explained/).

## Asset management with Assetic

If you are using Assetic to handle your assets, you may need to run a custom command once Symfony has been installed. To do so, you need to add the following piece of configuration in your `composer.json`:

```javascript
{
  // ...,
  "extra": {
    "paas": {
      "compile": [
        "php app/console assetic:dump --env=prod --no-debug"
      ]
    }
  }
}
```

This configuration node (`extra.paas.compile`) is defining that, after installing symfony, the 'assetic:dump'
command will be executed, preparing your assets for your application. Of course, you can add any other commands here!
