---
title: Boot and Startup Errors
modified_at: 2026-04-10 00:00:00
tags: troubleshooting crash startup boot timeout hook
index: 3
---

Boot and Startup Errors occur when the platform tries to start your application's containers, before they reach the *running* state.

For a broader overview, see [Troubleshooting Your Application]({% post_url platform/app/2000-01-01-troubleshooting %}). If the deployment fails before the containers are started, see [Deployment Issues]({% post_url platform/app/troubleshooting/2000-01-01-deployment-issues %}). If your application starts successfully and fails later, see [Runtime Issues]({% post_url platform/app/troubleshooting/2000-01-01-runtime-issues %}).

There are 3 kinds of Boot and Startup Errors:
[Start Errors](#understanding-start-errors),
[Timeout Errors](#understanding-timeout-errors) and
[Hook Errors](#understanding-hook-errors).

## Understanding Start Errors

The **Start Error** is the default kind of Boot Error. It is thrown as soon as
an unmanaged error is detected and caught by the platform. It can occur at any
moment, as long as your app isn't *running* yet.

A Start Error makes the deployment fail instantly. Note that the former version
of your application (if any), keeps running.

In most cases, a Start Error is caused by a misconfiguration of your
application, or by some unmanaged error/exception in your application's code.

### Fixing Start Errors

It's very likely that an action on your side is required to fix the issue. The
deployment logs should help you identify the issue.

## Understanding Timeout Errors

When your application has a [`web` or a `tcp` process type]({% post_url platform/app/2000-01-01-procfile %}#special-process-types),
the process started in the corresponding container(s) **MUST** bind to the
provided network port (`PORT` environment variable) within a delay of 60
seconds. After this deadline, the platform considers the application has being
unreachable and throws a **Timeout Error**, causing the deployment to fail.

- If this situation arises after a restart or a scale operation, the platform
  automatically retries to start your container(s). After 20 unsuccessful
  attempts (with an exponential backoff strategy), the platform gives up.
  Note that your existing containers keep running during this time and after.

- If you are trying to deploy a new version of an already running application,
  this new deployment is considered a failure but the previous version of your
  application keeps running.

- Conversely, if this is a very first deployment, the platform does not make
  any attempt to recover from the error. The deployment fails with a
  **timeout-error** status, letting you know that your application didn't
  bind to `PORT` soon enough.

{% note %}
  A Timeout Error can only occur if you have a `web` or a `tcp` process type,
  which is very likely.
{% endnote %}

### Fixing Timeout Errors

To fix a Timeout Error, make sure:
- to bind to the provided network port, by using the `PORT` environment
  variable.
- to listen on `0.0.0.0` and not on `127.0.0.1`.
- that your application is starting quickly enough.

You may need to edit your
[Procfile]({% post_url platform/app/2000-01-01-procfile %}) to fulfill these
requirements.

If your application doesn't need a `web` or `tcp` process type, make sure to
[scale the unnecessary process type to zero]({% post_url platform/app/2000-01-01-web-less-app %}#deploy-a-web-less-application).

## Understanding Hook Errors

If your application has a [`postdeploy` process type]({% post_url platform/app/2000-01-01-procfile %}#special-process-types),
the platform can throw a **Hook Error** if the post-deployment process fails.

- In such a case, the deployment fails with a **hook-error** status.
- If your application is already running, its code isn't updated and the former
  version keeps running.

{% note %}
  Hook Errors can only occur if you have a `postdeploy` process type.
{% endnote %}

### Fixing Hook Errors

Hook Errors are generally caused by an error in your codebase or by some
misconfiguration. To recover from it, we first advise to investigate the logs
of your application to understand the root cause. After fixing it, trigger a
new deployment by pushing your updated code to Scalingo.
