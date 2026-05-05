---
title: Custom Error and Maintenance Pages
modified_at: 2026-01-02 12:00:00
tags: app custom error page
---

## Custom Error Pages

Our routers may return an error page when an application is unreachable. By
default, the error page looks like the following:

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_application_error.png" %}
{% include mdl_img.html %}

You can customize these pages by providing Scalingo with a custom error page
URL. Four different error pages can be customized. You need to set one of these
environment variables depending on which error page you want to customize:

- `SCALINGO_NO_FRONT_ERROR_URL`: if the application has no `web` container
  running but other types of containers are.
- `SCALINGO_STOPPED_PAGE_URL`: if the application has no running container.
- `SCALINGO_APP_ERROR_URL`: if the application returns a 502 HTTP response,
  crashed or cut the connection unexpectedly.
- `SCALINGO_TIMEOUT_ERROR_URL`: if the application returns a 504 HTTP response
  or timed out.

To learn more about HTTP errors returned by our frontends, please see [our
documentation][routing-errors].

The usage is the following:
`SCALINGO_STOPPED_PAGE_URL=https://cdn.example.com/stopped_page.html`.

In order to prevent the page to be fetched at each request, the content is
cached in the router's memory. Hence we limit the size of this page to 10MB.

It is mandatory to restart the application for the configuration of these pages to be taken into account.

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


[routing-errors]: {% post_url platform/networking/public/2000-01-01-routing %}#http-errors
