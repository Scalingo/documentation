---
title: Node.js Common Deployment Errors
nav: Deployment Errors
modified_at: 2025-01-27 00:00:00
tags: nodejs
index: 3
---

You may experience an error in your Node.js application that many customers
faced when first deploying such application on Scalingo. Here is a list of the
most common error messages.

## devDependencies Also Contain Some Dependencies Required at Startup or Runtime {#dep}

In case the app fails to start, or crashes at runtime, due to some missing dependencies or
libraries, it may be because some of the dependencies required
during startup or at runtime are declared as `devDependencies`.

In such case, you may face error messages such as `ng: not found` or `nest: not found`.

By default, Scalingo deployments prune the dependencies from the `devDependencies`
section of the `package.json` file. In such situation, you have a couple of solutions:

- Move the `devDependencies` needed for runtime into the `dependencies`
  section of the package.json file: if the dependencies are required during startup
  or at runtime, they are actual dependencies, not development dependencies.

- Use Yarn 2+ and [skip pruning dependencies]({% post_url languages/nodejs/2000-01-01-start %}#devdependencies-installation)).

  ```bash
  $ scalingo --app my-app env-set YARN2_SKIP_PRUNING=true
  ```

## Boot Timeout {#timeout}

You may see the following log lines at the end of your application deployment
logs:

```text
[...]
 Build complete, shipping your container...
 Waiting for your application to boot...
 !   Error deploying the application
 !   → Timeout: my-app took more than 60 seconds to boot
 !   Application Logs:  https://dashboard.scalingo.com/apps/my-app/logs
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
  console.log('App listening at https://%s:%s', host, port)
})
```

If you face a boot timeout error and use the Next.js framework, please refer to [this specific page]({% post_url languages/nodejs/2000-01-01-start %}#nextjs).


## Host key verification failed

```
Installing node modules
npm ERR! Error while executing:
npm ERR! /usr/bin/git ls-remote -h -t ssh://git@github.com/scalingo/scalingo.js.git
npm ERR!
npm ERR! Host key verification failed.
npm ERR! fatal: Could not read from remote repository.
npm ERR!
npm ERR! Please make sure you have the correct access rights
npm ERR! and the repository exists.
npm ERR!
npm ERR! exited with error code: 128
-----> Build failed
```

This issue happens when in your package.json you're using a git repository instead of a npm package. If you are doing that, you can only use the `https` format and not the `ssh` one.

These requirements correctly resolve to HTTPS URLs:

```json
"scalingo": "https://git@github.com/scalingo/scalingo.js.git"
"scalingo": "git+https://git@github.com/scalingo/scalingo.js.git"
```

{% warning %}
Do no forget the `git@` part in front of the hostname.
{% endwarning %}

These requirements incorrectly resolve to SSH URLs:
```json
"scalingo": "github:scalingo/scalingo.js"
"scalingo": "https://github.com/scalingo/scalingo.js.git"
"scalingo": "git+https://github.com/scalingo/scalingo.js.git"
"scalingo": "git@github.com:Scalingo/scalingo.js.git"
```
