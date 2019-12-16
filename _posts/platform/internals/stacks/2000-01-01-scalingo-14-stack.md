---
title: Scalingo-14 Stack
nav: Scalingo-14
modified_at: 2019-12-15 00:00:00
index: 2
---

{% warning %}
  Scalingo-14 support ended on December. If you're still using this stack, you [must upgrade]({% post_url platform/internals/stacks/2000-01-01-stacks %}).
{% endwarning %}

This article describes the scalingo-14 stack, based on Ubuntu 14.04. [What is a stack?]({% post_url platform/internals/stacks/2000-01-01-stacks %}).

## Support period

Scalingo-14 is based on Ubuntu 14.04. It will be supported through April 2023. Learn more about Scalingo’s stack update policy.
Testing and upgrading your app

Learn how to test and upgrade your app to Scalingo-14.

## Scalingo-14 Docker Image

Scalingo-14 is available as two Docker images:

    The runtime image is recommended for most workloads.
    The build image (heroku/heroku:14-build) is larger and includes development headers. It is only recommended for customers that need to compile source code.

Use the following command in your Dockerfile to use Scalingo-14 as your base image:

FROM heroku/heroku:14

Learn more about deploying Docker images to Scalingo.

## Ubuntu Packages on Scalingo-14

The following table lists available packages and versions for the stack Scalingo-14.

In general, apps do not typically interact directly with this level of operating system services. Certain app dependencies may, as well as apps that directly rely on the underlying operating system. The list below is provided to document the available operating system packages.

{: .table }
| Name | Version |
| ---- | ------- |
{% include scalingo_14_stack_packages.md %}
