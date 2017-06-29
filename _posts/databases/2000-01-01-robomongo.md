---
title: Access your MongoDB database with Robomongo
modified_at: 2016-04-20 00:00:00
category: databases
tags: databases mongodb robomongo tunnel
---

## Requirements

Databases hosted on Scalingo are not directly available on the Internet. By default
access to most databases are unencrypted, so unsecure. Applications are on the same
network than your database, but you can not connect your machine to it directly.

It is possible to use Robomongo, but you have to setup an encrypted tunnel to your
database thanks to our [Command line utility]({% post_url cli/2015-09-18-command-line-tool %})

→ How-to: [build an uncrypted tunnel to your database]({% post_url databases/2014-11-24-tunnel %})

## Configuration of Robomongo

### Connection

As the tunnel is running, we are connecting to it, which is then a local connection:

{% assign width = "450px" %}
{% assign img_url = "https://cdn.scalingo.com/documentation/robomongo/20160420-robomongo-connection.png" %}
{% include mdl_img.html %}

### Authentication

The connection data can be found from the `MONGO_URL` environment variable of your env:

```
$ scalingo env | grep MONGO_URL
MONGO_URL=mongodb://test-1234:EsEjseivpacatVoogfijbiapgadTyg@test-1234.mongodb.dbs.scalingo.com/test-1234
```

In this case:

* User: test-1234
* Password: EsEjseivpacatVoogfijbiapgadTyg
* Database: test-1234

Fill the fields accordingly:

{% assign img_url = "https://cdn.scalingo.com/documentation/robomongo/20160805-robomongo-authentication.png" %}
{% include mdl_img.html %}

### Advanced

As your user doesn't not have the permission to list the databases, you have to specify the name of your
database.

{% assign img_url = "https://cdn.scalingo.com/documentation/robomongo/20160420-robomongo-advanced.png" %}
{% include mdl_img.html %}

### Connect

Validate the configuration and click on connect, that's it.

{% assign width = "720px" %}
{% assign img_url = "https://cdn.scalingo.com/documentation/robomongo/20150420-robomongo-allok.png" %}
{% include mdl_img.html %}
