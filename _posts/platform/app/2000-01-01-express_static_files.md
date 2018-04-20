---
title: Static files only application
modified_at: 2018-04-20 00:00:00
tags: nodejs express static
---

On some occasion, you might need to deploy an application containing only static files. To handle
such use case, we advise you to deploy a simple Express server to serve these files. Express is
minimalist web framework for Node.js. You just need to write a `server.js` file containing:

```js
var express = require('express');

var app = express();
app.use(express.static(__dirname + '/dist'));

var port = process.env.PORT || 3000;
app.listen(port, function () {
  console.log('Listening on', port);
});
```

With this piece of code, all your static files must be in the `dist` folder, in the same directory
as your `server.js` file. You can use a different folder if you need by modifying the folder defined
by the call to `express.static`.

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

That's it! Push your code to Scalingo and your application will be up and running, ready to serve
your static files.
