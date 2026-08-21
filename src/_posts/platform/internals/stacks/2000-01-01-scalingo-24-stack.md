---
title: Scalingo-24 Stack
nav: scalingo-24
modified_at: 2026-06-22
index: 3
---


The {% scalingo 24 %} [stack] is based on Ubuntu 24.04 Long-Term Support.


## Lifecycle

{% scalingo 24 %} is currently **[supported][stack-lifecycle]**.

| Status                                               | From          | Through      |
| ---------------------------------------------------: | ------------: | -----------: |
| <span class="stack supported">**Supported**</span>   | **May 2025**  | **May 2028** |
| <span class="stack deprecated">Deprecated</span>     | June 2028     | May 2029     |
| <span class="stack discontinued">Discontinued</span> | June 2029     | -            |


## Docker Image

This base image is a completely standard Docker image. The image is available
on [Docker Hub]. You can run it locally with this command:

```shell
docker pull scalingo/scalingo-24:latest
docker run --rm -it scalingo/scalingo-24:latest bash
```

## Packages

The following table lists available packages and versions for the stack
{% scalingo 24 %}.

| Name | Version |
| ---- | ------- |
{% include scalingo_24_stack_packages.md %}


*[LTS]: Long-Term Support

[Docker Hub]: https://hub.docker.com/r/scalingo/scalingo-24

[stack]: {% post_url platform/internals/stacks/2000-01-01-overview %}
[stack-lifecycle]: {% post_url platform/internals/stacks/2000-01-01-overview %}#lifecycle
