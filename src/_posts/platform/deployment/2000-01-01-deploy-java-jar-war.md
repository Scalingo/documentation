---
title: Deployment of JAR and WAR archives
nav: Deploy JAR/WAR
modified_at: 2026-01-12 12:00:00
index: 8
tags: deployment, java, jar, war
---

For JVM-based web applications, instead of deploying the code by building the
code a pre-built autonomous JAR archive or WAR build can be directly deployed
on the platform.

It can be especially useful when using a Continuous Integration platform like
*TravisCI* or *Jenkins*. These platforms are usually building the project to
execute the application test suites against it. Instead of building a second
time the application code, the JAR and WAR archives generated during the build
can be directly deployed on Scalingo.

This deployment method currently only supports Tomcat server to execute your
archive.

{% include info_command_line_tool.md %}

## Deploy a WAR Archive

You can deploy your **WAR** archive with the following command:

```sh
$ scalingo --app my-app deploy ./application.war
-----> Deploying WAR archive: ./application.war
-----> Uploading archive…
       Deployment started, streaming output:

[LOG] Fetching source code
[LOG] Fetching deployment cache
[LOG] -----> Installing JDK 1.8... done
[LOG]
[LOG] -----> Build complete, uploading deployment cache.
[LOG]  Build complete, shipping your container...
[LOG]  Waiting for your application to boot...
[LOG] <-- https://my-app.osc-fr1.scalingo.io -->
```

## Deploy a JAR Archive

Deploying a JAR archive is slightly more complicated. You need to build a `.tar.gz` archive with some specific files.

Create a directory which contains the JAR file, and a [Procfile]({% post_url platform/app/2000-01-01-procfile %}) which explains how to start the application:

```yaml
web: java -jar ./my-app.jar
```

The `.tar.gz` archive content tree should be like:

```
scalingo/my-app.jar
scalingo/Procfile
```

Indicate to Scalingo deployment system the type of technology used by your application by defining the following environment variable:

```bash
scalingo --app my-app env-set BUILDPACK_URL="https://github.com/Scalingo/buildpack-jvm-common"
```

Last, deploy your archive with:

```sh
$ scalingo --app my-app deploy ./archive.tar.gz
 <-- Start deployment of my-app -->
       Fetching source code
       Fetching deployment cache
-----> Cloning custom buildpack: https://github.com/Scalingo/buildpack-jvm-common#master
-----> Installing JDK 1.8... done
 Build complete, shipping your container...
 Waiting for your application to boot...
 <-- https://my-app.osc-fr1.scalingo.io -->
```

## Configuration

### JVM version selection

The used version of OpenJDK (Java runtime) can be defined by the environment
variable `JAVA_VERSION`. By default the **1.8** version will be used.

```sh
# Configure the application to use OpenJDK version 1.9

$ scalingo --app my-app env-set JAVA_VERSION=1.9
```

### Webapp Runner / Tomcat version selection

By default, the latest `9.0.x` version of Tomcat is installed. If you want to
use another version, you can define the environment variable
`JAVA_WEBAPP_RUNNER_VERSION`, like so:

```sh
scalingo --app my-app env-set JAVA_WEBAPP_RUNNER_VERSION=10.1.24.0
```

The latest available versions currently are:

| Tomcat Version | `scalingo-20` (EOL) | `scalingo-22`       | `scalingo-24`       |
| -------------: | ------------------: | ------------------: | ------------------: |
| **`10.1`**     | up to `10.1.49.0`   | up to `10.1.50.0`   | up to `10.1.50.0`   |
| **`9.0`**      | up to `9.0.112.0`   | up to `9.0.113.0`   | up to `9.0.113.0`   |
| `8.5`          | up to `8.5.68.1`    | up to `8.5.68.1`    | up to `8.5.68.1`    |

The default Tomcat version on all stacks is the latest `9.0` version.

{% note %}
Even though we still support this version, we strongly advise against using the
`8.5` version, which has been released a while ago. If you are still using it,
please consider migrating to a more recent version.
{% endnote %}
