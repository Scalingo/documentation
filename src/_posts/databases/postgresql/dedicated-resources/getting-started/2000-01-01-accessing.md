---
title: Accessing Your Scalingo for PostgreSQL® Dedicated Resources Database
nav: Accessing
modified_at: 2026-02-12 12:00:00
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

By default, and for security reasons, your PostgreSQL® database is not directly
accessible from the Internet and therefore not directly usable with your
third-party tool.

To access your database remotely you first need to [make it reachable over the
Internet](#making-the-database-reachable-over-internet):
- either locally, on your computer, via an [encrypted tunnel](#setting-up-an-encrypted-tunnel)
- or from any location, by [enforcing TLS connection]({% post_url databases/postgresql/shared-resources/getting-started/2000-01-01-connecting %}#enforcing-tls-connection)
  and [enabling direct Internet access](#enabling-direct-access-over-internet).

Once a secured connection has been established, you should be able to connect
to your database with your tool of choice. If you don't have one yet, we
suggest you to [take a look at pgAdmin](#using-pgadmin).

### Using pgAdmin

pgAdmin is probably the most popular and feature rich administration and
development platform for PostgreSQL®. It's open-source, it supports many
platforms and comes with a Graphical User Interface, making it a reference tool
for PostgreSQL®.


## Allowing Access with Firewall Rules

1. From your web browser, [open your database dashboard]({% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-provisioning %}#accessing-the-scalingo-for-postgresql-dashboard)
2. Select the **Settings** tab
3. In the **Settings** submenu, select **Internet Access**
4. In the **Firewall rules** block, click **New rule**
5. Select the rule type:
   - **Custom CIDR IPv4** to allow specific public IPs
   - **Scalingo `<region>` region** to allow traffic from Scalingo apps in a given region
6. Repeat as needed for each trusted source, then wait up to 2 minutes for rules to apply
7. Connect using the database [connection URI]({% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-connecting %}#getting-the-connection-uri)

