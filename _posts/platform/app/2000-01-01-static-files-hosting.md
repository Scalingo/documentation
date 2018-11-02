---
title: Static files only application
tags: nodejs express static
---

On some occasions, you might need to deploy an application containing only static files. To handle
this use case, the recommended method is to deploy a **Node.JS** server using Express, a
minimalist web framework. Only one file is required (name it `server.js`):

```js
var express = require('express');

var app = express();
var directory = '/' + (process.env.STATIC_DIR || 'dist')
app.use(express.static(__dirname + directory));

var port = process.env.PORT || 3000;
app.listen(port, function () {
  console.log('Listening on', port);
});
```

With this piece of code, all your static files must be in the `dist` folder, in the same directory
as your `server.js` file. A different directory can be used by modifying the `STATIC_DIR` environment
variable with the right value.

Your server will listen on the port 3000 in your development environment and on the port defined in
the environment variable `PORT` when deployed on Scalingo.

Don't forget to add a `package.json` file in order to add the `express` dependency:

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

That's it! Push your code to Scalingo and your application will be up and
running, ready to serve your static files.
