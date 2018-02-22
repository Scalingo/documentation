---
title: Getting Started with Meteor
modified_at: 2015-02-09 00:00:00
category: getting-started
tags: nodejs meteor tutorial getting-started-tutorial
index: 3
permalink: /languages/javascript/nodejs/getting-started-with-meteor/
---

{% include info_tutorial_requirements.md %}

## Initialize your application

```bash
# Install Meteor
$ curl https://install.meteor.com | /bin/sh

# Create your app
$ meteor create my-app
$ cd my-app

# Add everything in the Git repository
$ git init .
$ git commit -m "Init meteor application"
```

## Create your application and provision a MongoDB database

The Meteor framework uses extensively MongoDB as a database. Hence you need to
provision a new instance of this database to your application.

```bash
$ scalingo create my-app
Git repository detected: remote scalingo added
→ 'git push scalingo master' to deploy your app

$ scalingo --app my-app addons-add scalingo-mongodb mongo-sandbox
-----> Addon scalingo-mongodb has been provisionned
       ID: my-app-7247
       Modified variables: [MONGO_URL SCALINGO_MONGO_URL]
       Message from addon provider: Database successfully created
```

## Deploy your application!

<aside class="note">
  This operation has to be done in the directory of your project.
</aside>

```bash
$ git push scalingo master
```

## Access your application

```bash
…
Waiting for your application to boot...
<-- https://my-app.scalingo.io -->
```

Now you can have fun with meteor and all its real-time feature. Of course, we
support WebSocket!
