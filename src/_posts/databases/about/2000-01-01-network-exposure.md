---
title: Database Network Exposure
nav: Network Exposure
modified_at: 2026-02-09 12:00:00
tags: databases internet access accessibility public networking
index: 21
---


This page explains how **Managed Databases** can be accessed remotely at the 
network level depending on the **architecture model**.

{% note %}
This page covers only network exposure and traffic filtering rules.
For maintenance access methods: Remote Console, Encrypted Tunnel and Direct 
Access), see [Access Your Database][access-your-database].
{% endnote %}


## At a Glance

Databases are **private by default**. We apply secure connectivity settings out
of the box, so your database is not exposed unless you explicitly enable it.

|                           | Shared Resources                             | Dedicated Resources                                     |
|---------------------------|----------------------------------------------|---------------------------------------------------------|
| Default reachability      | Reachable from the Scalingo regional network | Not reachable by default (no internal or public access) |
| Public Internet access    | Enable/disable, no source filtering          | Denied by default, allowed only via firewall            |
| Force TLS                 | Disabled by default                          | Enabled by default                                      |

For *Shared Resources* and *Dedicated Resources* fundamentals, see 
[Architecture Models][architecture-models].


## Making Your Database Reachable from the Internet

It is possible to expose your database to the public Internet, but requirements
depend on your architecture model.

### Shared Resources

1. Enable [Force TLS](#tls-and-enforced-tls).
2. Enable **Internet Accessibility** from the database dashboard.
3. Use [Direct Access]({% post_url platform/databases/2000-01-01-access %}#direct-access) for client connections.

See also: [Shared Resources: Network Exposure](#shared-resources-network-exposure).

{% warning %}
Enable Internet Accessibility only for specific use cases, and only if you 
understand the security implications. It exposes your database to the public 
Internet.
{% endwarning %}

### Dedicated Resources

1. Open only required source networks in the firewall allowlist.
2. If needed, add managed rules for Scalingo regions.

See: [Dedicated Resources: Firewalling](#dedicated-resources-firewalling),
[How the Firewall Works](#how-the-firewall-works),
[Allowing Scalingo Apps To Reach a Dedicated Resources Database](#allowing-scalingo-apps-to-reach-a-dedicated-resources-database).


## TLS and Force TLS

TLS is available on Scalingo databases, but it is not always enforced by default
to maximize compatibility with application frameworks and database clients. When
**Force TLS connections** is enabled, the database denies any non-TLS 
connection, whether it comes from the Scalingo network (for example 
applications) or from the public Internet.

For multi-node clusters, intra-cluster communications are always encrypted and 
do not depend on the **Force TLS connections** setting. See
[Common Features][database-features].


## Shared Resources

Shared Resources databases are reachable from the Scalingo regional network by
default. This default setting keeps operations simple for apps in the same
region while avoiding public exposure.

Public Internet exposure is optional and controlled by the client: if
**Internet Accessibility** is enabled, the database becomes reachable from the
public Internet.

{% note %}
On Shared Resources, exposure is binary (regional network only or public
Internet) and does not include source IP filtering.
{% endnote %}


## Dedicated Resources

With Dedicated Resources, the database endpoint is Internet-routable, but
inbound traffic is denied by default. Access is controlled through a
**fine-grained firewall** that follows an allowlist model: every incoming
connection must match an explicit rule.

This also applies to traffic coming from the Scalingo network: if a Scalingo
app must connect to the database, you still need to allow it (typically with
the matching managed rule for the app region).

{% note %}
The Dedicated Resources architecture model is currently available for Scalingo 
for PostgreSQL® only, and only to selected customers.
To request access or learn more, please contact our [Support](mailto:support@scalingo.com) or [Sales](https://scalingo.com/book-a-demo) teams.
{% endnote %}


[architecture-models]: {% post_url databases/about/2000-01-01-architecture-models %}
[database-features]: {% post_url databases/about/2000-01-01-features %}
[access-your-database]: {% post_url platform/databases/2000-01-01-access %}
