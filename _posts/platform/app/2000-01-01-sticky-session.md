---
title: "Sticky Sessions - Session Affiniy"
modified_at: 2018-03-21 00:00:00
tags: app routing
index: 23
---

The **Sticky Sessions** feature, also known as **Session Affinity**, changes the
routing configuration of your application. It associates all HTTP requests from an end-user
to a single `web` application container.

## Description

By default the routing of requests is done using the *Round Robin* algorithm,
learn more about it in our [dedicated page]({% post_url
platform/internal/2000-01-01-routing %}).  As an example: if you have 2 web
containers, and a single user is making 2 requests to your application, each
container will receive one request.

Once **Sticky Sessions** have been enabled, each end-user will be associated to
a container and consecutive requests from this entity will all target the same
`web` containers. *Round Robin* is still used but per end-user and not per
request.

## Technical details

### Sticky Session Cookie

Any request done to the application having **Sticky Sessions** enabled, will receive
a `sc-sticky-session` cookie in the request response. This cookie should be sent back,
the default behavior of most web clients, to ensure the end-user gets to the same
container.

```console
└> curl my-app.scalingo.io -I
HTTP/2 200 OK
Date: Wed, 21 Mar 2018 17:51:09 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 13
Connection: keep-alive
X-Request-ID: d2df9e31-7415-46bf-beff-8ba31623a817
Set-Cookie: sc-sticky-session=GCLlOQs/Ttbrq5u1Y76yc4mI0uJjTE8vpoOUS/RG5jo=; Expires=Thu, 22-Mar-18 17:51:09 GMT; Max-Age=86400; Domain=my-app.scalingo.io; Path=/; HttpOnly
```

If the cookie is not correctly sent back, the request may be routed to another
backend `web` container.

## Disclaimers

* If one of the container becomes unhealthy, because it has crashed or because
  it is overloaded, users associated to this container might get multiple errors,
  until a new container is spawn.

* Each operation changing the routing rules of the application will invalidate
  current cookies and end-users will receive a new version of the cookie and will
  be routed to a new instance.
  * Deployment
  * Restart
  * Scaling

* Applications hosted on the platform car be cycled at any time for internal
  infrastructure management purposes (like dynamic load balancing of the server),
  when such event happens, the sticky session is also invalidated.

## The case of Meteor Framework

For [Meteor]({% post_url languages/meteorjs/2000-01-01-start %}) applications,
**Sticky Sessions** are enabled by default because it is
[required](http://www.meteorpedia.com/read/Scaling_your_Meteor_App) to scale
properly.
