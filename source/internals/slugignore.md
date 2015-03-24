---
title: .slugignore file
category: internals
tags: internals, slugignore, image, size
date: 24/03/2015
---

# The `.slugignore` file

## Background

When you deploy an application, our build system is fetching all the required
dependencies according to the programming language and the requirements of your
project. For compiled languages, their executable or package is then built. All
these files are gathered in an __application image__. This image is stored and
distributed to our servers when they need to run your application. So one
consequence is: the lighter the faster.

## Definition

The `.slugignore` file allows you to select files and directory which won't be
include in the image after the build of your application. When you have heavy
build dependencies, you often don't need them after the build, so why keeping
them? They would just slow down your application starting duration.

## Usage

You just need to create a `.slugignore` file at the root of your project
containing on each line the name of a file or directory you want to exclude
from your image.

## Example

### Ruby application

Your ruby application doesn't need to have all its test suites when running
in production. You might want to exclude them during th deployment:

`.slugignore` content:

```
spec
```

### Java application

Your application build process result [in a `.war`
file](/languages/java/war.html) and your don't want to keep all the generated
classes and jar archives from the build:

`.slugignore` content:

```
.m2
```

<blockquote class="info">
  <code>.m2</code> directory is the maven local repository which is used to store
  all the dependencies which are downloaded during the build. You don't need them once
  your application is packaged into a `.war` file.
</blockquote>

### Go application

You're deploying a Go application but you don't want to keep the Godeps
directory containing all the third party dependency source code in the image:

`.slugignore` content:

```
Godeps
```

## See also

* [Procfile](/internals/procfile.html): How to manage your app container types
* [Build Errors](/deployment/build-error.html): List of potential errors happening during a deployment build
* [Start Errors](/deployment/start-error.html): Possible errors which happen when the platform tries to start an application
