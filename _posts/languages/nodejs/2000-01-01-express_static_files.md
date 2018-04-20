---
title: Serving static files with Express
modified_at: 2018-04-20 00:00:00
tags: nodejs express static
index: 1
---

On some occasion, you might need to deploy a site with only static files. To handle such use case,
we advise you to deploy a simple Express server to serve these files. The server code is as simple
as:

```js
var express = require('express');

var app = express();
app.use(express.static(__dirname + '/dist'));

var port = process.env.PORT || 3000;
app.listen(port, function () {
  console.log('Listening on', port);
});
```

With this piece of code, your server will listen on the port 3000 on your development environment
and on the port defined in the environment variable `PORT` when deployed on Scalingo. All your
static file must be in the folder `dist`.

Don't forget to add a `package.json` file:

```json
{
  "name" : "My Application",
  "version" : "1.0",
  "dependencies" : {
    "express" : "4.x"
  },
  "scripts" : {
    "start": "node server.js"
  }
}
```
