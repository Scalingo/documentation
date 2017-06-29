---
title: PHP - How to run migration with artisan in a postdeploy hook
modified_at: 2017-06-22 00:00:00
category: languages
tags: php, artisan, laravel, migration
permalink: /languages/php/migration/
---

## Introduction

Artisan is the command-line interface included with Laravel. It provides a number of helpful commands that can assist you while you build your application.
Migrations are like version control for your database, allowing your team to easily modify and share the application's database schema. Migrations are typically paired with Laravel's schema builder to easily build your application's database schema. If you have ever had to tell a teammate to manually add a column to their local database schema, you've faced the problem that database migrations solve.

## Addons Scalingo MySQL

If you use `artisan` on `Laravel`, you must have a database. We are going to see the method with the addon Scalingo MySQL. Once the addon selected, your application environment change, see ([our documentation](http://doc.scalingo.com/databases/scalingo-mysql-addon.html)).

We can decompose the url of your database in environment like that : 

```bash
mysql://user:pass@my-db.mysql.dbs.com:30000/my-db
```

There are two ways to use it.
Your can decompose these URL in your scalingo environment :

```bash
DB_DATABASE=my-db
DB_HOST=my-db.mysql.dbs.com
DB_PASSWORD=pass
DB_PORT=30000
DB_USERNAME=user
```

Or you can use a parse fonction in your code :

```php
$url = parse_url(getenv("DATABASE_URL"));
$host = $url["host"];
$username = $url["user"];
$password = $url["pass"];
$database = substr($url["path"], 1);
```

## Begin with artisan

To begin, we can usually run the installation of the migration. It is posible that this installation was already done in your project.

```bash
scalingo -a your_app run php artisan migrate:install
```

If you have some interogation about the writting of your command, you can run the following command to see what you have to do. The section the most important is 'migrate:*'.

```bash
scalingo -a your_app run php artisan
```

## Migration

Our first migration : 

```bash
scalingo -a your_app run php artisan make:migration create_essences
```

You can also run this commande without scalingo : `php artisan make:migration create_essences`, as many following command, but don't forget to push the result with `git`.
`create_essence` is the name of our migration that you can change.

Our first migration is create but don't make anything for the moment. We have to modify the file created `/database/migrations/date_yourmigration` to express what we want to do. For us, it will be the file `/database/migrations/date_create_essences`.

```php
public function up()
{
    Schema::create('essences', function($table) {
        $table->increments('id');
        $table->string('nom_vulgaire', 100);
        $table->string('nom_latin', 100);
        $table->text('description');
    });
}
```

We have set our type of data. Then, we execute the migration with artisan.

```bash
scalingo -a your_app run php artisan migrate
```

For every migration file, we have to complete the section down too. Here it would be :

```php
public function down()
{
    Schema::drop('essences');
}
```

This is really important to have the posibility to cancel our migration with the command `migrate:rollback`.

```bash
scalingo -a your_app run php artisan migrate:rollback
```


In apparte: you can make another command to cancelled all the n last migration:

```bash
scalingo -a your_app run php artisan migrate:rollback --step=5
```

or there is a command tu come back at the beginnig of the migrations, but also delete all our data saved.

```bash
php artisan migrate:reset
```

## Generate some data

It is also possible to generate some data to have an exemple in our database. You must create a file in the folder `database/seeds/`, we create the file `/database/seeds/EssenceTableSeeder.php`. We put in that file the data we want to insere :

```php
class EssenceTableSeeder extends Seeder {
 
    public function run()
    {
        DB::table('essences')->insert(
 
            array(
                array(
                    'nom_vulgaire' => 'Basilic exotique',
                    'nom_latin' => 'Ocimum basilicum ssp basilicum',
                    'description' => 'Cette huile essentielle est antibactérienne...'
                ),
 
                array(
                    'nom_vulgaire' => 'Bergamotier',
                    'nom_latin' => 'Citrus bergamia',
                    'description' => 'Cette huile essentielle est...'
                )
            )
 
        );
    }
 
}
```


To introduce our modifications, we have also to change the file `/database/seeds/DatabaseSeeder.php`.

```php
class DatabaseSeeder extends Seeder {
 
    public function run()
    {
        $this->call('EssenceTableSeeder');
    }
 
}
```

Then, to actualise the database, run the command:

```bash
scalingo -a your_app run php artisan db:seed
```


If there is a problem, please check that you have this at the beginning of your files : 

```php 
use Illuminate\Database\Seeder;
```

## Modify Database

Now we know how to create a table. Let's see how we can modify it without using `rollback`. You can make a new migration. Put for example: 

```php
public function up()
{
    Schema::table('essences', function($table) {
        $table->unique('nom_latin', 'essences_nom_latin_unique');
    });
}
```

and

```php
public function down()
{
    Schema::table('authors', function($table) {
        $table->dropUnique('essences_nom_latin_unique');
    });
}
```

Don't forget the down partie, it is really important. So let's migrate all of this:

```bash
scalingo -a your_app run php artisan migrate
```

## Conclusion

The fonctionment of artisan is quite the same as in a local project PHP. You only need to add `scalingo -a your_app run` before every command. Keep on mind you have to commit too.
