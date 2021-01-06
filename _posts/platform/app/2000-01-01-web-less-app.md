---
layout: page
title: Deploy a Web-less Application
nav: Web-less Application
modified_at: 2021-01-06 00:00:00
tags: app webless
index: 110
---

## Problematic

You may want to create a Scalingo application which contains no web container. By default, Scalingo expects an application to have a web container. Hence, Scalingo tries to ping your application after a deployment to declare the deployment successful. To circumvent this behaviour, you need to declare a web container in your application and scale it to `0`.

This page guide you through the steps to deploy an application with no web container.

## Deploy a Web-less Application

{% include info_command_line_tool.md %}

You first need to create an application, either in the web dashboard or using the CLI:

```shell
$ scalingo create my-app
App 'my-app' has been created
Git repository detected: remote scalingo added
→ 'git push scalingo master' to deploy your app
```

Then, manually scale the application to 0 web container using the CLI:

```shell
$ scalingo --app my-app scale web:0:M
Your application is being scaled to:
  web: 0 - M
```

Your application is now ready to be deployed without web container. You can confirm this by listing your application container types:

```shell
$ scalingo --app my-app ps
+------+--------+------+---------+
| NAME | AMOUNT | SIZE | COMMAND |
+------+--------+------+---------+
| web  |      0 | M    |       - |
+------+--------+------+---------+
```
