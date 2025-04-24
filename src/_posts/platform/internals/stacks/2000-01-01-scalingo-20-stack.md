---
title: Scalingo-20 Stack
nav: Scalingo-20
modified_at: 2025-05-01 00:00:00
index: 3
---

{% warning %}
The scalingo-20 stack, based on the Ubuntu 20.04 LTS operating system, is now deprecated.
Migrate to a [newer stack]({% post_url platform/internals/stacks/2000-01-01-stacks %}) as soon as possible. See the [Deprecation Plan]({% post_url platform/internals/stacks/2000-01-01-scalingo-20-stack %}#deprecation-plan) for details.
{% endwarning %}

This article describes the scalingo-20 stack, based on Ubuntu 20.04 LTS. [What is a stack?]({% post_url platform/internals/stacks/2000-01-01-stacks %})

## Support Period

scalingo-20 is based on Ubuntu 20.04. It will be supported through April 2025.

## Deprecation Plan

### May 2025: Usage Exemption For Legacy Apps

Ubuntu 20.04 LTS and scalingo-20 officially reach end-of-life and will no longer receive updates.
From this date, it is no longer possible to select this stack to create new applications.
Existing applications using the scalingo-20 stack will continue to function normally, with the ability to create new deployments or Review Apps on this version.

### January 2026: End of Usage Exemption
From this date, no new deployments are allowed on the scalingo-20 stack. Deployments made before this date continue to function, but using a supported stack becomes mandatory for any new deployment.


## Testing and Migrating Your App

Learn how to test and [migrate your app]({% post_url platform/internals/stacks/2000-01-01-stacks %}#migrating-to-a-new-stack) to scalingo-20.

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
