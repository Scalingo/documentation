---
title: Deployment of a Meteor application - Telescope
nav: Deployment of Telescope
tags: nodejs meteor tutorial telescope
---

This guide will go through the deployment of a un-modified instance of Telescope,
but if you've applied some modifications to it, it should work the same manner.

{% note %}
  All the operations achieved with the <a href="http://cli.scalingo.com">'scalingo' CLI</a> can also be done on our <a href="https://my.scalingo.com">web dashbaord</a>.
{% endnote %}

{% include info_tutorial_requirements.md %}

## Clone the Telescope Project

The first thing to do, if you haven't done it, is to get the code of Telescope:

```bash
$ git clone https://github.com/TelescopeJS/Telescope
$ cd Telescope
```

## Create an application on Scalingo

```bash
$ scalingo create my-app
Git repository detected: remote scalingo added
→ 'git push scalingo master' to deploy your app
```

## Allocate a MongoDB database

The Meteor framework uses extensively MongoDB as a database. Hence you need to
provision a new instance of this database to your application.

```bash
$ scalingo -a my-app addons-add mongodb mongo-sandbox
-----> Addon mongodb has been provisionned
       ID: my-app-1234
       Modified variables: [MONGO_URL SCALINGO_MONGO_URL]
       Message from addon provider: Database successfully created
```

## Deploy your Telescope

```bash
$ git push scalingo master
```

## Access your application

At the end of the deployment process, an URL is returned, you application is now live.

```bash
…
Waiting for your application to boot...
<-- https://my-app.scalingo.io -->
```
