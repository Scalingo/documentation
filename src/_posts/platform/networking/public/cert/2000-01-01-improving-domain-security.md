---
index: 30
nav: Improving the Domain Security
title: Improving the Domain Name Security
modified_at: 2025-12-31 12:00:00
---


By default, any public CA is authorized to issue a certificate for any public
domain name, provided they are able to prove they're in control of the domain
name. This can be considered as a risk, mostly because a CA's validation
process might be buggy. To lower this risk, [RFC8657][rfc8657] suggests to use
a `CAA` DNS record.

A `CAA` DNS record allows to specify the CA(s) allowed to generate a TLS
certificate for your domain name. To do so, create a `CAA` record in your
domain name [zonefile], like so:

```
example.com.  IN  CAA 0 issue "letsencrypt.org"
```

In the above example, Let's Encrypt is the only CA allowed to issue TLS
certificates for the domain name `example.com` and its sub-domains.

{% note %}
This feature is not supported by all DNS providers.\\
A non-comprehensive list of DNS providers supporting this feature can be found
[here][sslmate-caa].
{% endnote %}


*[CA]: Certificate Authority
*[TLS]: Transport Layer Security

[rfc8657]: https://datatracker.ietf.org/doc/html/rfc8657
[sslmate-caa]: https://sslmate.com/caa/support
[zonefile]: https://en.wikipedia.org/wiki/Zone_file

