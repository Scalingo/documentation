---
title: Deployment of JAR and WAR archives
nav: Deploy JAR/WAR
modified_at: 2020-05-19 00:00:00
index: 7
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

## Usage of the `deploy` command

The following example applies for **WAR** archives but **also for autonomous JAR**
archives:

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

## Configuration

### JVM version selection

The used version of OpenJDK (Java runtime) can be defined by the environment
variable `JAVA_VERSION`. By default the **1.8** version will be used.

```sh
# Configure the application to use OpenJDK version 1.9

$ scalingo --app my-app env-set JAVA_VERSION=1.9
```

### Webapp Runner / Tomcat version selection

By default, Tomcat 8.5 is installed with the last version of the webapp-runner,
if you want to use another version, you can defined the environment variable
`WEBAPP_RUNNER_VERSION`. You can find all the available versions
[here](https://github.com/jsimone/webapp-runner/releases).

The 8.0.x versions are installing Tomcat 8, and the 8.5.x releases are
installing Tomcat 8.5:

```sh
# Install Tomcat 8

$ scalingo env-set WEBAPP_RUNNER_VERSION=8.0.39.0
```
