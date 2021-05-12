---
title: Install Puppeteer
modified_at: 2021-05-12 00:00:00
tags: nodejs puppeteer
---

Puppeteer is a library to headless Chrome API. In short, most things that you can do manually in the browser can be achieved with a program using Puppeteer. By default, installing Puppeteer on a Scalingo application fails because the X11 library are not included in Scalingo base image. The error message is:

```
[Nest] 31 - 10/24/2019, 4:08:50 PM [ExceptionsHandler] Failed to launch chrome!
/app/node_modules/puppeteer/.local-chromium/linux-686378/chrome-linux/chrome: error while loading shared libraries: libX11-xcb.so.1: cannot open shared object file: No such file or directory
```

## Install Puppeteer on a Scalingo Application

To install Puppeteer on a Scalingo application, you need to make use of [this buildpack](https://github.com/jontewks/puppeteer-heroku-buildpack) developed by the community. Such a buildpack should be used as part of a [multi-buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-multi %}).

```bash
$ echo 'https://github.com/jontewks/puppeteer-heroku-buildpack' >> .buildpacks
$ echo 'https://github.com/Scalingo/nodejs-buildpack' >> .buildpacks
$ git add .buildpacks
$ git commit -m 'Add multi-buildpack'
```

This buildpack also requires the environment variable `STACK` to be set with the value `heroku-18`:

```bash
$ scalingo --app my-app env-set STACK=heroku-18
```
