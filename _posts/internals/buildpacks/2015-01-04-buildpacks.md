---
title: Buildpacks
modified_at: 2018-02-09 00:00:00
categories: internals
tags: buildpacks build image
permalink: /buildpacks/
---

## Introduction

When you want to deploy your application on Scalingo, it needs to be built as
a portable container image. This image will be loaded by our servers to run
and scale your app.

A buildpack is a set of scripts which aims at:

* Detecting the language of an application `detect`
* Installing the dependencies of a project `compile`
* Defining how the application should be started `release`

## Buildpacks included on Scalingo

* `Ruby` — [Documentation]({% post_url languages/ruby/2015-06-23-ruby %}) — [Source](https://github.com/Scalingo/ruby-buildpack)
* `Node.js / io.js / Meteor` — [Documentation]({% post_url languages/javascript/nodejs/2015-09-20-nodejs %}) — [Source](https://github.com/Scalingo/nodejs-buildpack)
* `PHP` — [Documentation]({% post_url languages/php/2014-07-02-php %}) — [Source](https://github.com/Scalingo/php-buildpack)
* `Java` — [Documentation]({% post_url languages/java/2015-09-01-java %}) — [Source](https://github.com/Scalingo/java-buildpack)
* `Python` — [Documentation]({% post_url languages/python/2015-04-05-python %}) — [Source](https://github.com/Scalingo/python-buildpack)
* `Go` — [Source](https://github.com/Scalingo/go-buildpack)
* `Scala` — [Documentation]({% post_url languages/scala/2015-01-26-scala %}) — [Source](https://github.com/Scalingo/scala-buildpack)
* `Erlang` — [Source](https://github.com/Scalingo/erlang-buildpack)
* `Haskell` — [Source](https://github.com/Scalingo/haskell-buildpack)
* `Clojure` — [Documentation]({% post_url languages/clojure/2015-01-26-clojure %}) — [Source](https://github.com/Scalingo/clojure-buildpack)
* `Grails Framework` — [Source](https://github.com/Scalingo/grails-buildpack)
* `Play Framework` — [Documentation]({% post_url languages/java/2015-01-26-play %}) — [Source](https://github.com/Scalingo/play-buildpack)
* `Gradle Framework` — [Documentation]({% post_url languages/java/2016-10-26-gradle %}) — [Source](https://github.com/Scalingo/gradle-buildpack)

## Available buildpacks for specific usage

* `Multi Buildpack` - [Documentation]({% post_url internals/buildpacks/2015-09-28-multi-buildpack %}) — [Source](https://github.com/Scalingo/multi-buildpack.git) - Combine different buildpacks during the deployment of your applicaiton
* `FFmpeg Buildpack` - [Documentation]({% post_url internals/buildpacks/2015-09-28-ffmpeg-buildpack %}) — [Source](https://github.com/Scalingo/ffmpeg-buildpack.git) - Install a working version of the ffmpeg binary alongside your application
* `GraphicsMagic Buildpack` - [Documentation]({% post_url internals/buildpacks/2000-01-01-graphicsmagick-buildpack %}) — [Source](https://github.com/Scalingo/graphicsmagick-buildpack) - Install graphicsmagick and replace imagemagick in the container environment
* `Cairo Buildpack` - [Documentation]({% post_url internals/buildpacks/2000-01-01-cairo-buildpack %}) — [Source](https://github.com/Scalingo/cairo-buildpack) Install the cairo graphics library and its dependencies
* `Wkhtmltopdf Buildpack` - [Documentation]({% post_url internals/buildpacks/2016-10-27-wkhtmltopdf-buildpack %}) — [Source](https://github.com/Scalingo/wkhtmltopdf-buildpack) - Install wkhtmltopdf binary to generate PDF from web pages


## Use a custom buildpack

We want our users to be able to use the technologies they love, we try to provide the support for
an extended range of languages and frameworks, but if we don't fit your need, you can use a
[custom buildpack]({% post_url internals/buildpacks/2015-01-04-custom-buildpacks %}).

## Specify a precise buildpack

In some cases, your application may be detected by two different buildpacks, for instance if you
are building a PHP application which manages its dependencies with `grunt` tasks, `bower` or `gulp`,
your application will be detected as a Node.js application and as a PHP application.

In this situation you need to specify the buildpack you want to use by defining the environment variable:

```bash
BUILDPACK_NAME=php
```
