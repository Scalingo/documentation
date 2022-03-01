---
title: Scalingo-18 Stack
nav: Scalingo-18
modified_at: 2022-03-01 00:00:00
index: 3
---

This article describes the scalingo-18 stack, based on Ubuntu 18.04. [What is a stack?]({% post_url platform/internals/stacks/2000-01-01-stacks %})

## Support Period

scalingo-18 is based on Ubuntu 18.04. It will be supported through April 2023.

## Testing and Upgrading Your App

Learn how to test and [upgrade your app]({% post_url platform/internals/stacks/2000-01-01-stacks %}#migrating-to-a-new-stack) to scalingo-18.

## Docker Image

This base image is a completely standard Docker image. You can run it locally with this command:

```
docker pull scalingo/scalingo-18:latest
docker run --rm -it scalingo/scalingo-18:latest bash
```

## Ubuntu Packages

The following table lists available packages and versions for the stack scalingo-18.

In general, apps do not typically interact directly with this level of operating system services. Some app dependencies may, as well as apps that directly rely on the underlying operating system. The list below is provided to document the available operating system packages.

{: .table }
| Name | Version |
| ---- | ------- |
{% include scalingo_18_stack_packages.md %}
