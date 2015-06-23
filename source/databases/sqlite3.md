---
title: SQLite on Scalingo
category: databases
date: 23/06/2015
tags: databases, sqlite
---

# SQLite on Scalingo

## Introduction

Different technologies, especially Ruby on rails are using the database SQLite
by default. SQLite is perfect for getting started in your project, it's lightweight,
requires no configuration and is backed by small files on disks. While it's a good
way to start, it is not usable in production.

## Limitations of SQLite

### Disk backed storage

SQLite writes files locally on disk. This way to do does not fit Scalingo model.
In our Platform as a Service definition, you application should be restartable at any
moment and should consider its local file system as ephemeral. As a result, when you redeploy
your application or if your application is restarted, SQLite data would be lost.

### Does not scale

It's a consequence of the previous point. As data are stored locally, the database is not
accessible through the network. When you will scale out your application, the different
containers won't be able to access the same data. So even if the disks were persistent,
SQLite would not be a good fit.

## Solutions

Instead of using Sqlite, you have to use on of our ['Database as a Service' addons](https://scalingo.com/addons)

* MongoDB
* PostgreSQL
* MySQL
