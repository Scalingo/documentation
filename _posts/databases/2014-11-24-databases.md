---
title: About Databases
modified_at: 2014-11-24 00:00:00
category: databases
tags: index-databases polydbs
index: 0
---

You applications need databases to store your data. As we believe your data
should be located geographically close to your application servers we support
the most common types of database.

We ensure your database is located at the same location as your applications.
It provides the best performance and latency possible. Moreover you know where
your data are.

## Database types

### SQL

* PostgreSQL
* MySQL

### NoSQL

* MongoDB
* Redis
* Elasticsearch

## Provision a database

To provision a database for one of your app, the process is really simple:

1. Go on your [dashboard](https://my.scalingo.com/apps)
2. Click on the 'Addons' tab
3. Select the database type your need and the capacity you need
   <blockquote class="bg-info">
     The capacity of your database is elastic, you will be able to upgrade
     your addon later.
   </blockquote>
4. Click on the button 'Addon'

That's it, your database has been instantly provisionned. To get the
credentials to connect to it, go to the __environment__ tab of your app,
where you will find the connection chain named: `SCALINGO_<TYPE>_URL`

## Backups

If your database is in a paid plan (ie it's not in a "free plan") we'll make backups of your database on a daily basis around 1AM Central European Time (CET or UTC+0100), however we don't keep those backups forever. The following rules are applied:

* Everyday of 1 month
* One per week during the 2nd and 3rd months
* One per month during the 4th, 5th and 6th months
