---
title: NodeJS
category: languages
date: 22/03/2015
tags: programming, dev, nodejs, language
---

# Support

NodeJS is supported by Scalingo, furthermore, custom support has been added
to manage the [__meteor__](/languages/javascript/nodejs/meteor.html) framework.

* [Getting Started with NodeJS](/languages/javascript/nodejs/getting-started-with-nodejs.html)
* [Getting Started with Meteor](/languages/javascript/nodejs/getting-started-with-meteor.html)

## Buildpack

[NodeJS Buildpack](https://github.com/Scalingo/nodejs-buildpack)

## Standard node applications

### Node.js app detection

The file `package.json` should be present at the root of the project.

### NPM dependencies installation

The dependencies of your project are installed according to the
`package.json` content using `npm`.

### Node.JS app startup

What we use in order of priority

1. `Procfile` at the root of your project
2. The field `.scripts.start` defined in your `package.json` 
3. We start `server.js` if present.

## Meteor application

If a `.meteor` file is detected at the root of your project, your app will
be considered as a Meteor application.

See the [Meteor applications documentation](/languages/javascript/nodejs/meteor)

## -- See also

* [Getting started with NodeJS](/languages/javascript/nodejs/getting-started-with-nodejs.html)
* [io.js documentation](/languages/javascript/iojs)
* [Getting started with io.js](/languages/javascript/iojs/getting-started-with-iojs.html)
* [Meteor documentation](/languages/javascript/nodejs/meteor)
* [Getting started with Meteor](/languages/javascript/nodejs/getting-started-with-meteor.html)
