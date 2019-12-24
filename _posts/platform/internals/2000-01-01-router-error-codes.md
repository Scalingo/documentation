---
title: Router Error Codes
modified_at: 2017-10-12 00:00:00
tags: internals reverse-proxy routing http https
index: 4
---

## List of error codes

Here is the list of error codes emitted by our routing layer:

* `499 Client Closed Request`: client closed the connection before the server
  answered the request.  It is usually caused by client side timeout
* `502 Bad Gateway`: your application sent an invalid response to our reverse
  proxy. This error is often sent when your application is abruptly cutting
  connections.
* `503 Service Unavailable`:
  * The application [requests queue]({% post_url
    platform/internals/2000-01-01-routing %}#requests-queue) is full, so the
    newly incoming request has not been dequeued
  * The application has been stopped by its owner
  * The application has no `web` container responding to web requests
* `504 Gateway Timeout`: application behind the proxy timed out. Your
  application must accept connections and send the first byte in [a limited
  amount of time]({% post_url platform/internals/2000-01-01-routing
  %}#timeouts).
