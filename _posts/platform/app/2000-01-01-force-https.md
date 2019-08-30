---
title: "Force HTTPS"
modified_at: 2018-03-05 00:00:00
tags: app routing https security tls
index: 22
---

The **Force HTTPS** feature will ensure that your users will be reaching an application through **HTTPS only**.

## Context

HTTPS is enabled by default for all the applications deployed on the platform.
Once deployed an application can be accessed either with HTTP or HTTPS:

* `http://my-app.scalingo.io`
* `https://my-app.scalingo.io`

Or, once a custom domain has been added:

* `http://example.com`
* `https://example.com`

Activating the **Force HTTPS** feature enforces HTTPS access to all the domains attached to the application. It is achieved by activating a permanent redirection from HTTP to HTTPS and injecting the HSTS header in HTTPS responses.

## Technical details

### Permanent Redirect (301) from HTTP to HTTPS

Any request done to the application using **HTTP** will be redirected
using the status code `301`. It means browsers will remember this redirection
over time:

```console
$ curl http://my-app.scalingo.io -I
HTTP/1.1 301 Moved Permanently
Server: openresty
Date: Mon, 05 Mar 2018 10:04:39 GMT
Content-Type: application/octet-stream
Connection: keep-alive
X-Request-ID: aa5e0e4e-5e3f-4e36-b4d4-c5f65a47812f
Location: https://my-app.scalingo.io/
```

### Injection of HSTS header

The HTTP Strict Transport Security header (also known as HSTS) is a HTTP header
which aims at instructing clients like browsers, to avoid connecting to a given
domain without using an encrypted connection.

The header will be automatically added to the request response of HTTPS requests:

```console
$ curl https://my-app.scalingo.io -I
HTTP/2 200
server: nginx
date: Mon, 05 Mar 2018 10:08:15 GMT
content-type: text/plain; charset=utf-8
x-request-id: c87a7b84-d43f-44fb-9524-54bf666e6ff1
strict-transport-security: max-age=31536000
```

The `strict-transport-security: max-age=31536000` ensures that browsers won't
access the domain in an unsecure way during 1 year. By combining it with the
HTTP to HTTPS redirection, it is now sure that users can only access the
application once without using an encrypted connection: at their first
connection which is usually unauthenticated.

More documentation about HSTS on [Mozilla Developer
Network](https://developer.mozilla.org/docs/S%C3%A9curit%C3%A9/HTTP_Strict_Transport_Security)

## Disclaimers

* Make sure your application works correctly using HTTPS before enabling the
  **Force HTTPS** feature. Once enabled, the application won't be reachable without HTTPS.

* Once the feature is enabled and that some users have received the HSTS header,
  they will **always** keep using HTTPS to reach your application. Hence, make sure HTTPS
  access keep working correctly, even if the feature is disabled.

* This feature adds a small lock-in to the platform as it depends on Scalingo's
  infrastructure. If that is something you want to avoid, you can  implement it
  at the application level. Libraries exist for most languages and framework to
  create the exact same behavior. Here are a few examples:
  * Ruby, Rack: [rack-ssl-enforcer](https://github.com/tobmatth/rack-ssl-enforcer)
  * Ruby, Rails 4+: [ssl options configuration](http://api.rubyonrails.org/v5.1/classes/ActionDispatch/SSL.html)
  * Java, Springboot: [HttpSecurity configuration](https://docs.spring.io/spring-security/site/docs/current/reference/html/headers.html)
  * Java/Scala, Play2: [HTTP filters](https://www.playframework.com/documentation/2.6.x/RedirectHttpsFilter)
  * Python: Django: [Security Middleware](https://docs.djangoproject.com/en/2.0/ref/middleware/#http-strict-transport-security)
  * Node.js, Express middleware: [hsts](https://github.com/helmetjs/hsts)
  * Node.js, Meteor: [force-ssl](https://atmospherejs.com/meteor/force-ssl)
  * PHP, Symfony: [Nelmio Security Bundle](https://github.com/nelmio/NelmioSecurityBundle)
  * PHP, Laravel: [zae/strict-transport-security](https://packagist.org/packages/zae/strict-transport-security)
* In case of not GET request, tools (browers, Postman, language libraries, ...) may not follow the RFC and will request GET on the redirection.

  >    If the 301 status code is received in response to a request other
  >   than GET or HEAD, the user agent MUST NOT automatically redirect the
  >   request unless it can be confirmed by the user, since this might
  >   change the conditions under which the request was issued.
  >
  >      Note: When automatically redirecting a POST request after
  >      receiving a 301 status code, some existing HTTP/1.0 user agents
  >      will erroneously change it into a GET request.
  (from [ietf.org/rfc/rfc2616.txt](https://www.ietf.org/rfc/rfc2616.txt) section 10.3.2)

  For example with Postman, POST on HTTP will display the result of GET on HTTPS.
