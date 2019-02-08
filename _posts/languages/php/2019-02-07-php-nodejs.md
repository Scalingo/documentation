---
title: PHP application with Node.js
nav: PHP along with Node.js
modified_at: 2019-02-07 00:00:00
tags: php nodejs assets webpack
---

There are some cases where a PHP application uses also some Node.js. It is for example the case if
you use webpack to bundle the assets. In this case, one should use [multi buildpacks]({% post_url
platform/deployment/buildpacks/2000-01-01-multi %}) along with a specific branch of the PHP
buildpack. Here is how to do that.

In order to use [multi buildpacks]({% post_url platform/deployment/buildpacks/2000-01-01-multi %}),
you need to specify the `BUILDPACK_URL` environment variable. Head to the web dashboard or use our
CLI:

```bash
scalingo env-set BUILDPACK_URL=https://github.com/Scalingo/multi-buildpack.git
```

Then add a file named `.buildpacks` at the root of your application containing (the order of the two
lines is important):

```text
https://github.com/Scalingo/nodejs-buildpack
https://github.com/Scalingo/php-buildpack#nonode
```

With this setup, Scalingo will first execute the PHP buildpack without the basic Node.js support it
embeds (the branch `nonode`), then the Node.js buildpack will execute `yarn install` and `yarn
build`.
