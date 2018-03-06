---
title: PHP - Running database migrations with 'artisan'
modified_at: 2017-09-11 00:00:00
tags: php, artisan, laravel, migration
---

## Introduction

Artisan is the command-line interface included with Laravel. It provides a
number of helpful commands that can assist you while you build your
application.

Migrations are like version control for your database, allowing your team to
easily modify and share the application's database schema. Migrations are
typically paired with Laravel's schema builder to easily build your
application's database schema. If you have ever had to tell a teammate to
manually add a column to their local database schema, you've faced the problem
that database migrations solve.

## Scalingo MySQL Addon

A **Laravel** application requires a database, often a SQL database like MySQL
or PostgreSQL. This article will be using MySQL, but it should be identical with
a PostgreSQL database.

First, a [Scalingo MySQL addon]({% post_url
databases/2000-01-01-scalingo-mysql-addon %}) has to be added to your
application. This addon will inject the environment variable `SCALINGO_MYSQL_URL`
and its alias `DATABASE_URL`.

```bash
DATABASE_URL=mysql://user:pass@my-db.mysql.dbs.com:30000/my-db
```

To use this URL in your application, add at the top of your
`app/config/database.php` file the following lines. They decompose the URL into
the different fields and let you configure your application.

```
$url = parse_url(getenv("DATABASE_URL"));

$host = $url["host"];
$username = $url["user"];
$password = $url["pass"];
$database = substr($url["path"], 1);
```

Then find the `mysql` entry in the `database.php` file and modify it like:

```
    'mysql' => array(
        'driver'    => 'mysql',
        'host'      => $host,
        'database'  => $database,
        'username'  => $username,
        'password'  => $password,
        'charset'   => 'utf8',
        'collation' => 'utf8_unicode_ci',
        'prefix'    => '',
    ),
```

Now that your application database is configured, let's work on the migrations.

## First Migration

Creating a migration with **Laravel** is done with the following command on your
workstation.

```bash
./artisan make:migration create_plants
```

The file is created at the location `database/migrations/date_yourmigration`. Edit
it to write the content of the migration.

```php
public function up()
{
    Schema::create('plants', function($table) {
        $table->increments('id');
        $table->string('common_name', 100);
        $table->string('latin_name', 100);
        $table->text('description');
    });
}

public function down()
{
    Schema::drop('plants');
}
```

To run locally the migration to see if the syntax is right, run the following command:

```
./artisan migrate
```

If everything went well, add this file to your Git repository and deploy the
application on the platform. Once the application has been deployed, apply the
migration to your production database:

```bash
scalingo --app my-app run php artisan migrate
```

### What about the `down` method of the migration

For every migration file, a `down` method should be written in the case we want
to rollback database migrations:

```bash
scalingo --app my-app run php artisan migrate:rollback
```

## Another example: alter a database table.

The previous example created a 'table creation' migration, here is an example of
table alteration.

```php
public function up()
{
    Schema::table('plants', function($table) {
        $table->unique('latin_name', 'plants_unique_latin_name');
    });
}

public function down()
{
    Schema::table('authors', function($table) {
        $table->dropUnique('plants_unique_latin_name');
    });
}
```

As previously, running the migration on the hosted application once deployed:

```bash
scalingo --app my-app run php artisan migrate
```

For more examples, refer to [the official Laravel
documentation](https://laravel.com/docs/5.5/migrations).

## Apply migrations automatically after deployment

So far the action to apply migrations on the production database was manual. It
is possible to automate it by using [a postdeploy hook]({% post_url
app/2000-01-01-postdeploy-hook %}) All you have to do is to create a `Procfile`
file at the root of your project with the following content:

```
postdeploy: php artisan migrate
```

That's it! If a deployment is a success, the command applying migrations will
be automatically run.
