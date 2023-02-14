---
title: Static files only application
modified_at: 2023-02-14 00:00:00
tags: nodejs express static
---

On some occasions, you might need to deploy an application containing only static files. To handle
this use case, the recommended method is to deploy a **Node.js** server using Express, a
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

## Using Jekyll

Jekyll is a static site generator written with Ruby. In order to generate your static files, you will need a Ruby
environment, and a Node JS environment to serve the files, as seen before.

As Scalingo provides [Multi Buildpack](https://doc.scalingo.com/platform/deployment/buildpacks/multi) support, you can 
combine the two environments needed to build your website. To achieve this, you can add a `.buildpacks` file at the root
of your project, containing our Ruby Buildpack, and our NodeJS Buildpack:

```
https://github.com/Scalingo/ruby-buildpack
https://github.com/Scalingo/nodejs-buildpack
```

> The NodeJS Buildpack being used for running our website, it must come last ! 
 
The procedure is very similar to what we did before. But we will add a build task to our `package.json` file, 
which will build our Jekyll website, like this:

```json
{
  "name" : "my-application",
  "version" : "1.0.0",
  "dependencies" : {
    "express" : "4.x"
  },
  "scripts" : {
    "build": "bundle exec jekyll build",
    "start": "node server.js"
  }
}
```

And you need to adapt your `server.js` file just a bit, in order to make the `.html` extension in your URL optional:

```js
var express = require('express');

var app = express();
var directory = '/' + (process.env.STATIC_DIR || 'dist')
app.use(express.static(__dirname + directory), { extensions: 'html'});

var port = process.env.PORT || 3000;
app.listen(port, function () {
  console.log('Listening on', port);
});
```

And your app is now ready to go!

