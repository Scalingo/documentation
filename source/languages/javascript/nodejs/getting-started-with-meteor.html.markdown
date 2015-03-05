---
title: Getting Started with Meteor
category: languages
date: 09/02/2015
tags: programming, dev, nodejs, language, meteor, tutorial
---

# Getting started with Meteor

<blockquote class="info">
  All the operation achieved with the <a href="http://cli.scalingo.com">'scalingo' CLI</a> can also be done on our <a href="https://my.scalingo.com">web dashbaord</a>.
</blockquote>

## Initialize your application

```bash
# Install meteor
$ curl https://install.meteor.com | /bin/sh

# Create your app
$ meteor create meteor-app
$ cd meteor-app

# Add everything in the GIT repository
$ git init .
$ git commit -m "Init meteor application"
```

## Create your application and provision a MongoDB database

The meteor framework uses extensively MongoDB as a datastore,
so you need an available instance for you application.

```
$ scalingo create meteor-app
Git repository detected: remote scalingo added
→ 'git push scalingo master' to deploy your app

$ scalingo -a meteor-app addons-add scalingo-mongodb free
-----> Addon scalingo-mongodb has been provisionned
       ID: meteor-app-7247
       Modified variables: [MONGO_URL SCALINGO_MONGO_URL]
       Message from addon provider: Database successfully created
```

## Deploy your application!

```bash
$ git push scalingo master
```

## Access your application

```
…
Waiting for your application to boot... 
<-- https://meteor-app.scalingo.io -->
```

Now you can have fun with meteor and all its real-time feature. Of course, we support websocket!
