---
title: Detecting HTTPS requests
modified_at: 2015-03-23 00:00:00
category: config
order: 9
tags: https routing request internals
---

## Background

Your application runs behind a load balancer which does all the request handling
to your (optionally) scaled application. The communication between the load
balancer and your application (specifically the `web` container(s) within your
application) is carried out via HTTP and you are not able to detect a HTTPS
request via standard methods of your web framework.

That is why the HTTP headers of the external request are enriched with
a `X-Forwarded-Proto` header (among others) by the load balancer and handed
over to your `web` contaner(s).

{% include info data = 'Learn more about proxying on the platform: <a href="/internals/routing.html">Documentation</a>' %}

You would then check if the header value contains `https` to detect a HTTPS
request.

## Simple Go example

```go
package main

import (
  "fmt"
  "log"
  "net/http"
  "os"
)

func isHTTPS(req *http.Request) bool {
  return req.Header.Get("X-Forwarded-Proto" == "https") || req.URL.Scheme == "https"
}

func main() {
  http.HandleFunc("/", func(res http.ResponseWriter, req *http.Request) {
    if isHTTPS(req) {
      log.Println("HTTPS is used, connection is secured.")
    } else {
      log.Println("HTTP is used, you should envisage using HTTPS.")
    }
    fmt.Fprintf(res, "Hello World\n")
  })

  log.Fatalln(http.ListenAndServe(":" + os.Getenv("PORT"), nil))
}
```

## Simple Java+Wicket example

```java
public class RequestUtil {

	private static final Logger log = LoggerFactory.getLogger(RequestUtil.class);

	public static boolean isSecure() {
		return isSecureScalingo() || isSecureRegular();
	}

	private static boolean isSecureScalingo() {
		final HttpServletRequest servletRequest = getServletRequest();
		if (null == servletRequest) {
			return false;
		}
		final String header = servletRequest.getHeader("X-Forwarded-Proto");
		return !Strings.isEmpty(header) && "https".equalsIgnoreCase(header);
	}

	private static boolean isSecureRegular() {
		final HttpServletRequest servletRequest = getServletRequest();
		return null != servletRequest ? servletRequest.isSecure() : false;
	}

	@Nullable
	public static HttpServletRequest getServletRequest() {
		final Object containerRequest = RequestCycle.get().getRequest().getContainerRequest();
		if (containerRequest instanceof HttpServletRequest) {
			return ((HttpServletRequest) containerRequest);
		} else {
			log.warn("Current request is no HttpServletRequest! (" + containerRequest + ")");
			return null;
		}
	}
}
```
