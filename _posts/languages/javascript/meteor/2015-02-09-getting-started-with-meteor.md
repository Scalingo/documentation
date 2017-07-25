---
title: Getting Started with Meteor
modified_at: 2015-02-09 00:00:00
category: meteor
tags: nodejs meteor tutorial getting-started-tutorial
index: 3
permalink: /javascript/meteor/getting-started-with-meteor/
---

{% include info_tutorial_requirements.md %}

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

```bash
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

> This operation has to be done in the directory of your project.

```bash
$ git push scalingo master
```

## Access your application

```bash
…
Waiting for your application to boot...
<-- https://meteor-app.scalingo.io -->
```

Now you can have fun with meteor and all its real-time feature. Of course, we support websocket!
