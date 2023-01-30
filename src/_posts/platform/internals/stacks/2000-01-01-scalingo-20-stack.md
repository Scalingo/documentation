---
title: Scalingo-20 Stack
nav: Scalingo-20
modified_at: 2023-01-11 00:00:00
index: 3
---

{% note %}
scalingo-20 is the current default stack.
{% endnote %}

This article describes the scalingo-20 stack, based on Ubuntu 20.04. [What is a stack?]({% post_url platform/internals/stacks/2000-01-01-stacks %})

## Support Period

scalingo-20 is based on Ubuntu 20.04. It will be supported through April 2025.

## Testing and Upgrading Your App

Learn how to test and [upgrade your app]({% post_url platform/internals/stacks/2000-01-01-stacks %}#migrating-to-a-new-stack) to scalingo-20.

## Docker Image

This base image is a completely standard Docker image. You can run it locally with this command:

```
docker pull scalingo/scalingo-20:latest
docker run --rm -it scalingo/scalingo-20:latest bash
```

## Ubuntu Packages

The following table lists available packages and versions for the stack scalingo-20.

In general, apps do not typically interact directly with this level of operating system services. Some app dependencies may, as well as apps that directly rely on the underlying operating system. The list below is provided to document the available operating system packages.

<div class="overflow-horizontal-content" markdown="1">
{: .table }
| Name | Version |
| ---- | ------- |
{% include scalingo_20_stack_packages.md %}
</div>
