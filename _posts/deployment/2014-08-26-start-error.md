---
title: Start Errors
modified_at: 2014-08-26 00:00:00
category: deployment
tags: app error timeout crash
order: 5
---

After creating the container image of your application, it is deployed
in our infrastructure, the following errors may happend if your application
is not configured correctly.

If something wrong happens, the first reflex to have is to look at the logs
of your app, in most of the case, all the information you need is displayed
here.

<h2>Boot Timeout</h2>

When started on our servers, your application has __60 seconds__ to bind the
port defined by the environment variable `PORT`. After this delay, we consider
that your application is not able to boot and this error happens.

### Common causes

* The server is not listening on the port defined by the environment variable
  `PORT`. Then your application is running correctly but it is not reachable.


<h2>Crash of the application</h2>

When your application starts, it may stops unexpectedly for various reasons
related to your project.

### Common causes

* Syntax error and import error in your code. Make sure that your project is
  working correctly locally before deploying it on our platform. If it
  doesn't, it won't be better here.
* The database link is badly configured. If you are using our builtin database
  addons, we create a environment variable with a name following this scheme:
  `SCALINGO_{DB_TYPE}_URL` So your application has to use this value or you can
  rename it to fit your needs.

    
