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

With Dedicated Resources, inbound connectivity is controlled through a 
**fine-grained firewall** that follows an allowlist model.

{% note %}
The Dedicated Resources architecture model is currently available for Scalingo 
for PostgreSQL® only, and only to selected customers.
To request access or learn more, please contact our [Support](mailto:support@scalingo.com) or [Sales](https://scalingo.com/book-a-demo) teams.
{% endnote %}

### How the Firewall Works

The firewall follows an allowlist model: you define allowed source networks
with CIDR notation (single IPs or ranges), and only matching sources can reach
the database endpoint.

You can configure up to **30 firewall rules** per
database, and rule changes usually propagate in around 2 minutes.

Here are common CIDR formats you can use in firewall rules:

- Single IP: `203.0.113.10/32` (`/32` means one exact IPv4 address)
- IP range: `203.0.113.0/24` (`/24` means a subnet of 256 IPv4 addresses)
- Allow all (not recommended): `0.0.0.0/0` (`/0` means all IPv4 addresses; this
  effectively disables firewall filtering)

### Allowing Scalingo Apps To Reach a Dedicated Resources Database

If a Scalingo app must connect to a Dedicated Resources database, you need to 
allow inbound connections from the app [region's egress IP addresses][egress].

To keep the service simple and maintenance-free, Scalingo provides a
**managed rule** type that automatically allowlists egress IPs for a region.

Two managed rules are available:

- `Scalingo osc-fr1 region`
- `Scalingo osc-secnum-fr1 region`

Workflow:

1. Identify the app region (for example `osc-fr1` or `osc-secnum-fr1`).
2. Add the matching **managed rule** in the Dedicated Resources firewall.
3. Add custom CIDR rules only for additional non-Scalingo sources (office IPs,
   VPN, etc.).

A database in `osc-fr1` can accept traffic from an app in `osc-secnum-fr1` (and
the other way around) as long as the corresponding managed rule is present.

{% note %}
With managed rules, Scalingo maintains the underlying egress IP list for you.
You do not need to manually track egress IP changes for these rules.
{% endnote %}


[architecture-models]: {% post_url databases/about/2000-01-01-architecture-models %}
[database-features]: {% post_url databases/about/2000-01-01-features %}
[egress]: {% post_url platform/networking/public/2000-01-01-egress %}
[access-your-database]: {% post_url platform/databases/2000-01-01-access %}
