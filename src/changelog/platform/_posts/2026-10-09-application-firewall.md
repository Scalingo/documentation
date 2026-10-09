---
modified_at: 2026-10-09 00:00:00
title: 'New: Application Firewall'
---

Application Firewall lets you restrict public HTTP and HTTPS access to your
application to allowed IPv4 ranges, for example your VPN's outbound addresses.

Requests from other addresses receive HTTP `403 Forbidden` before reaching
your application's containers.

See the [Application Firewall documentation]({% post_url platform/networking/public/2000-01-01-application-firewall %})
to configure your rules.
