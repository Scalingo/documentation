---
title: Scalingo-14 Stack
nav: Scalingo-14
modified_at: 2023-01-11 00:00:00
index: 5
---

{% warning %}
  Scalingo-14 support ended on December 2019. If you're still using this stack, you [must upgrade]({% post_url platform/internals/stacks/2000-01-01-stacks %}#migrating-to-a-new-stack).
{% endwarning %}

This article describes the scalingo-14 stack, based on Ubuntu 14.04. [What is a stack?]({% post_url platform/internals/stacks/2000-01-01-stacks %})

## Support Period

Scalingo-14 is based on Ubuntu 14.04. Official support ended on December 2019.

## Testing and Upgrading Your App

Learn how to test and [upgrade your app]({% post_url platform/internals/stacks/2000-01-01-stacks %}#migrating-to-a-new-stack) to scalingo-18.

##  Docker Image

This base image is a completely standard Docker image. You can run it locally with this command:

```
docker pull scalingo/scalingo-14
```

## Ubuntu Packages

The following table lists available packages and versions for the stack scalingo-14.

In general, apps do not typically interact directly with this level of operating system services. Some app dependencies may, as well as apps that directly rely on the underlying operating system. The list below is provided to document the available operating system packages.

<div class="overflow-horizontal-content" markdown="1">
{: .table }
| Name | Version |
| ---- | ------- |
{% include scalingo_14_stack_packages.md %}
</div>
