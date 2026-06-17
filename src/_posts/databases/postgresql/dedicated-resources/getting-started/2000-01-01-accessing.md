---
title: Accessing Your Scalingo for PostgreSQL® Dedicated Resources Database
nav: Accessing
modified_at: 2026-06-11 00:00:00
tags: databases postgresql dedicated
index: 3
---

By default the deployed database is completely private and is not reachable by
any entity. Access configuration should be configured to allow database clients
to reach it. Either it is an application using the database, or a database
administration tool like a console or a web client.

## Allowing Access with Firewall Rules

Dedicated Resources databases are protected by a deny-by-default firewall.
To allow inbound connections, you must add explicit firewall rules for each
trusted source.

### Using the Database Dashboard

1. From your web browser, [open your database dashboard]({% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Select the **Settings** tab
3. In the **Settings** submenu, select **Internet Access**
4. In the **Firewall rules** block, click **New rule**
5. Select the rule type:
   - **Custom CIDR IPv4** to allow specific public IP addresses or ranges
   - **Scalingo `<region>` region** to allow traffic from Scalingo apps in that region
6. Repeat as needed for each trusted source
7. Connect using the database [connection URI]({% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-connecting %}#getting-the-connection-uri)

### Using the Command Line (Preview) {#using-the-command-line}

Because Dedicated Resources databases are not yet generally available,
you must first enable preview features to use the related CLI commands:

```bash
export SCALINGO_PREVIEW_FEATURES=true
```

Then:

```bash
# List the existing rules
scalingo --database <db-id> database-firewall-rules

# Add a new rule to the database based on a CIDR or a managed range
scalingo --database <db-id> database-firewall-rules-add --cidr "198.51.100.25/32" --label "My workstation"
scalingo --database <db-id> database-firewall-rules-add --managed-range mr-scalingo-osc-fr1

# Remove an existing rule to restrict access
scalingo --database <db-id> database-firewall-rules-remove <rule-id>

# List existing managed ranges which are maintained by Scalingo
scalingo --database <db-id> database-firewall-managed-ranges
```

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


## Connecting Through Outscale Net Peering

You can connect a Dedicated Resources database to an Outscale VPC from another
Outscale account in the same region as the database using Net Peering.

{% note %}
Using a Net Peering does not prevent from having to define firewall rules to access
your database, the difference is that you have to allow private IP ranges from
your own networks.
{% endnote %}

This feature is currently available from the Scalingo CLI only and requires
preview features to be enabled.


1. Enable preview features in your shell:

   ```bash
   export SCALINGO_PREVIEW_FEATURES=true
   ```

2. Fetch the database network configuration:

   ```bash
   scalingo --database db-id database-network-configuration
   ```

3. From the fetched information, create the Outscale Net Peering from your
   Outscale account and copy the generated ID, for example `pcx-123456789`.

4. Register the Outscale Net Peering on the database:

   ```bash
   scalingo --database db-id database-net-peerings-add --outscale-net-peering-id pcx-123456789
   ```

5. Configure your Outscale VPC to route traffic to the database IP range. Update
   both the Security Group and the Route Table rules.

6. Get your [private peering endpoint][database-endpoints] address to build your connection chain through the net peering.

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

You can use your own pgAdmin, deployed on Scalingo or on another infrastructure
as long as the firewall rules are correctly configured.

[egress]: {% post_url platform/networking/public/2000-01-01-egress %}
[database-endpoints]: {% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-endpoints %}
