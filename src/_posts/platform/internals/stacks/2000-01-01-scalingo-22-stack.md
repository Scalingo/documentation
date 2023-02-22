---
title: Scalingo-22 Stack
nav: Scalingo-22
modified_at: 2023-01-11 00:00:00
index: 2
---

This article describes the scalingo-22 stack, based on Ubuntu 22.04. [What is a stack?]({% post_url platform/internals/stacks/2000-01-01-stacks %})

## Support Period

scalingo-22 is based on Ubuntu 22.04. It will be supported through April 2027.

## Testing and Upgrading Your App

Learn how to test and [upgrade your app]({% post_url platform/internals/stacks/2000-01-01-stacks %}#migrating-to-a-new-stack) to scalingo-22.

## Docker Image

This base image is a completely standard Docker image. You can run it locally with this command:

```
docker pull scalingo/scalingo-22:latest
docker run --rm -it scalingo/scalingo-22:latest bash
```

## Ubuntu Packages

The following table lists available packages and versions for the stack scalingo-22.

In general, apps do not typically interact directly with this level of operating system services. Some app dependencies may, as well as apps that directly rely on the underlying operating system. The list below is provided to document the available operating system packages.

<div class="overflow-horizontal-content" markdown="1">
{: .table }
| Name | Version |
| ---- | ------- |
{% include scalingo_22_stack_packages.md %}
</div>
