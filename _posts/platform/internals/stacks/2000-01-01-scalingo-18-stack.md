---
title: Scalingo-18 Stack
nav: Scalingo-18
modified_at: 2019-12-15 00:00:00
index: 2
---

{% note %}
  Scalingo-18 is the current default stack.
{% endnote %}

This article describes the Scalingo-18 stack, based on Ubuntu 18.04. [What is a stack?]({% post_url platform/internals/stacks/2000-01-01-stacks %}).

## Support period

Scalingo-18 is based on Ubuntu 18.04. It will be supported through April 2023. Learn more about Scalingo’s stack update policy.
Testing and upgrading your app

Learn how to test and upgrade your app to Scalingo-18.

## Scalingo-18 Docker Image

Scalingo-18 is available as two Docker images:

    The runtime image is recommended for most workloads.
    The build image (heroku/heroku:18-build) is larger and includes development headers. It is only recommended for customers that need to compile source code.

Use the following command in your Dockerfile to use Scalingo-18 as your base image:

FROM heroku/heroku:18

Learn more about deploying Docker images to Scalingo.

## Ubuntu Packages on Scalingo-18

The following table lists available packages and versions for the stack Scalingo-18.

In general, apps do not typically interact directly with this level of operating system services. Certain app dependencies may, as well as apps that directly rely on the underlying operating system. The list below is provided to document the available operating system packages.

{: .table }
| Name | Version |
| ---- | ------- |
{% include scalingo_18_stack_packages.md %}
