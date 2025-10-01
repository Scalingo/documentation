---
title: Scalingo-24 Stack
nav: Scalingo-24
modified_at: 2025-09-17 00:00:00
index: 2
---

This article describes the scalingo-24 stack, based on Ubuntu 24.04. [What is a stack?]({% post_url platform/internals/stacks/2000-01-01-stacks %})

## Support Period

scalingo-24 is based on Ubuntu 24.04. It will be supported through April 2029.

## Testing and Migrating Your App

Learn how to test and [migrate your app]({% post_url platform/internals/stacks/2000-01-01-stacks %}#migrating-to-a-new-stack) to scalingo-24.

## Docker Image

This base image is a completely standard Docker image. You can run it locally with this command:

```
docker pull scalingo/scalingo-24:latest
docker run --rm -it scalingo/scalingo-24:latest bash
```

## Ubuntu Packages

The following table lists available packages and versions for the stack scalingo-24.

In general, apps do not typically interact directly with this level of operating system services. Some app dependencies may, as well as apps that directly rely on the underlying operating system. The list below is provided to document the available operating system packages.

<div class="overflow-horizontal-content" markdown="1">
{: .table }
| Name | Version |
| ---- | ------- |
{% include scalingo_24_stack_packages.md %}
</div>
