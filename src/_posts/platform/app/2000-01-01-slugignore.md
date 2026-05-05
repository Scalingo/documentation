---
title: .slugignore File
modified_at: 2024-08-22 00:00:00
tags: internals slugignore image size
---

## Background

When you deploy an application, our build system fetches all the required
dependencies according to the programming language and the requirements of your
project. For compiled languages, their executable or package is then built. All
these files are gathered in an __application image__. This image is stored and
distributed to our servers when they need to run your application. So one
consequence is: the lighter the faster.

## Definition

The `.slugignore` file allows you to list files and directories that should not
be included in the image after the build of your application. When you have heavy
build dependencies, you often don't need them after the build, so why keep them?
They would only slow down your application's boot time.

## Usage

Create a `.slugignore` file at the root of your project containing on each line
the name of a file or directory you want to exclude from your image.

Each line in the `.slugignore` is interpreted as it would be in a Linux shell. Hence you can use the `*` as a wildcard. For instance, `*.log` would ignore all files ending with `.log`.

It is also possible to use character range such as `[a-f]` to remove any file named with a letter between `a` and `f`.

Here is an example of a perfectly valid `.slugignore` file:

```
[a-f]*.log
```

This would exclude from the image all files starting by a letter between `a` and `f`, followed by any number of characters, and ending with `.log`.

For a comprehensive list of what is allowed, please refer to the [`filepath.Match`](https://pkg.go.dev/path/filepath#Match) Go function.

## Examples

### Ruby Application

Your Ruby application doesn't need to have all its test suites when running
in production, so the `spec` folder can be filtered out:

`.slugignore` content:

```text
spec
```

### Rails Application

Most Rails applications also use Webpacker to bundle the assets. If this is your
case, you can safely remove the following folders that are not necessary
to run the application:

```text
doc
/tmp/cache
/node_modules
/.cache/yarn
```

### PHP Application

Some PHP applications also use Webpack (or Webpack Encore) to bundle the assets.
If this is your case, you can safely remove the following folders that are not
necessary to run the application:

```text
doc
/tmp/cache
/node_modules
/.cache/yarn
```

### Java Application

Your application build process result [in a `.war` file]({% post_url
languages/java/2000-01-01-war %}) and you don't want to keep all the generated
classes and jar archives from the build:

`.slugignore` content:

```text
.m2
```

{% note %}
  <code>.m2</code> directory is the maven local repository which is used to store
  all the dependencies which are downloaded during the build. You don't need them once
  your application is packaged into a `.war` file.
{% endnote %}

### Go Application

You're deploying a Go application but you don't want to keep the Godeps
directory containing all the third party dependency source code in the image:

`.slugignore` content:

```text
Godeps
```

### Next.js Application

You're deploying a Next.js application but the image size is too big. You can try to run Next.js in standalone mode.

More information here: [Next.js in standalone mode]({% post_url languages/nodejs/2000-01-01-nextjs-standalone %}).
