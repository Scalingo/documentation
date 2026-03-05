---
modified_at: 2026-03-04 00:00:00
title: 'Use a Cloudflare API token for wildcard certificate renewal'
---

You can now automate Let's Encrypt wildcard certificate renewal on Scalingo using a dedicated Cloudflare API token.

Set `DNS_CLOUDFLARE_API_TOKEN` on your application when using the Cloudflare DNS provider.

For wildcard domain automation, the token must include the following permissions on the target zone:

- `Zone:Read`
- `DNS:Edit`

This gives you a safer alternative to using a global Cloudflare API key.
The global Cloudflare API key (environment variable `DNS_CLOUDFLARE_API_KEY`)
is still supported, but we strongly advise using an API token instead.

👉 [Read the wildcard certificate setup guide]({% post_url platform/networking/public/cert/2000-01-01-default %})
