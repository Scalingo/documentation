---
layout: page
title: Configure Cloudflare to access Scalingo applications
nav: Configure Cloudflare
modified_at: 2026-01-02 12:00:00
tags: integration cloudflare
index: 98
---

## Integration Purposes

Cloudflare is a SaaS product helping you to optimize and protect your
applications against a wide variety of attacks. The role of Cloudflare is to
position itself between the users of your apps and your app instances
themselves, located in Scalingo infrastructure. Then several features can be
used:

* **Proxy Cache**: Cloudflare automatically caches static assets like images,
  javascripts and stylesheets. It means that the first time such files are
  requested, the request is forwarded to your application, and all the
  subsequent queries will be responded directly by Cloudflare infrastructure,
  allowing your application to use its CPU to serve content dynamic requests
  instead of serving static files.

* **HTTPS Termination**: By using Cloudflare, you don't have to care anymore
    about TLS certificates, they are automatically handled by them. At the
    precise moment your domain is configured to use their proxy, a valid
    certificate will be served to your users. Read the [End-to-end
    HTTPS](#end-to-end-https) section for more information.

* **Application Firewall**: Cloudflare proxies are looking at incoming requests
  to check for common attempt to exploit security holes like SQL injections,
  XSS or known breaches your application might be sensible to. These requests
  are automatically dropped without threatening your application.

* **DDoS Protection**: If the case an application might be likely to be
  attacked.  Cloudflare positions itself as a shield against a wide variety of
  distributed DDoS attacks, legitimate keeps being transferred to your
  application while unwanted ones are dropped.

{% include frontend_servers_open_ports_cloudflare.md %}

## Setup of Your Cloudflare Account

The first thing to do is to setup your domain with Cloudflare. It will require
to change your domain name servers at the registrar level (the entity which sold
the domain). This process might take up to 24 hours.

To go through this process, you are encouraged to follow [their official
documentation](https://support.cloudflare.com/hc/en-us/articles/201720164-Step-2-Create-a-Cloudflare-account-and-add-a-website).

## Configuration of Your Application on Scalingo

### Configure Cloudflare DNS to Target Scalingo

To configure your domain, you need to create a `CNAME` **DNS** entry for each domain
added to the Scalingo application. The target of this `CNAME` entry should be

```
# If the application name is 'my-app'

my-app.osc-fr1.scalingo.io.
```

{% note %}
  The `.` (dot) character at the end of `my-app.osc-fr1.scalingo.io.` is required, it
  precises the URL is a fully qualified domain name (FQDN) and not a relative
  domain of the current one. (e.g. `my-app.osc-fr1.scalingo.io.example.com`)
{% endnote %}

![cloudflare-add-record](https://cdn.scalingo.com/documentation/integrations/cloudflare-create-record-03.png)

### Add the Domains to Your Application

You need to declare to Scalingo all domains that your app will have to respond to.

#### Dashboard

Where: **Domains/SSL** tab of your application

What: Type your domain in the text field and click on `LINK DOMAIN NAME TO THE APP`

#### CLI

```bash
scalingo --app my-app domains-add example.com
scalingo --app my-app domains-add www.example.com

# etc. according the the domains you want to target
```

## Cloudflare as DNS Server

Cloudflare can also be used as a simple DNS server to configure how your DNS zone
is configured. In this case requests won't be routed to their infrastructure,
but it is also not possible to use their features caching or application
firewalling. To use it as DNS server only, change the status of the concerned
subdomains as `DNS only`.

An advantage of using Cloudflare as DNS provider is that it provides **CNAME
flattening** on root domains. Usually DNS providers only let you configure
**CNAME** fields on subdomains (i.e. `www.example.com`) but not on root domains
(i.e. `example.com`). It obliges you to create a **A** field targeting a
precise `IP` to reach your application, which is not flexible and internal
changes at Scalingo might impact your app. Their DNS service will let you
configure a **CNAME** entry for a root domain, removing the **static IP**
limit.

## End-to-end HTTPS

Cloudflare offers HTTPS termination so that your application is always reachable
via HTTPS. At the precise moment your domain is configured to use their proxy, a
valid certificate will be served to your users. However, in order to ensure
complete protection to your clients, your application should use the "Full
(strict)" mode. With this mode, the traffic to your application is encrypted
from your customers browser to your Scalingo hosted application going through
Cloudflare network. Cloudflare "Full (strict)" mode will work out of the box
along with Scalingo [automatic certificate generation with Let's
Encrypt]({% post_url platform/networking/public/cert/2000-01-01-default %}).

{% warning %}
To ensure this configuration is working over time, you should not enable "Always Use HTTPS" in Cloudflare configuration. (SSL/TLS → Edge Certificates).

To generate and renew Let's Encrypt certificate, a specific route should be
accessible in plain HTTP, under the path `/.well-known/`. This Cloudflare
configuration prevents this operation to happen.

If you want to force HTTPS for your app, please enable the "Force HTTPS" option
in your Scalingo app Settings.
{% endwarning %}

Here is Cloudflare [documentation
page](https://support.cloudflare.com/hc/en-us/articles/200170416-End-to-end-HTTPS-with-Cloudflare-Part-3-SSL-options)
about it.
