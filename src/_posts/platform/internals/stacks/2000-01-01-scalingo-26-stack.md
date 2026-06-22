---
title: Scalingo-26 Stack
nav: scalingo-26
modified_at: 2026-06-22
index: 2
---

The {% scalingo 26 %} [stack] is based on Ubuntu 26.04 Long-Term Support.

It's currently the default stack when deploying applications on Scalingo.


## Lifecycle

{% scalingo 26 %} is currently **[supported][stack-lifecycle]**.

| Status                                               | From          | Through      |
| ---------------------------------------------------: | ------------: | -----------: |
| <span class="stack supported">**Supported**</span>   | **May 2026**  | **May 2031** |
| <span class="stack deprecated">Deprecated</span>     | June 2031     | May 2032     |
| <span class="stack discontinued">Discontinued</span> | June 2032     | -            |


## Docker Image

This base image is a completely standard Docker image. The image is available
on [Docker Hub]. You can run it locally with this command:

```shell
docker pull scalingo/scalingo-26:latest
docker run --rm -it scalingo/scalingo-26:latest bash
```

## Packages

The following table lists available packages and versions for the stack
{% scalingo 26 %}.

| Name | Version |
| ---- | ------- |
{% include scalingo_26_stack_packages.md %}


*[LTS]: Long-Term Support

[Docker Hub]: https://hub.docker.com/r/scalingo/scalingo-26

[stack]: {% post_url platform/internals/stacks/2000-01-01-overview %}
[stack-lifecycle]: {% post_url platform/internals/stacks/2000-01-01-overview %}#lifecycle
