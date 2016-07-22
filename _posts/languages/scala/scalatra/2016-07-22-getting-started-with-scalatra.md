---
title: Getting Started with Scalatra
modified_at: 2016-07-22 00:00:00
category: getting-started
tags: scalatra tutorial getting-started-tutorial
index: 3
permalink: /languages/scala/scalatra/getting-started-with-scalatra/
---

{% include info_tutorial_requirements.md %}

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

## Write a base server file

server.scala

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

> This operation has to be done in the directory of your project.

```bash
$ scalingo create scalatra-app
Git repository detected: remote scalingo added
→ 'git push scalingo master' to deploy your app

$ git push scalingo master
```

## Access your application

```bash
…
Waiting for your application to boot...
<-- https://scalatra-app.scalingo.io -->
```

Now develop your project and build something amazing!
