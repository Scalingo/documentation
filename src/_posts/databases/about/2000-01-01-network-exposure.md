---
title: Database Network Exposure
nav: Network Exposure
modified_at: 2026-06-16 00:00:00
tags: databases internet access accessibility public networking
index: 21
---


This page explains how **Managed Databases** can be accessed remotely at the 
network level depending on the **architecture model**.

{% note %}
This page covers only network exposure and traffic filtering rules.
For maintenance access methods: Remote Console, Encrypted Tunnel and Direct
Access, see [Access Your Database][access-your-database].
{% endnote %}


## At a Glance

By default, databases are not exposed to the public Internet. We apply secure
connectivity settings out of the box, so your database is not publicly exposed
unless you explicitly enable it.

|                            | [Shared Resources](#shared-resources)        | [Dedicated Resources](#dedicated-resources)             |
|----------------------------|----------------------------------------------|---------------------------------------------------------|
| Default reachability       | Reachable from the Scalingo regional network | Not reachable by default (no internal or public access) |
| Internet-routable endpoint | Optional, through Internet Accessibility     | Available, denied by default, allowed only via firewall |
| Private peering endpoint   | Not available                                | Optional, through Outscale Net Peering                  |
| Force TLS                  | Disabled by default                          | Enabled by default                                      |

For *Shared Resources* and *Dedicated Resources* fundamentals, see 
[Architecture Models][architecture-models].


## Shared Resources

### Allowing Scalingo Apps To Reach a Database

Shared Resources databases are reachable from the Scalingo regional network by
default. Apps running in the same region can reach the database at the network
level without adding a firewall rule.

### TLS and Force TLS

On Shared Resources, TLS is available, but **Force TLS connections** is
disabled by default to maximize compatibility with application frameworks and
database clients.

When **Force TLS connections** is enabled, the database denies any non-TLS 
connection, whether it comes from the Scalingo network (for example 
applications) or from the public Internet.

For multi-node clusters, intra-cluster communications are always encrypted and
do not depend on the **Force TLS connections** setting. See
[Common Features][database-features].

### Making Your Database Reachable from the Internet

Public Internet exposure is optional. To make the database reachable from the
public Internet:

1. Enable [Force TLS](#tls-and-force-tls).
2. Enable **Internet Accessibility** from the database dashboard.
3. Use [Direct Access]({% post_url platform/databases/2000-01-01-access %}#direct-access) for client connections.

{% warning %}
Only enable this setting if your use case requires public Internet access and
you have reviewed the security implications.
{% endwarning %}


## Dedicated Resources

Dedicated Resources databases provide fine-grained control over network
exposure. By default, no application, external client, or peered network can
reach them until you explicitly allow traffic.

{% note %}
The Dedicated Resources architecture model is currently available for Scalingo 
for PostgreSQL® only, and only to selected customers.
To request access or learn more, please contact our [Support](mailto:support@scalingo.com) or [Sales](https://scalingo.com/book-a-demo) teams.
{% endnote %}

### Outscale Net Peering

In addition to their [Internet-routable endpoint][public-endpoint],
Dedicated Resources database instances can provide a [private endpoint][private-endpoint]
reachable through an [Outscale Net Peering][outscale-net-peering] from an
Outscale account in the same region as the database. This creates a private
connectivity path between the database network and an Outscale VPC.

This access path is useful when your workloads run outside Scalingo but inside
an Outscale VPC, and you want traffic to reach the database without using the
public Internet route.

### How the Firewall Works

With Dedicated Resources, the database endpoint is Internet-routable, but
inbound traffic is denied by default. Access is controlled through a
**fine-grained firewall** that follows an allowlist model: **every incoming
connection must match an explicit rule**.

Each access path requires an explicit firewall rule:

- [Scalingo apps](#allowing-scalingo-apps-to-reach-a-database): add the matching
  managed firewall rule for the app region.
- [Public Internet clients](#making-your-database-reachable-from-the-internet):
  allow only the required public source IP addresses or CIDR ranges.
- [Outscale Net Peering](#making-your-database-reachable-from-the-internet):
  allow the private IP ranges from your own Outscale network in the firewall.

### Allowing Scalingo Apps To Reach a Database

Dedicated Resources databases are not reachable from the Scalingo network by
default. If a Scalingo app must connect to the database, add the managed
firewall rule for the app region.

This rule allows the Scalingo regional network, so the database becomes
reachable at the network level from any Scalingo app hosted in that region.

### Making Your Database Reachable from External Networks {#making-your-database-reachable-from-the-internet}

1. Open only required source networks in the firewall allowlist.
2. If needed, add managed rules for Scalingo regions.


[architecture-models]: {% post_url databases/about/2000-01-01-architecture-models %}
[database-features]: {% post_url databases/about/2000-01-01-features %}
[access-your-database]: {% post_url platform/databases/2000-01-01-access %}
[outscale-net-peering]: https://docs.outscale.com/en/userguide/About-Net-Peerings.html
[public-endpoint]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-endpoints %}#public-rw
[private-endpoint]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-endpoints %}#private-peering-rw
