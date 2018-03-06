---
title: Start Errors
modified_at: 2014-08-26 00:00:00
tags: app error timeout crash
---

After creating the container image of your application, it is deployed
in our infrastructure. The following errors may happened if your application
is not configured correctly.

If something wrong happens, you should first look at the logs of your app. In
most cases, all the information you need is displayed here.

## Boot Timeout

When started on our servers, your application has **60 seconds** to bind the
port defined by the environment variable `PORT`. After this delay, we consider
that your application is not able to boot and this error happens.

### Common causes

* The server is not listening on the port defined by the environment variable
  `PORT`. Then your application is running correctly but it is not reachable.

## Crash of the application

When your application starts, it may stop unexpectedly for various reasons
related to your project.

### Common causes

* Syntax error and import error in your code. Make sure that your project is
  working correctly locally before deploying it on our platform. If it
  doesn't, it won't be better here.
* The database link is badly configured. If you are using our built-in database
  addons, we create an environment variable with a name following this scheme:
  `SCALINGO_{DB_TYPE}_URL`. Your application must use this value or you can
  rename it to fit your needs.
