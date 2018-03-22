---
title: Custom error page
modified_at: 2018-03-22 00:00:00
tags: app custom error page
---

Our routers may return an error page in various cases, when an application is unreachable:

- There is no running container.
- The application has no web container running but other type of containers are.
- The application crashed or cut the connection unexpectedly.
- The application <a href="{% post_url platform/internals/2000-01-01-routing %}#timeouts">timed out</a>.

In these cases, Scalingo's routers return an error page like the following:

{% assign img_url = "http://cdn.scalingo.com/documentation/screenshot_application_error.png" %}
{% include mdl_img.html %}

You can customize these pages by modifying the following environment variables:

- `SCALINGO_STOPPED_PAGE_URL`
- `SCALINGO_NO_FRONT_ERROR_URL`
- `SCALINGO_APP_ERROR_URL`
- `SCALINGO_TIMEOUT_ERROR_URL`

The usage is the following:
`SCALINGO_STOPPED_PAGE_URL="https://cdn.example.com/stopped_page.html"`.

In order to prevent the page to be fetched at each request, the content is
cached in the router's memory. Hence we limit the size of this page to 10MB.

{% note %}
We advise you to develop the simplest page, with everything inlined (CSS, image, etc.)
{% endnote %}
