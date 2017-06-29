---
title: Let's Encrypt availability
modified_at: 2016-12-23 00:00:00
category: app
tags: app certificate ssl https
---

## Let's Encrypt certificates on Scalingo

If you want a Let's Encrypt certificate on Scalingo, it is as simple as adding [your own 
domain name]({% post_url app/2015-04-01-domain %}). We automatically generate a certificate for every
domain added to the platform. Let's Encrypt certificates have a 90 days validity. We follow Let's Encrypt
recommendation and renew them every 60 days automatically. You do not need to do anything manually!

If you prefer to use a certificate signed by a different certificate authority, feel free to add
it by following [the instructions]({% post_url app/2015-04-01-ssl %}).

If you forget to renew your custom certificate and it expires, or if you delete it, a Let's
Encrypt certificate will automatically and immediately replace it. Hence your application will
always be available using HTTPS.

<blockquote class="bg-info">
  Note that Let's Encrypt do not deliver wildcard certificates. If you add such a custom domain, we
  will not be able to create Let's Encrypt certificate.
</blockquote>

## Let's Encrypt certificate statuses

On the dashboard, you may find your Let's Encrypt certificate with various statuses:

* Pending DNS: when you link a domain name to your application, we wait for it to target our
  infrastructure before generating the certificate. We check the DNS record automatically every 60 seconds.
* Creating: our infrastructure is exchanging messages with Let's Encrypt servers to generate your
  certificate.
* In use: your website is available using HTTPS connections thanks to a Let's Encrypt certificate.
* Not used: your website is available using HTTPS connections thanks to a custom certificate. If it
  expires or if you remove it, your website will be available using HTTPS connections thanks to a 
  Let's Encrypt certificate.

