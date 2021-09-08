---
title: Node.js Common Deployment Errors
nav: Deployment Errors
modified_at: 2021-07-08 00:00:00
tags: nodejs
index: 3
---

You may experience an error in your Node.js application that many customers
faced when first deploying such application on Scalingo. Here is a list of the
most common error messages.

## devDependencies Also Contain the Build Dependencies {#dep}

The `devDependencies` section of the package.json file contains both development
dependencies and build dependencies. By default Scalingo deployments install the
dependencies from the `dependencies` section of the package.json file. It may
lead to error messages such as `ng: not found` or `nest: not found`. In such
situation, you have a couple of solutions:

- Install all `devDependencies` ([doc]({% post_url
    languages/nodejs/2000-01-01-start %}#install-devdependencies)).

  ```bash
  $ scalingo --app my-app env-set NPM_CONFIG_PRODUCTION=false
  ```
- Move the `devDependencies` needed for the build into the `dependencies`
    section of the package.json file.

## Boot Timeout {#timeout}

You may see the following log lines at the end of your application deployment
logs:

```text
[...]
 Build complete, shipping your container...
 Waiting for your application to boot...
 !   Error deploying the application
 !   → Timeout: my-app took more than 60 seconds to boot
 !   Application Logs:  https://my.scalingo.com/apps/my-app/logs
 !   Documentation:     https://doc.scalingo.com/deployment/start-error#timeout

To ssh.osc-fr1.scalingo.com:my-app.git
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'ssh.osc-fr1.scalingo.com:my-app.git'
```

Most of the time, this timeout occurs when your application does not bind the
port declared by the platform in the environment variable `PORT`. You can see
how to do that in this [Express example]({% post_url
languages/nodejs/2000-01-01-tutorial %}#write-a-base-server-file).

Here is a short excerpt of this example:

```js
var express = require('express')
var app = express()

var server = app.listen(process.env.PORT || 3000, function () {
  var host = server.address().address
  var port = server.address().port
  console.log('App listening at http://%s:%s', host, port)
})
```

If you face a boot timeout error and use the Next.js framework, please refer to [this specific page](https://doc.scalingo.com/languages/nodejs/start#nextjs).
