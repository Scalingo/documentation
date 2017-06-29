---
title: How to migrate from Heroku
modified_at: 2015-10-14 17:21:00
category: getting-started
tags: heroku tutorial
permalink: /how-to-migrate-from-heroku/
---

Scalingo is a Platform as a Service [highly compatible with Heroku]({% post_url getting-started/2015-09-17-heroku-compatibility %}). It's very easy to understand and you shouldn't have any problem migrating your app from Heroku to Scalingo. <br>

It is so easy that you can use [heroku2scalingo](https://github.com/Scalingo/heroku2scalingo/releases/latest), a tool to migrate a simple Heroku app to Scalingo.

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
* `git clone` your heroku app repository
* `git push scalingo master` -> Auto-deployment using the `Procfile`

### Notes

Other advanced operations are planned, for more informations take a look at [the github project](https://github.com/Scalingo/heroku2scalingo/#todo).

### Release

You can download the latest version by following this link : [https://github.com/Scalingo/heroku2scalingo/releases/latest](https://github.com/Scalingo/heroku2scalingo/releases/latest).

## Advanced apps migration

* The [Procfile]({% post_url internals/2014-12-01-procfile %}) can remain the same
* You need to set the same environment variables as the ones defined on your Heroku app
* You have to set your Scalingo addons according to the addons you had on your Heroku app.
  If you require an addon that is not present in [this list](https://scalingo.com/addons),
  feel free to [send us an email](mailto:support@scalingo.com).
* You will need to migrate any database manually, dumping it from Heroku and restoring it to Scalingo:
  * [Dump and restore a MongoDB database]({% post_url databases/2015-09-30-dump-restore-mongodb %})
  * [Dump and restore a PostgreSQL database]({% post_url databases/2015-10-01-dump-restore-postgresql %})
  * [Dump and restore a MySQL database]({% post_url databases/2015-10-01-dump-restore-mysql %})
