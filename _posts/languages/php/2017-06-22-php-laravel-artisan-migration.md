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

Sources : http://laravel.sillo.org/laravel-4-chapitre-12-les-bases-de-donnees-1/

Usually, you can begin your with the installation of the migration. It is posible that this installation was already done in your project.
```php artisan migrate:install```

If you have some interogation about the writting of your commande, you can run ```php artisan``` to see what you can do. The section the most interessant was 'migrate:*'

First migration : 
```php artisan make:migration create_essences```

'create_essence' is the name of our migration that you can change.

We modifie the file where is the migration (/database/migrations/date_yourmigration) to express what we want to do :
```
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

Then, we execute the migration :
```php artisan migrate```

If you have some problem to do that, you have to check your file '.env' .


You must not forget to complete the section 'down' who serve to cancel your migration with the command : ```php artisan migrate:rollback```.

```public function down()
    {
        Schema::drop('essences');
    }```


Apparte: you can make the command ```php artisan migrate:rollback --step=5``` to cancelled the 5 last migration, or ```php artisan migrate:reset``` to come back at the beginning.


It is also possible to generate some data of exemple. You must create a file in the folder "/database/seeds/", we create : "/database/seeds/EssenceTableSeeder.php". Add the code :
```class EssenceTableSeeder extends Seeder {
 
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
 
}```


You must also change the file "/database/seeds/DatabaseSeeder.php" to add your class.
```class DatabaseSeeder extends Seeder {
 
    public function run()
    {
        $this->call('EssenceTableSeeder');
    }
 
}```


The command ```php artisan db:seed``` will actualise your database.


If there is a problem, please check that you have this at the beginning of your files : 
```<?php    use Illuminate\Database\Seeder;```


Now we know how to create a table. Let's see how we can modify it without rollback.

You can make a new migration with for example: 
```public function up()
{
    Schema::table('essences', function($table) {
        $table->unique('nom_latin', 'essences_nom_latin_unique');
    });
}```
```public function down()
{
    Schema::table('authors', function($table) {
        $table->dropUnique('essences_nom_latin_unique');
    });
}```

Don't forget the down, it is really important.
So let's
``` php artisan migrate```
