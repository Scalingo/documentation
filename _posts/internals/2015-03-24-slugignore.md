---
title: .slugignore file
modified_at: 2015-03-24 00:00:00
category: internals
tags: internals slugignore image size
---

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

```text
spec
```

### Java application

Your application build process result [in a `.war`
file]({% post_url languages/java/2015-03-25-war %}) and your don't want to keep all the generated
classes and jar archives from the build:

`.slugignore` content:

```text
.m2
```

<blockquote class="bg-info">
  <code>.m2</code> directory is the maven local repository which is used to store
  all the dependencies which are downloaded during the build. You don't need them once
  your application is packaged into a `.war` file.
</blockquote>

### Go application

You're deploying a Go application but you don't want to keep the Godeps
directory containing all the third party dependency source code in the image:

`.slugignore` content:

```text
Godeps
```
