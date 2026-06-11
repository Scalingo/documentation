---
title: Database Network Exposure
nav: Network Exposure
modified_at: 2026-06-04 00:00:00
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

|                           | [Shared Resources](#shared-resources)        | [Dedicated Resources](#dedicated-resources)             |
|---------------------------|----------------------------------------------|---------------------------------------------------------|
| Default reachability      | Reachable from the Scalingo regional network | Not reachable by default (no internal or public access) |
| Public Internet access    | Enable/disable, no source filtering          | Denied by default, allowed only via firewall            |
| Force TLS                 | Disabled by default                          | Enabled by default                                      |

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

{% note %}
The Dedicated Resources architecture model is currently available for Scalingo 
for PostgreSQL® only, and only to selected customers.
To request access or learn more, please contact our [Support](mailto:support@scalingo.com) or [Sales](https://scalingo.com/book-a-demo) teams.
{% endnote %}

### How the Firewall Works

With Dedicated Resources, the database endpoint is Internet-routable, but
inbound traffic is denied by default. Access is controlled through a
**fine-grained firewall** that follows an allowlist model: every incoming
connection must match an explicit rule.

### Allowing Scalingo Apps To Reach a Database

Dedicated Resources databases are not reachable from the Scalingo network by
default. If a Scalingo app must connect to the database, add the managed
firewall rule for the app region.

This rule allows the Scalingo regional network, so the database becomes
reachable at the network level from any Scalingo app hosted in that region.

### Making Your Database Reachable from the Internet

1. Open only required source networks in the firewall allowlist.
2. If needed, add managed rules for Scalingo regions.


[architecture-models]: {% post_url databases/about/2000-01-01-architecture-models %}
[database-features]: {% post_url databases/about/2000-01-01-features %}
[access-your-database]: {% post_url platform/databases/2000-01-01-access %}
