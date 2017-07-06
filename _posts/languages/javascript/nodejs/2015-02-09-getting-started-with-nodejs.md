---
title: Getting Started with Node.js
modified_at: 2015-02-09 00:00:00
category: getting-started
tags: nodejs express tutorial getting-started-tutorial
index: 3
permalink: /languages/javascript/nodejs/getting-started-with-nodejs/
---

{% include info_tutorial_requirements.md %}

## Initialize your application

```bash
$ mkdir nodejs-app
$ cd nodejs-app
$ npm init

#
# You need to fill the different info field for your project
#

$ npm install express --save
$ echo "node_modules" > .gitignore
```

## Write a base server file

server.js

```js
// Node.js - Express Sample application

var express = require('express')
var app = express()

app.get('/', function (req, res) {
  res.send('Hello World!')
})

var server = app.listen(process.env.PORT || 3000, function () {
  var host = server.address().address
  var port = server.address().port
  console.log('App listening at http://%s:%s', host, port)
})
```

<blockquote class="bg-info">
  The `process.env.PORT` will read the environment variable PORT dynamically provided by our container manager.
</blockquote>

## Define how to start your application

The 'Procfile' (with a capital 'P') is the file defining how your application is supposed to start ([more info about Procfile]({% post_url internals/2014-12-01-procfile %})), here is the content you have to write in the 'Procfile' file for this project:

```yaml
web: node server.js
```

## Commit your application

```bash
$ git init
$ git add .
$ git commit -m "Base Node.js application"
```

## Create your application on Scalingo and deploy

> This operation has to be done in the directory of your project.

```bash
$ scalingo create nodejs-app
Git repository detected: remote scalingo added
→ 'git push scalingo master' to deploy your app

$ git push scalingo master
```

## Access your application

```bash
…
Waiting for your application to boot...
<-- https://nodejs-app.scalingo.io -->
```

## How to keep your application alive

For Node.js apps we recommend to use a tool such as ​`forever`​ https://github.com/foreverjs/forever.


Now develop your project and build something amazing!
