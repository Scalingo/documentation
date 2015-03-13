---
title: Detecting HTTPS requests
category: internals
tags: internals, request, https
date: 13/03/2015
---

# Detecting HTTPS requests

## Background

Your application runs behind a load balancer which does all the request handling
to your (optionally) scaled application. The communication between the load
balancer and your application (specifically the `web` container within your
application) is carried out via HTTP and you are not able to detect a HTTPS
request via standard methods of your web framework.

That is why the HTTP headers of the external request are enriched with
a `x-forwarded-proto` header (among others) by the load balancer and handed
over to your `web` contaner.

You would then check if the header value contains `https` to detect a HTTPS
request.

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
		final String header = servletRequest.getHeader("x-forwarded-proto");
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
