---
title: Accessing Your Scalingo for PostgreSQL® Dedicated Resources Database
nav: Accessing
modified_at: 2026-02-13 12:00:00
tags: databases postgresql dedicated
index: 3
---


Remotely accessing your Scalingo for PostgreSQL® database can sometimes be
useful, for example, to conduct investigations, to check or compute data
locally, to dump the database content,...


## Using Third Party Tools

While using `psql` to query and administer a PostgreSQL® database is probably
the ubiquitous choice for a lot of users, it's not limited to that. The
PostgreSQL® ecosystem indeed offers a very large panel of tools made and
provided by third-parties. For example, some might feel more intuitive because
of their Graphical User Interface. Some are better integrated with others
tools, when some others are more data-visualization centric.

By default, and for security reasons, your PostgreSQL® database is protected by
a deny-by-default firewall.

Before using any third-party tool, configure the required [firewall rules](#allowing-access-with-firewall-rules)
to allow connections from your trusted sources.

Once your firewall rule is active, you should be able to connect
to your database with your tool of choice. If you don't have one yet, we
suggest you to [take a look at pgAdmin](#using-pgadmin).

### Using pgAdmin

pgAdmin is probably the most popular and feature rich administration and
development platform for PostgreSQL®. It's open-source, it supports many
platforms and comes with a Graphical User Interface, making it a reference tool
for PostgreSQL®.


## Allowing Access with Firewall Rules

Dedicated Resources databases are protected by a deny-by-default firewall.
To allow inbound connections, you must add explicit firewall rules for each
trusted source.

1. From your web browser, [open your database dashboard]({% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Select the **Settings** tab
3. In the **Settings** submenu, select **Internet Access**
4. In the **Firewall rules** block, click **New rule**
5. Select the rule type:
   - **Custom CIDR IPv4** to allow specific public IP addresses or ranges
   - **Scalingo `<region>` region** to allow traffic from Scalingo apps in that region
6. Repeat as needed for each trusted source
7. Connect using the database [connection URI]({% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-connecting %}#getting-the-connection-uri)

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

[egress]: {% post_url platform/networking/public/2000-01-01-egress %}
