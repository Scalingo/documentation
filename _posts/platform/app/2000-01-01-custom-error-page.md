---
title: Custom Error and Maintenance Pages
modified_at: 2018-03-22 00:00:00
tags: app custom error page
---

## Custom Error Pages

Our routers may return an error page in various cases, when an application is
unreachable:

- There is no running container.
- The application has no web container running but other types of containers
  are.
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
We advise you to develop the simplest page, with everything inlined (CSS, image,
etc.)
{% endnote %}

## Custom Maintenance Page

The `SCALINGO_NO_FRONT_ERROR_URL` environment can be used to display a specific
page when an application is in maintenance. Here are the steps:

1. Set the `SCALINGO_NO_FRONT_ERROR_URL` environment variable to point to a
   valid URL containing the maintenance page.
2. Scale down the `web` containers to 0.
3. Execute all the operations needed for as long as you need. During this
   step, the maintenance page will be displayed for any request to the
   application.
4. Scale back up the `web` containers to the original value.

{% note %}
All these steps can be achieved using either the web dashboard or the CLI.
{% endnote %}
