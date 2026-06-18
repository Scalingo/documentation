---
modified_at: 2026-06-18 00:00:00
title: 'PostgreSQL® Dedicated Resources - Outscale Net Peering Support'
---

Scalingo for PostgreSQL® Dedicated Resources databases can now be reached
through Outscale Net Peering.

Each database now exposes a second [endpoint]({% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-endpoints %})
dedicated to Net Peering traffic, alongside the existing public endpoint used
for Internet-routed traffic.

This new access path lets you connect workloads running in an Outscale VPC to a
Dedicated Resources database over Outscale Net Peering, without using the public
Internet route.

Learn more in the [Dedicated Resources access guide]({% post_url databases/postgresql/dedicated-resources/getting-started/2000-01-01-accessing %}#connecting-through-outscale-net-peering).
