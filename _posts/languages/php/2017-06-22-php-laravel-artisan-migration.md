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

Sources : `http://laravel.sillo.org/laravel-4-chapitre-12-les-bases-de-donnees-1/`

To begin, we can usually begin with the installation of the migration. It is posible that this installation was already done in your project.

```bash
php artisan migrate:install
```

If you have some interogation about the writting of your commande, you can run the following command to see what you can do. The section the most interessant was 'migrate:*'.

```bash
php artisan
```

Our first migration : 

```bash
php artisan make:migration create_essences
```

`create_essence` is the name of our migration.

After that, we have to modify the file where is the migration `/database/migrations/date_yourmigration` to express what we want to do.

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

Then, we execute the migration with artisan.
```bash
php artisan migrate
```

If you have some problem to do that, you have to check your file `.env`, it is possible that you don't have changed their parameters. 
You must not forget to complete the section `down` who are useful to cancel your migration. 

```php
public function down()
{
    Schema::drop('essences');
}
```

The command to cancel your migration :

```bash
php artisan migrate:rollback
```


In apparte: you can make another command to cancelled all the n last migration:

```bash
php artisan migrate:rollback --step=5
```

or there is a command tu come back at the beginnig of the migrations.

```bash
php artisan migrate:reset
```


It is also possible to generate some data to have an exemple. You must create a file in the folder `database/seeds/`, we create the file `/database/seeds/EssenceTableSeeder.php`. After that we add the code with data we want :

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

To actualise the database, run the command:

```bash
php artisan db:seed
```


If there is a problem, please check that you have this at the beginning of your files : 

```php 

use Illuminate\Database\Seeder;
```


Now we know how to create a table. Let's see how we can modify it without using `rollback`. You can make a new migration with for example: 

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
php artisan migrate
```
