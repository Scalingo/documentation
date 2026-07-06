---
title: Scalingo-26 Stack
nav: Scalingo-26
modified_at: 2026-07-06 00:00:00
index: 2
---

This article describes the scalingo-26 stack, based on Ubuntu 26.04. [What is a stack?]({% post_url platform/internals/stacks/2000-01-01-stacks %})

## Support Period

scalingo-26 is based on Ubuntu 26.04. It will be supported through May 2031.

## Testing and Migrating Your App

Learn how to test and [migrate your app]({% post_url platform/internals/stacks/2000-01-01-stacks %}#migrating-to-a-new-stack) to scalingo-26.

## Docker Image

This base image is a completely standard Docker image. The image is available on [Docker Hub](https://hub.docker.com/r/scalingo/scalingo-26). You can run it locally with this command:

```
docker pull scalingo/scalingo-26:latest
docker run --rm -it scalingo/scalingo-26:latest bash
```

## Ubuntu Packages

The following table lists available packages and versions for the stack scalingo-26.

In general, apps do not typically interact directly with this level of operating system services. Some app dependencies may, as well as apps that directly rely on the underlying operating system. The list below is provided to document the available operating system packages.

<div class="overflow-horizontal-content" markdown="1">
{: .table }
| Name | Version |
| ---- | ------- |
{% include scalingo_26_stack_packages.md %}
</div>
