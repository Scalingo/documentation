---
title: Router error codes
modified_at: 2017-10-12 00:00:00
tags: internals reverse-proxy routing http https
---

## List of error codes

Here is the list of error codes emitted by our routing layer:

* `499 Client Closed Request`: client closed the connection before the server answered the request. It is usually caused by client side timeout
* `503 Service Unavailable`
  * The application [requests queue]({% post_url internals/2015-03-22-routing %}#requests-queue) is full, so the newly incoming request has not been dequeued
  * The application has been stopped by its owner
  * The application has no `web` container responding to web requests
* `504 Gateway Timeout`: application behind the proxy timed out
