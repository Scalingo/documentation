---
layout: page
title: Configure Sucuri to access Scalingo applications
nav: Configure Sucuri
modified_at: 2026-01-02 12:00:00
tags: integration sucuri
index: 98
---


## Integration purposes

Sucuri is a SaaS product helping you to protect your applications against a wide
variety of attacks. The role of Sucuri is to position itself between the users
of your apps and your app instances themselves, located in Scalingo
infrastructure.

## Let's Encrypt Certificate With Sucuri

Sucuri offers [HTTPS termination] so that your application is always reachable
via HTTPS. However, in order to fully protect your application, you should use
"Full SSL" mode. This mode requires Scalingo to generate a HTTPS certificate
for your application. Scalingo uses Let's Encrypt to generate a HTTPS
certificate for your application with a [custom domain].

To generate and renew Let's Encrypt certificate, a specific route should be
accessible in plain HTTP, under the path `/.well-known/`. To make this route
reachable by Let's Encrypt server, you need to enable "Forward Certificate
Validation" in Sucuri dashboard.


[HTTPS termination]: https://docs.sucuri.net/website-firewall/configuration/ssl-mode/

[custom domain]: {% post_url platform/networking/public/domains/2000-01-01-custom %}
