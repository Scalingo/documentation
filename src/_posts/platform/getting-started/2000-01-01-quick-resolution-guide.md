---
title: Quick Resolution Guide
modified_at: 2026-04-30 00:00:00
tags: getting-started deployment troubleshoot quick resolution
index: 7
---

This guide helps you identify common first-deployment issues and points you to
the right detailed troubleshooting page.

## Before the Deployment Starts

Before troubleshooting a deployment failure, make sure Git is installed and
your SSH keys are configured correctly. Follow the
[First Steps guide]({% post_url platform/getting-started/2000-01-01-first-steps %})
to check these requirements.

If `git push` fails with an authentication error, a missing branch, an invalid
SSH key, or `Permission denied (public key)`, see the
[Git push and SSH troubleshooting guide]({% post_url platform/getting-started/2000-01-01-troubleshooting-ssh %}).


## Unknown Technology

If the deployment fails because Scalingo cannot detect your technology, check
that the expected files are in the application root directory.

Scalingo detects and builds your application from the repository root by
default. If your application lives in a subdirectory of your Git repository,
configure the `PROJECT_DIR` environment variable.

See [Unknown Technology]({% post_url platform/app/troubleshooting/2000-01-01-deployment-issues %}#unknown-technology)
and the [monorepo deployment guide]({% post_url platform/app/2000-01-01-monorepo %}).


## Build Errors

If the buildpack exits with an error, the deployment logs should contain the
error returned by the buildpack or your dependency manager.

See [Build Errors]({% post_url platform/app/troubleshooting/2000-01-01-deployment-issues %}#build-errors).


## Required Files for Each Language

Each language has its own expected files and conventions. Check the start page
for your application language:

{% include language_start_pages.md %}


## Boot Timeout

If your application builds successfully but does not start, make sure the web
server binds to `$PORT` within 60 seconds and listens on `0.0.0.0`.

The [Procfile]({% post_url platform/app/2000-01-01-procfile %}) defines how the
platform should start your application's containers. For a web application,
make sure your `web` process:

* starts the server in the foreground.
* binds to the `PORT` environment variable.
* listens on `0.0.0.0` and not on `127.0.0.1`.

If your application does not need a `web` or `tcp` process type, make sure to
[scale the unnecessary process type to zero]({% post_url platform/app/2000-01-01-web-less-app %}#deploy-a-web-less-application).

See [Timeout Errors]({% post_url platform/app/troubleshooting/2000-01-01-boot-and-startup-errors %}#timeout-errors).


## Startup Crash

If the application starts and then stops unexpectedly, check the deployment logs
and application logs. Common causes include syntax errors, import errors,
misconfigured database URLs, or an incorrect start command.

See [Boot and Startup Errors]({% post_url platform/app/troubleshooting/2000-01-01-boot-and-startup-errors %}).
