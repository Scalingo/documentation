---
title: Custom Domain Name
date: 01/04/2015
tag: app, domain name, dns, cname
category: app
---

# Add a custom Domain Name

Scalingo provides for all apps a subdomain of `scalingo.io` to access your application.
Of course, you may want to change it and use your own. This operation require different
configuration operations:

## Buy a domain name

We do not sell domain names, to use your own, you need to buy it from a company which
sells them (called registrar).

* DNS Simple - https://dnsimple.com/
* OVH - https://www.ovh.com
* Gandi - https://www.gandi.net

Those are examples, you can find an exhaustive list on the [ICANN
website](https://www.icann.org/registrar-reports/accredited-list.html) The
process is pretty similar with any of these services, you search for the
availability of the domain and if it is available, you can just buy it per
year.

## Configure your domain name

After having bought a domain name you need to configure it. Most of the
registrars provide a web dashboard to do so. To target your application
hosted on Scalingo, you need to create a `CNAME` field targeting the
fully qualified domain name (fqdn) `appname.scalingo.io.`

### Example

The raw configuration line to add is to create an alias between `www.example.io`
and `example.scalingo.io` is:

```
NAME   TTL      TYPE  FIELD    TARGET
www    10800    IN    CNAME    example.scalingo.io.
```

<blockquote class="info">
  This operation is not instant. DNS propagation can take up to days to be completely done.
</blockquote>

## Configure your application

Once you have correctly configured your domain name to target your application you need
to configure it to accept request from this domain. You can achieve the operation with
our [CLI](http://cli.scalingo.com), or through our [dashboard](https://my.scalingo.com).

Using our CLI:

```
scalingo -a <app> domains-add <domain name>
```

Using the web dashboard: 

Go to the 'Domains' tab of your app dashboard, fill the 'Domain Name' text field and validate
by clicking on 'Link domain name to the app'.

## Add a root domain

Most of the registrars only allow `A` field for root domains. However `A` should target an IP. As Scalingo
don't ensure that our front IP addresses won't change over time, we advise you to use a subdomain for your
application or to migrate your domain name to another DNS provider.

Some providers allow to create `ALIAS`, `ANAME` or `CNAME` field for root domains:

* DNSimple (ALIAS)
* DNS Made Easy (ANAME)
* easyDNS (ANAME)
* CloudFlare (CNAME)
* PointDNS (ALIAS)

### Note

When you add an alias, we don't do any prior verification. If you cannot add
your alias because it's already taken on Scalingo and you think you're legit
to use it, send an email to <support.scalingo.com>
describing the problem.


## See also

* [Configure SSL for your custom domain name](/app/ssl.html)
* [Requests routing](/internals/routing.html)
