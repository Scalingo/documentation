---
index: 30
nav: Improving the Domain Security
title: Improving the Domain Name Security
modified_at: 2026-01-05 12:00:00
---


By default, any public Certificate Authority is authorized to issue a
certificate for any public domain name, provided they are able to prove they're
in control of the domain name. This can be considered as a risk, mostly because
a CA's validation process might be buggy. To lower this risk,
[RFC8657][rfc8657] suggests to use a `CAA` DNS record.

A `CAA` DNS record allows to specify the CA(s) allowed to generate a TLS
certificate for your domain name.

{% note %}
This feature is not supported by all registrars.\\
A non-comprehensive list of DNS providers supporting this feature can be found
[here][sslmate-caa].
{% endnote %}

To create one, add a `CAA` RR to your [zone file]. It should look like this:

```
@ IN CAA 0 issue "letsencrypt.org"
```

In the above example, Let's Encrypt is the only CA allowed to issue TLS
certificates for the domain name and its sub-domains.

- If you [entrust the management of your certificates to
  Scalingo][cert-default], and since we are using Let's Encrypt as CA, the
  value must be set to **letsencrypt.org** (see the example above).
- Otherwise, please refer to your TLS certificate provider for the appropriate
  value.


*[CA]: Certificate Authority
*[RR]: Resource Record
*[TLS]: Transport Layer Security

[rfc8657]: https://datatracker.ietf.org/doc/html/rfc8657
[sslmate-caa]: https://sslmate.com/caa/support

[zone file]: {% post_url platform/networking/public/domains/2000-01-01-overview %}#zonefile
[cert-default]: {% post_url platform/networking/public/cert/2000-01-01-default %}
