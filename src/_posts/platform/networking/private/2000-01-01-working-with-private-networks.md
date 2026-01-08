---
index: 20
nav: Working With Private Networks
title: Working With Private Networks
modified_at: 2026-01-06 12:00:00
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

When starting a [process type][procfile], it's really important to **make sure
it listens on the appropriate interface**.

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

Two main strategies can work when trying to make an application available both
in and out of the Private Network. The [first
strategy](#using-multiple-process-types) involves creating at least two
[process types][procfile], while the [second one](#using-a-unique-process-type)
only requires a single process type.

#### Using Multiple Process Types

This strategy consists in creating at least two process types:

1. The first one is dedicated to the Private Network, and must follow the rules
   to [keep an application private](#keeping-an-application-private).
2. The second one is dedicated to the public, and must follow the
   rules to [make an application public](#making-an-application-public).

This strategy is generally best-suited for situations where you application
reserves some endpoints for public or private use. It also allows to scale your
public and private process types differently, both horizontally and vertically.
On the other hand, spawning more containers induce additional costs.

#### Using a Unique Process Type

This strategy is a bit more complex, but has the benefit to only require one
process type.

This unique process type must follow the rules to [make an application
public](#making-an-application-public).

Since the application is listening on `0.0.0.0:$PORT`, it's also listening on
the `10.240.x.y/22` interface, which means the application **is** actually
directly available from within the Private Network.

Although resources in the same Private Network can reach the app using its
[private domain name], the issue is that these resources have no way to know
the **port** on which the application listens (`$PORT` hereabove), and we
currently don't provide any out-of-the-box features to ease the discovery of
available services in a Private Network.

To circumvent this, the idea is to make the app register itself in a *common
register* (e.g. a database) when starting, so that other services know the port
the application is using. They would then be able to reach it using the
application's private domain name and the appropriate port number.

Implementing this registration approach and maintaining the *common register*
up-to-date are left to the responsibility of the user.

This strategy has proven to be more effective when costs become an issue.


*[CIDR]: Classless Inter-Domain Routing

[procfile]: {% post_url platform/app/2000-01-01-procfile %}
[default public domain name]: {% post_url platform/networking/public/domains/2000-01-01-default %}
[custom-domain-name]: {% post_url platform/networking/public/domains/2000-01-01-custom %}
[private-networking-overview]: {% post_url platform/networking/private/2000-01-01-overview %}
[private domain name]: {% post_url platform/networking/private/2000-01-01-concepts %}#private-domain-names

