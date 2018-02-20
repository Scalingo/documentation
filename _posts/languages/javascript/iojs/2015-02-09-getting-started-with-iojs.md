---
title: Getting started with io.js
modified_at: 2015-02-09 00:00:00
categories: languages javascript iojs
tags: iojs javascript tutorial getting-started-tutorial
---

{% include info_tutorial_requirements.md %}

## Initialize your application

```bash
$ mkdir my-app
$ cd my-app
$ npm init

#
# You need to fill the different info fields for your project
#

$ npm install express --save
$ echo "node_modules" > .gitignore
```

## Write a base server file

The main file for this sample project is `server.js`:

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

Add a `Procfile` at the root of your project containing:

```yaml
web: iojs server.js
```

## Define io.js as JavaScript engine

In your `package.json`, add the following block:

```json
"engines": {
  "iojs": "1.1.x"
}
```

This will instruct the deployment scripts to install io.js and the given
version instead of Node.js.

## Commit your application

```bash
$ git init
$ git add .
$ git commit -m "Base io.js application"
```

## Create your application on Scalingo and deploy

> This operation has to be done in the root directory of your project.

```bash

$ scalingo create my-app
Git repository detected: remote scalingo added
→ 'git push scalingo master' to deploy your app

$ git push scalingo master
```

## Access your application

```bash
…
Waiting for your application to boot...
<-- https://my-app.scalingo.io -->
```

Now develop your project and build something amazing!
