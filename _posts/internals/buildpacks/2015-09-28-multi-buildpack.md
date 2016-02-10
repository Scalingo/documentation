---
title: Multi Buildpack
modified_at: 2015-09-28 00:00:00
categories: internals
tags: buildpacks build image multi
permalink: /buildpacks/multi/
---

# Purpose of this buildpack

You may need to combine several technologies in your project, this buildpack is here to fulfill this need.

## Set up this buildpack for your application

By setting the configuration variable `BUILDPACK_URL`, the Scalingo's deployment stack will
automatically fetch the given buildpack to deploy your application.

```bash
scalingo env-set BUILDPACK_URL=https://github.com/Scalingo/multi-buildpack.git
```

## Choice of the buildpacks to use

Create a file named `.buildpacks` in your project which will define the buildpacks to use:

```bash
https://github.com/Scalingo/nodejs-buildpack.git
https://github.com/Scalingo/go-buildpack.git
```

Add this file to your git repository:

```bash
git add .buildpacks
git commit -m "Setup .buildpacks for using multiple buildpacks on Scalingo"
```

Finally in this example, thanks to this method, both NodeJS buildpack and Go buildpack will be applied
on your project.

> List of the available buildpacks: [http://doc.scalingo.com/buildpacks](http://doc.scalingo.com/buildpacks)

## Deploy your application

```bash
git push scalingo master
```


> Source: [https://github.com/Scalingo/multi-buildpack](https://github.com/Scalingo/multi-buildpack)
