---
title: How to migrate from Heroku
tags: heroku tutorial
index: 11
---

Scalingo is a Platform as a Service [highly compatible with Heroku]({% post_url platform/getting-started/2000-01-01-heroku-compatibility %}). It's very easy to understand and you shouldn't have any problem migrating your app from Heroku to Scalingo.

It is so easy that you can use [heroku2scalingo](https://github.com/Scalingo/heroku2scalingo/releases/latest), a tool to migrate a Heroku app to Scalingo.

## heroku2scalingo

### Usage

```bash
./heroku2scalingo <herokuAppName>
```

It works by performing the following operations in the same order as below:

* Authentication to Scalingo
* Authentication to Heroku API
* Creation of Scalingo app
* Get/Set environment variables
* `git clone` your Heroku app repository
* `git push scalingo master` -> Auto-deployment using the `Procfile`

### Notes

Other advanced operations are planned, for more informations take a look at [the GitHub project](https://github.com/Scalingo/heroku2scalingo/#todo).

### Release

You can download the latest version by following this link : [https://github.com/Scalingo/heroku2scalingo/releases/latest](https://github.com/Scalingo/heroku2scalingo/releases/latest).

## Advanced apps migration

* The [Procfile]({% post_url platform/app/2000-01-01-procfile %}) can remain the same
* You need to set the same environment variables as the ones defined on your Heroku app
* You have to set your Scalingo addons according to the addons you had on your Heroku app.
  If you require an addon that is not present in [this list](https://scalingo.com/addons),
  feel free to [send us an email](mailto:support@scalingo.com).
* You will need to migrate any database manually, dumping it from Heroku and restoring it to Scalingo:
  * [Dump and restore a MongoDB database]({% post_url databases/mongodb/2000-01-01-dump-restore %})
  * [Dump and restore a PostgreSQL database]({% post_url databases/postgresql/2000-01-01-dump-restore %})
  * [Dump and restore a MySQL database]({% post_url databases/mysql/2000-01-01-dump-restore %})
