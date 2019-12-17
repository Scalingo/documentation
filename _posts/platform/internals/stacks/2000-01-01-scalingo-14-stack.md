---
title: Scalingo-14 Stack
nav: Scalingo-14
modified_at: 2019-12-15 00:00:00
index: 3
---

{% warning %}
  Scalingo-14 support ended on December 2019. If you're still using this stack, you [must upgrade]({% post_url platform/internals/stacks/2000-01-01-stacks %}#migrating-to-a-new-stack).
{% endwarning %}

This article describes the scalingo-14 stack, based on Ubuntu 14.04. [What is a stack?]({% post_url platform/internals/stacks/2000-01-01-stacks %})

## Support period

Scalingo-14 is based on Ubuntu 14.04. Official support ended on December 2019.

## Testing and upgrading your app

Learn how to test and [upgrade your app]({% post_url platform/internals/stacks/2000-01-01-stacks %}#migrating-to-a-new-stack) to scalingo-14.

##  Docker Image

This base image is a completely standard Docker image. You can run it locally with this command:

```
docker pull scalingo/builder
```

## Ubuntu Packages

The following table lists available packages and versions for the stack scalingo-14.

In general, apps do not typically interact directly with this level of operating system services. Certain app dependencies may, as well as apps that directly rely on the underlying operating system. The list below is provided to document the available operating system packages.

{: .table }
| Name | Version |
| ---- | ------- |
{% include scalingo_14_stack_packages.md %}
