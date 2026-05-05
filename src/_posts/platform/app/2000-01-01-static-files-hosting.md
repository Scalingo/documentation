---
title: Static Files Only Application
modified_at: 2023-02-17 00:00:00
tags: nginx nodejs express static
---

On some occasions, you might need to deploy an application containing only static files. This use case requires a web server to serve the static files. This page propose two solutions to set this up: using Node.js or Nginx.

## Using Node.js as Web Server

A possibility is to deploy a Node.js server using Express, a minimalist web framework. Only one file is required (name it `server.js`):

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
  "name" : "my-application",
  "version" : "1.0.0",
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

## Using Nginx as Web Server

The other possibility is to use Nginx to serve the static files. In this case, you may need to leverage the [multi-buildpacks]({% post_url platform/deployment/buildpacks/2000-01-01-multi %}) to add the Nginx buildpack as the last buildpack.

Configure Nginx with the following configuration file (name it `nginx.conf`):

```nginx
root /app/dist;

location / {
  try_files $uri $uri/ /index.html =404;
}
```

This configuration assumes that your static files are located in the `dist` folder of your application.

You also need to add a `Procfile` to instruct Scalingo how to boot Nginx. The `Procfile` content should be:

```yaml
web: bin/run
```

Push your code to Scalingo, and the application is up and running, ready to serve your static files.
