---
modified_at: 2026-03-11 00:00:00
title: 'Use a Gandi personal access token for wildcard certificate renewal'
---

You can now automate Let's Encrypt wildcard certificate renewal on Scalingo using a Gandi personal access token.

Set `DNS_GANDI_PERSONAL_ACCESS_TOKEN` on your application when using the Gandi DNS provider.

For wildcard domain automation, the token should be restricted to the domain name product (e.g. `example.com`) and have the following permission: "Manage domain name technical configuration".

This gives you a safer alternative to using a global Gandi API key.
The global Gandi API key (environment variable `DNS_GANDIV5_API_KEY`)
is still supported, but we strongly advise using a personal access token instead.

👉 [Read the wildcard certificate setup guide]({% post_url platform/networking/public/cert/2000-01-01-default %})
