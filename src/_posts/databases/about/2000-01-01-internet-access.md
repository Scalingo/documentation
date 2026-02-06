---
title: Internet accessibility
nav: Internet access
modified_at: 2026-02-05 12:00:00
tags: databases internet access accessibility public networking
index: 21
---


This page explains how **Scalingo Managed Databases** can be accessed remotely
and how to choose a secure connectivity option depending on your needs and your
**architecture model**.


## At a Glance

Databases are **private by default**. We apply secure connectivity settings out
of the box, so your database is not exposed unless you explicitly enable it.

| Capability                | Shared Resources                             | Dedicated Resources                                     |
|---------------------------|----------------------------------------------|---------------------------------------------------------|
| Default reachability      | Reachable from the Scalingo regional network | Not reachable by default (no internal or public access) |
| Public Internet access    | Enable/disable, no source filtering          | Denied by default, allowed only via firewall            |
| TLS by default            | Disabled                                     | Enabled                                                 |
| Recommended remote access | SSH tunnel (`db-tunnel`)                     | Direct connection with firewall allowlist               |

For *Shared Resources* and *Dedicated Resource* fundamentals, see 
[Architecture Models][architecture-models].


## Recommended Connection Patterns

### Connect From Inside Scalingo (most secure)

For maintenance and investigations, prefer platform-native access (interactive
database consoles, one-off containers, etc.). This avoids public exposure and
reduces the risk of leaking credentials.

### Use an SSH Tunnel From Your Workstation

Use an SSH tunnel to make the database reachable **locally** on
`127.0.0.1:<local_port>` (default port is `10000`) while keeping the database
private.

- With the Scalingo CLI: `scalingo --app <app> db-tunnel <SCALINGO_DB_URL>`
- With OpenSSH: `ssh -L <local_port>:<db_host>:<db_port> git@<ssh_host> -p 22 -N`

This is the best option for GUI tools (pgAdmin, DBeaver, Postman, etc.) and for
short-lived debugging sessions.

{% note %}
SSH tunnels are available on Shared Resources. On Dedicated Resources, remote
access is done through a direct connection controlled by the firewall.
{% endnote %}

### Direct Connection

{% warning %}
Unrestricted database exposure on the public Internet is considered a bad 
practice and should be avoided whenever possible.
{% endwarning %}

If a direct connection is required enable **Force TLS connections** so the 
database rejects all non-encrypted connections.

On **Dedicated Resources**, this setting is enforced by
default, and inbound traffic can be filtered with firewall rules: everything is
denied by default, and you must explicitly allow each source network CIDR.


## TLS and Enforced TLS

TLS is available on Scalingo databases, but it is not always enforced by default
depending on the engine. When **Force TLS connections** is enabled, the
database denies any non-TLS connection, whether it comes from the Scalingo
network (for example applications) or from the public Internet.

For multi-node clusters, intra-cluster communications are always encrypted and 
do not depend on the **Force TLS connections** setting. See
[Common Features][database-features].


## Dedicated Resources: Firewalling

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
