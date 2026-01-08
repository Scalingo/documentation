---
title: "Sticky Sessions - Session Affinity"
nav: "Sticky Sessions"
modified_at: 2026-01-02 12:00:00
tags: app routing
index: 23
---

The **Sticky Sessions** feature, also known as **Session Affinity**, changes the
routing configuration of your application. It associates all HTTP requests from an end-user
to a single `web` application container.

{% warning %}
Sticky Sessions might help you to scale out applications keeping states about users
across connections (i.e. sessions in memory). However this feature come with drawbacks explained later
on this page and it is a good practice to avoid using it when possible. (stateless sessions,
or database-stored sessions for instance)
{% endwarning %}

## Description

By default [requests are routed][requests-routing] using a round-robin
algorithm. This means that, if you have multiple containers the traffic is distributed evenly.
For example, if you have 2 `web` containers. When a single user makes two requests to your application, each container receives one request.

Once **Sticky Sessions** are enabled, each end-user is associated to
a container and consecutive requests from this entity all target the same
`web` container. Round-robin is still used but per end-user and not per
request.

## Technical details

### Sticky Session Cookie

Any request done to the application having **Sticky Sessions** enabled, will receive a
`sc-sticky-session` cookie in the request response. This cookie has a 24 hours duration. At each
client's request, a new sticky session cookie is returned, with a duration of 24 hours.

```console
└> curl my-app.osc-fr1.scalingo.io -I
HTTP/2 200 OK
Date: Wed, 21 Mar 2018 17:51:09 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 13
Connection: keep-alive
X-Request-ID: d2df9e31-7415-46bf-beff-8ba31623a817
Set-Cookie: sc-sticky-session=GCLlOQs/Ttbrq5u1Y76yc4mI0uJjTE8vpoOUS/RG5jo=; Expires=Thu, 22-Mar-18 17:51:09 GMT; Max-Age=86400; Domain=my-app.osc-fr1.scalingo.io; Path=/; HttpOnly
```

If the cookie is not correctly sent back, the request may be routed to another backend `web`
container.

### Sticky Session Cookie Invalidation

* If one of the container becomes unhealthy, because it has crashed or because it is overloaded, our
  routers will quarantine it and the sticky session cookie will be invalidated.

* Each operation changing the routing rules of the application will invalidate current cookies and
  end-users will receive a new version of the cookie and will be routed to a new instance. More
  precisely, those operations made on your app will invalidate current cookies:
  * Deployment
  * Restart
  * Scaling

* Applications hosted on the platform can be cycled at any time for internal infrastructure
  management purposes (like dynamic load balancing of the server), when such event happens, the
  sticky sessions are also invalidated.

* If the sticky session cookie expires, the client's request is directed toward a randomly chosen
  container, and a new sticky session cookie is returned.

## The case of Meteor Framework

For [Meteor]({% post_url languages/meteorjs/2000-01-01-start %}) applications,
**Sticky Sessions** are enabled by default because it is
[required](http://www.meteorpedia.com/read/Scaling_your_Meteor_App) to scale
properly.


[requests-routing]: {% post_url platform/networking/public/2000-01-01-routing %}#requests-distribution
