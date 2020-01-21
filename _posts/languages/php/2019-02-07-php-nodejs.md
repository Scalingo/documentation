---
title: PHP application with Node.js
nav: PHP along with Node.js
modified_at: 2020-01-16 00:00:00
tags: php nodejs assets webpack
---

There are some cases where a PHP application also needs Node.js. It is for
example the case if you use webpack to bundle the assets. For this reason, the
PHP buildpack detects if you have a `package.json` file at the root of your
repository and install Node.js if needed. Then the dependencies are installed,
including those declared in `devDependencies`. This is the default behaviour as
most of the time, dependencies to bundle the assets are declared as development
dependencies.

If this is not the intended behaviour, or if you need to fine tune the Node.js
installation, you better use the real Node.js buildpack. In this case, one
should use [multi buildpacks]({% post_url
platform/deployment/buildpacks/2000-01-01-multi %}). Here is how to do that.

In order to use [multi buildpacks]({% post_url
platform/deployment/buildpacks/2000-01-01-multi %}), you first need to specify
the `BUILDPACK_URL` environment variable. Head to the web dashboard or use our
CLI:

```bash
scalingo env-set BUILDPACK_URL=https://github.com/Scalingo/multi-buildpack.git
```

Then add a file named `.buildpacks` at the root of your application containing
(the order of the two lines is important):

```text
https://github.com/Scalingo/nodejs-buildpack
https://github.com/Scalingo/php-buildpack
```

Eventually, define the environment variable `PHP_BUILDPACK_NO_NODE=true` in your
application.

With this setup, Scalingo will first execute the Node.js buildpack to execute
`yarn install` and `yarn build`. Then the PHP buildpack is executed without the
basic Node.js support it embeds.

{% note %}
You can reduce the size of your application by adding a [`.slugignore` file]({%
post_url platform/app/2000-01-01-slugignore %}#php-application) at the root of
your project.
{% endnote %}
