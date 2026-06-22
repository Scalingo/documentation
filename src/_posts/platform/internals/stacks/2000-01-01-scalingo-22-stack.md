---
title: Scalingo-22 Stack
nav: scalingo-22
modified_at: 2026-06-10 00:00:00
index: 4
---

{% warning %}
The {% scalingo 22 %} stack is now **[deprecated][stack-lifecycle]**. It will
be [discontinued][stack-lifecycle] on June 1, 2027.

We strongly encourage migrating to {% scalingo 24 %} or later as soon as
possible.
{% endwarning %}

The {% scalingo 22 %} [stack] is based on Ubuntu 22.04 Long-Term Support.


## Lifecycle

{% scalingo 22 %} is currently **[deprecated][stack-lifecycle]**.

| Status                                               | From          | Through      |
| ---------------------------------------------------: | ------------: | -----------: |
| <span class="stack supported">Supported</span>       | May 2022      | May 2026     |
| <span class="stack deprecated">**Deprecated**</span> | **June 2026** | **May 2027** |
| <span class="stack discontinued">Discontinued</span> | June 2027     | -            |


## Docker Image

This base image is a completely standard Docker image. The image is available
on [Docker Hub]. You can run it locally with this command:

```shell
docker pull scalingo/scalingo-22:latest
docker run --rm -it scalingo/scalingo-22:latest bash
```

## Packages

The following table lists available packages and versions for the stack
{% scalingo 22 %}.

| Name | Version |
| ---- | ------- |
{% include scalingo_22_stack_packages.md %}


*[LTS]: Long-Term Support

[Docker Hub]: https://hub.docker.com/r/scalingo/scalingo-24

[stack]: {% post_url platform/internals/stacks/2000-01-01-overview %}
[stack-lifecycle]: {% post_url platform/internals/stacks/2000-01-01-overview %}#lifecycle

