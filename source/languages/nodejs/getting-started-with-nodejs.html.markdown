---
title: Getting Started with NodeJS
category: languages
date: 09/02/2015
tags: programming, dev, nodejs, language, express, tutorial
---

# Getting started with NodeJS

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
// NodeJS - Express Sample application

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

<blockquote class="tip">
  The `process.env.PORT` will read the environment variable PORT dynamically provided by our container manager.
</blockquote>

## Define how to start your application

Procfile

```yml
web: node server.js
```

## Commit your application 

```bash
$ git init
$ git add .
$ git commit -m "Base NodeJS application"
```

## Create your application on Scalingo and deploy

<blockquote class="info">
  You can also use our web dashboard to achieve this operation
</blockquote>

```bash
$ scalingo create nodejs-app
Git repository detected: remote scalingo added
→ 'git push scalingo master' to deploy your app

$ git push scalingo master
```

## Access your application

```
…
Waiting for your application to boot... 
<-- https://nodejs-app.scalingo.io -->
```

Now develop your project and build something amazing!
