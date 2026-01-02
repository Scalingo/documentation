---
index: 20
nav: Working With Private Networks
title: Working With Private Networks
modified_at: 2025-12-30 12:00:00
---


{% note %}
The following explanations exclusively apply to Private Networks.\\
For a higher level point of view, please see our
[overview][private-networking-overview].
{% endnote %}


Although Private Networks handle basic web applications effectively, their real
strength emerges in microservices-oriented architectures involving numerous
applications and services.

Some extra care must be taken in such cases, especially to ensure security and
confidentiality.


## Listening on the Appropriate Interface

At Scalingo, all containers always have two network interfaces:
- One in the **`172.17.0.0/16`** CIDR block, allowing the container to
  communicate with resources located outside of the Private Network.
- One in the **`10.240.0.0/22`** CIDR block, allowing the container to
  communicate within the Private Network.

When starting a [process type], it's really important to **make sure it listens
on the appropriate interface**.

### Keeping an Application Private

To keep an application private, so that it's only available on the Private
Network, two conditions **must** be met:

1. The process type must **not** be named `web`, `tcp` or `postdeploy`.
2. The process type must listen on the `10.240.x.y` interface.

The process type can listen on any available port, and can use any protocol.
The application is available through its [private domain name], on the chosen
port.

### Making an Application Public

To make an application public, so that traffic can be routed to it, three
conditions **must** be met:

1. The process type must be named either `web` or `tcp` (when using our TCP
   addon).
2. The process type must listen on `0.0.0.0`.
3. The process type must listen on `$PORT`.

The application is available through its [default public domain name] or a
[custom one][custom-domain-name], if it has been setup.

### Making an Application Both Private and Public

There are multiple solutions to make an application both public and private.

FIXME: paused until we decide what we do.



*[CIDR]: Classless Inter-Domain Routing

[process type]: {% post_url platform/app/2000-01-01-procfile %}
[default public domain name]: {% post_url platform/networking/public/domains/2000-01-01-default %}
[custom-domain-name]: {% post_url platform/networking/public/domains/2000-01-01-custom %}
[private-networking-overview]: {% post_url platform/networking/private/2000-01-01-overview %}
[private domain name]: {% post_url platform/networking/private/2000-01-01-concepts %}#private-domain-names
