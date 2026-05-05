---
index: 20
nav: Working With Private Networks
title: Working With Private Networks
modified_at: 2026-01-21 12:00:00
---


{% note %}
The following explanations exclusively apply to Private Networks.\\
For a higher level point of view, please see our
[overview][private-networking-overview].
{% endnote %}

Although Private Networks handle basic web applications effectively, their real
strength emerges in microservices-oriented architectures involving numerous
applications and services.

At Scalingo, all containers always have two network interfaces:
- One in the **`172.17.0.0/16`** CIDR block, allowing the container to
  communicate with resources located outside of the Private Network.
- One in the **`10.240.0.0/22`** CIDR block, allowing the container to
  communicate within the Private Network.

When starting a [process type][procfile], it's really important to **make it
listen on the appropriate interface** to ensure security and confidentiality.


## Keeping an Application Private

To keep an application private, so that it's only available on the Private
Network, two conditions **must** be met:

1. The process type must **not** be named `web`, `tcp` or `postdeploy`.
2. The process type must listen on the `10.240.x.y` interface.

These two rules can be translated into the following guidelines:

- Since a `web` process type is often created by default by the buildpack, make
  sure to disable it by [scaling it to zero][scaling-h].

- Create the process type by editing your [`Procfile`][procfile]. Specify a
  meaningful process type name and the corresponding command.

- Configure the listening interface and port. Any TCP/UDP port can be used on
  the Private Network, including ports below `1024`. This step highly depends
  on the software or library the application is using:
  - For applications using command line flags, specify them in the `Procfile`.
  - For applications using environment variables, add them with the appropriate
    values in your [environment].
  - For applications using a configuration file, please refer to their
    documentation.

- Use the `SCALINGO_PRIVATE_HOSTNAME` environment variable to listen on the
  Private Network interface.

Once started, the application is available through its [private domain name],
on the chosen port.
The platform does not expose or advertise that port, so clients inside the
Private Network must know it beforehand (for example via configuration or a
shared registry).


## Making an Application Public

To make an application public, so that traffic from the internet can be routed to it, three
conditions **must** be met:

1. The process type must be named either `web` or `tcp` (when using our [TCP
   addon][tcp-addon]).
2. The process type must listen on `0.0.0.0`.
3. The process type must listen on the given port number, available through the
   `$PORT` environment variable.

These three rules conform to the default behavior of most buildpacks, so you
most probably don't have anything more to do.

For custom buildpacks and deployments, here are a few guidelines:

- Ensure you either have a `web` (or `tcp`) process type in your
  [`Procfile`][procfile], or that the buildpack's `bin/release` file defines
  one.

- Ensure the process listens on `0.0.0.0:$PORT`. This step highly depends
  on the application:
  - For applications using command line flags, ensure they are specified in the
    `Procfile` or in the `bin/release` script of the buildpack.
  - For applications using environment variables, make sure you have them with
    the appropriate values in your [environment].
  - For applications using a configuration file, please refer to their
    documentation.

Once started, the application is available through its [default public domain
name] or a [custom one][custom-domain-name] if it has been setup. Since the
platform handles [public routing], the port numbers are the standard ones (i.e.
`80` for `http` and `443` for `https`).


## Making an Application Both Private and Public

Two main strategies can work when trying to make an application available both
in and out of the Private Network. The [first
strategy](#using-multiple-process-types) involves creating at least two
[process types][procfile], while the [second one](#using-a-unique-process-type)
only requires a single process type.

### Using Multiple Process Types

This strategy consists in creating at least two process types:

1. The first one is dedicated to the Private Network, and must follow the rules
   to [keep an application private](#keeping-an-application-private).
2. The second one is dedicated to the public, and must follow the
   rules to [make an application public](#making-an-application-public).

This strategy is generally best-suited for situations where you application
reserves some endpoints for public or private use. It also allows to scale your
public and private process types differently, both horizontally and vertically.
On the other hand, spawning more containers induce additional costs.

### Using a Unique Process Type

This strategy is a bit more complex, but has the benefit to only require one
process type.

This unique process type must follow the rules to [make an application
public](#making-an-application-public).

Since the application is listening on `0.0.0.0:$PORT`, it's also listening on
the `10.240.x.y/22` interface, which means the application **is** actually
already available from within the Private Network.

While resources within the same Private Network can access the application via
its [private domain name], they still need a way to figure out which port is
used (`$PORT` hereabove).

As service discovery within a Private Network is not currently provided as a
built-in capability, this opens the door for a flexible and lightweight
approach, tailored to your needs.

One effective option is for the application to register itself in a *shared
registry* at startup, thereby exposing the port it is using. This information
allows other services to reliably connect to the application using its private
domain name along with the correct port number.

Implementing this registration approach and maintaining the *shared registry*
up-to-date are left to the responsibility of the user.

This strategy has proven to be more effective when costs become an issue. It
also simplifies connectivity and service coordination across the Private
Network.


*[CIDR]: Classless Inter-Domain Routing

[procfile]: {% post_url platform/app/2000-01-01-procfile %}
[routing]: {% post_url platform/networking/public/2000-01-01-routing %}
[default public domain name]: {% post_url platform/networking/public/domains/2000-01-01-default %}
[custom-domain-name]: {% post_url platform/networking/public/domains/2000-01-01-custom %}
[private-networking-overview]: {% post_url platform/networking/private/2000-01-01-overview %}
[private domain name]: {% post_url platform/networking/private/2000-01-01-concepts %}#private-domain-names
[environment]: {% post_url platform/app/2000-01-01-environment %}
[scaling-h]: {% post_url platform/app/scaling/2000-01-01-scaling %}#scaling-horizontally
[tcp-addon]: {% post_url addons/tcp-gateway/2000-01-01-start %}
