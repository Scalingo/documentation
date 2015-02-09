---
title: io.js support
category: languages
date: 09/02/2015
tags: programming, dev, iojs, javascript, language
---

# io.js - https://iojs.org/

## Description

io.js is a fork from the Node.js project and is compatible with
the whole `npm` ecosystem. So it is used as a runtime for your
javascript code, server side.

## How to convert a Node.js application to io.js

> Node.js support: http://doc.scalingo.com/langauges/javascript/nodejs

It is pretty straightforward, you just have to change the engine
you want to use in your `package.json`

Instead of having no `engines` section, or a block like:

```json
{
  "engines": {
    "node": "0.12.x"
  }
}
```

Write 

```json
{
  "engines": {
    "iojs": "1.1.x"
  }
}
```

## Tutorial

Getting started with io.js: [tutorial](http://doc.scalingo.com/languages/javascript/iojs/getting-started-with-iojs.html)

## Example application

* Github repository: https://github.com/Scalingo/sample-iojs-express
* Live application:  https://sample-iojs-express.scalingo.io
