---
title: Getting started with io.js
modified_at: 2015-02-09 00:00:00
category: getting-started
tags: iojs, javascript, tutorial,
---

# Getting started with io.js

{% include info_tutorial_requirements.md %}

## Initialize your application

{% highlight bash %}
$ mkdir iojs-app
$ cd iojs-app
$ npm init

#
# You need to fill the different info field for your project
#

$ npm install express --save
$ echo "node_modules" > .gitignore
{% endhighlight %}

## Write a base server file

server.js

{% highlight js %}
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
{% endhighlight %}

<blockquote class="tip">
  The `process.env.PORT` will read the environment variable PORT dynamically provided by our container manager.
</blockquote>

## Define how to start your application

Procfile

{% highlight yaml %}
web: iojs server.js
{% endhighlight %}

## Define io.js as javascript engine

In your `package.json`, add the following block:

{% highlight js %}
"engines": {
  "iojs": "1.1.x"
}
{% endhighlight %}

This will instruct the deployment scripts to install iojs at
the given version instead of Node.js

## Commit your application

{% highlight bash %}
$ git init
$ git add .
$ git commit -m "Base io.js application"
{% endhighlight %}

## Create your application on Scalingo and deploy

> This operation has to be done in the directory of your project.

{% highlight bash %}

$ scalingo create iojs-app
Git repository detected: remote scalingo added
→ 'git push scalingo master' to deploy your app

$ git push scalingo master
{% endhighlight %}

## Access your application

{% highlight bash %}
…
Waiting for your application to boot...
<-- https://iojs-app.scalingo.io -->
{% endhighlight %}

Now develop your project and build something amazing!
