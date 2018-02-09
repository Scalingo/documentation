---
title: Getting Started with Scalatra
modified_at: 2016-07-22 00:00:00
category: getting-started
tags: scalatra tutorial getting-started-tutorial
index: 3
permalink: /languages/scala/scalatra/getting-started-with-scalatra/
---

{% include info_tutorial_requirements.md %}

## Prerequisites

You will need to download a few utilities to initialize your Scalatra app.

Conscript is a tool for installing and updating Scala code. Giter8, which
depends on conscript, allows you to check out project templates directly from
GitHub. It's the recommended way to generate Scalatra project skeletons.

```bash
#
# Install conscript and giter8
#

$ curl https://raw.githubusercontent.com/foundweekends/conscript/master/setup.sh | sh
$ cs foundweekends/giter8
```

## Initialize your application

```bash
$ g8 scalatra/scalatra-sbt

#
# You need to fill the different info field for your project
#

$ cd /your/project/directory

#
# Run it locally
#

$ chmod u+x sbt
$ ./sbt
> jetty:start
```

To allow sbt to create a binary for your app you **should** have:

* `addSbtPlugin("com.typesafe.sbt" % "sbt-native-packager" % "1.0.0-M1")` in ./project/plugins.sbt
* `enablePlugins(JavaAppPackaging)` in ./project/build.scala

## Fix Jetty installation scope

In the file `project/build.scala`, your should see a line like the following,
defining the dependency `jetty-webapp`:

```scala
        "org.eclipse.jetty" % "jetty-webapp" % "9.3.9.v20160517",
```

You need to modify this line to add the use of the package in the `compile` stage:

```scala
        "org.eclipse.jetty" % "jetty-webapp" % "9.3.9.v20160517" % "compile",
```

## Write a base server file

The main file for this sample is `server.scala` with the following content:

```scala
// Scalatra Sample application

import org.eclipse.jetty.server.Server
import org.eclipse.jetty.servlet.{ DefaultServlet, ServletContextHandler }
import org.eclipse.jetty.webapp.WebAppContext

object JettyLauncher {
  def main(args: Array[String]) {
    val port = if(System.getenv("PORT") != null) System.getenv("PORT").toInt else 8080

    val server = new Server(port)
    val context = new WebAppContext()
    context setContextPath "/"
    context.setResourceBase("src/main/webapp")
    context.addServlet(classOf[com.example.app.MyScalatraServlet], "/*")
    context.addServlet(classOf[DefaultServlet], "/")

    server.setHandler(context)

    server.start
    server.join
  }
}
```

<blockquote class="bg-info">
  The `System.getenv("PORT")` will read the environment variable PORT dynamically provided by our container manager.
</blockquote>

## Commit your application

```bash
$ git init
$ git add .
$ git commit -m "Base Scalatra application"
```

## Create your application on Scalingo and deploy

> This operation has to be done in the root directory of your project.

```bash
$ scalingo create my-app
Git repository detected: remote scalingo added
→ 'git push scalingo master' to deploy your app

$ git push scalingo master
```

## Access your application

```bash
…
Waiting for your application to boot...
<-- https://my-app.scalingo.io -->
```

Now develop your project and build something amazing!
