---
title: Getting Started with Meteor
category: languages
date: 09/02/2015
tags: programming, dev, nodejs, language, meteor, tutorial
---

# Getting started with Meteor

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

## Provision a MongoDB database

The meteor framework uses extensively MongoDB as a datastore,
so you need an available instance for you application.

* Go on the [dashboard](https://my.scalingo.com/apps) of your application.
* Select the __Addons__ section.
* Choose the addon __MongoDB__

## Create your application on Scalingo and deploy

<blockquote class="info">
  You can also use our web dashboard to achieve this operation
</blockquote>

```bash
$ scalingo create meteor-app
Git repository detected: remote scalingo added
→ 'git push scalingo master' to deploy your app

$ git push scalingo master
```

## Access your application

```
…
Waiting for your application to boot... 
<-- https://meteor-app.scalingo.io -->
```

Now you can have fun with meteor and all its real-time feature. Of course, we support websocket!
