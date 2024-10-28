---
title: Router Error Codes
modified_at: 2024-10-28 00:00:00
tags: internals reverse-proxy routing http https
index: 4
---

## List of Error Codes

Here is the list of error codes emitted by our routing layer:

* `413 Payload Too Large` (previously called `Request Entity Too Large`): your request exceeds the max allowed body size (cf. [Uploads - Max Request Size]({% post_url platform/internals/2000-01-01-routing %})).
* `499 Client Closed Request`: client closed the connection before the server
  answered the request. It is usually caused by client side timeout.
* `502 Bad Gateway`:
  * Your application sent an invalid response to our reverse proxy. This error
    is often sent when your application is abruptly cutting connections.
  * This is also the code when all containers are in [quarantine]({% post_url
    platform/internals/2000-01-01-routing %}#requests-scheduling). You can distinguish between these two cases based on the context. If you notice multiple consecutive requests returning a 502 error, it probably means one of your application containers is in quarantine.
* `503 Service Unavailable`:
  * The application [requests queue]({% post_url
    platform/internals/2000-01-01-routing %}#requests-queue) is full, so the
    newly incoming request has not been dequeued.
  * The application has been stopped by its owner.
  * The application has no `web` container responding to web requests.
* `504 Gateway Timeout`: application behind the proxy timed out. Your
  application must accept connections and send the first byte in [a limited
  amount of time]({% post_url platform/internals/2000-01-01-routing
  %}#timeouts).
