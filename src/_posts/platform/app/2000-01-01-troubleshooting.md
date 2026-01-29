---
title: Troubleshooting Your Application
modified_at: 2025-12-31 00:00:00
tags: troubleshooting errors crash deployment
index: 15
---

This page provides a summary of common issues you might encounter while deploying or running your application on Scalingo, along with links to more detailed guides.

## Deployment Issues

Deployment issues usually happen during the build phase, before your application is even started.

* **Unknown Technology**: Occurs when Scalingo cannot detect the programming language or framework of your application.
* **Image Too Large**: Your application image exceeds the 1.5 GiB limit.
* **Archive Too Large**: The source code archive (uncompressed) exceeds the 300 MB limit.

For more details on how to fix these, see our [Common Deployment Errors]({% post_url platform/getting-started/2000-01-01-common-deployment-errors %}) page.

## Boot and Startup Errors

These errors occur when the platform tries to start your application's containers.

* **Start Errors**: Generic errors during the startup process, often due to misconfiguration.
* **Timeout Errors**: Your application failed to bind to the assigned `PORT` within 60 seconds.
* **Hook Errors**: Failure of a `postdeploy` hook script.

Detailed information and fixes can be found in the [Application Crash]({% post_url platform/app/2000-01-01-crash %}#understanding-boot-errors) documentation.

## Runtime Issues

Runtime issues happen while your application is already running.

* **Application Crashes**: Unexpected termination of your application process.
* **5xx Errors**: Server-side errors that might be related to application crashes or timeouts.

Learn how to diagnose and recover from these in the [Application Crash]({% post_url platform/app/2000-01-01-crash %}#understanding-runtime-errors) section.

## Other Common Problems

* **SSH Connectivity**: Issues when trying to access your containers via SSH or pushing code. See [Troubleshooting SSH]({% post_url platform/getting-started/2000-01-01-troubleshooting-ssh %}).
* **Custom Error Pages**: If you want to customize the 502, 503, or 504 error pages displayed to your users, refer to [Custom Error and Maintenance Pages]({% post_url platform/app/2000-01-01-custom-error-page %}).
