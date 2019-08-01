---
title: Access your MySQL database with Workbench
nav: MySQL Workbench
modified_at: 2019-08-01 00:00:00
tags: databases mysql workbench tunnel
index: 3
---

## Requirements

Databases hosted on Scalingo are not by default directly available on the
Internet. To access it, a solution is to setup an [encrypted tunnel]({% post_url
platform/databases/2000-01-01-access %}).

MySQL Workbench lets you configure this tunnel. We will guide through the steps
to configure the connection to a Scalingo hosted MySQL through an encrypted
tunnel.

## Configuration of MySQL

### Authentication

The connection data can be found from the `SCALINGO_MYSQL_URL` environment
variable of your application.

```
$ scalingo env | grep SCALINGO_MYSQL_URL
SCALINGO_MYSQL_URL=mysql://my_app_3030:CaUrq1MdUkAzCSEq-1Fg@my-app-3030.mysql.dbs.scalingo.com:30999/my_app_3030
```

In this case:

* Hostname: my-app-3030.mysql.dbs.scalingo.com
* Port: 30999
* User: my_app_3030
* Password: CaUrq1MdUkAzCSEq-1Fg
* Database: my_app_3030

You first need to select "Standard TCP/IP over SSH" as "Connection Method".
Then, fill the fields accordingly:

{% assign width = "450px" %}
{% assign img_url = "https://cdn.scalingo.com/documentation/mysql-workbench/connection_ssh_tunnel.png" %}
{% include mdl_img.html %}

The "Private key" to provide in the "SSH" tab is your private SSH key you
uploaded on your Scalingo profile.

The "SSH Hostname" and "SSH Port" depends on the region your database is
deployed on:

{% include ssh_urls.md %}
