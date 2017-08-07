---
title: Router error codes
modified_at: 2017-06-08 00:00:00
category: internals
tags: internals reverse-proxy routing http https
---

## List of error codes

Here is the list of error codes emitted by our routing layer:

* `499 Client Closed Request`: client closed the connection before the server answered the request. It is usually caused by client side timeout.
* `504 Gateway Timeout`: application behind the proxy has timed out.


