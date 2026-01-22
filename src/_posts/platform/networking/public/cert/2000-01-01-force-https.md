---
index: 40
nav: Forcing HTTPS
title: Forcing HTTPS
modified_at: 2025-12-11 12:00:00
---


When deploying a publicly available application on Scalingo, it's automatically
given a TLS certificate, making it reachable via both HTTP or HTTPS by default.

This means that both `http://...` and `https://...` URLs grant access to the
application.

While this is pretty convenient, it's also often undesirable.

The **Force HTTPS** feature allows you to ensure clients are reaching your
application through HTTPS, and only HTTPS. When activated, this feature
enforces HTTPS access to all domains attached to the application, including the
one provided by Scalingo.

{% note %}
Unless you find yourself in a very specific situation where HTTP is required,
**we strongly advise to enable this feature** for improved security and
confidentiality.
{% endnote %}

The platform uses two distinct mechanism to do so:

1. It returns an HTTP `301 Moved Permanently` redirection from HTTP to HTTPS to
   any request sent to the HTTP URL. Since the redirection is noted as being
   permanent, the client is asked to remember it.

2. It injects a `Strict-Transport-Security` header (HSTS) with a value of
   `max-age=31536000` to HTTPS responses. This header instructs the client to
   interact with the application using only HTTPS connections. The browser must remember this information for 1 year (31536000 seconds).

You can also update your application's code so that it returns the HSTS header.
In such a case, the platform will not override the header value set by the
application.

For more information about HSTS, please check the [Mozilla Developer
Network][hsts].


## Forcing HTTPS

### Using the Dashboard

1. From your web browser, open your [dashboard]
2. Click on the application for which you want to force HTTPS
3. Click the **Settings** tab
4. From the **Settings** submenu, select **Public Routing**
5. Locate the **Force HTTPS** block
6. Turn the **Force HTTPS** toggle on

### Using the Command Line

1. Make sure you have correctly [setup the Scalingo command line tool][cli]
2. From the command line, enable the Force HTTPS feature:
   ```bash
   scalingo --app my-app force-https
   ```
   The output is:
   ```bash
   -----> Force HTTPS has been enabled on my-app
   ```

### Using the Terraform Provider

1. Make sure the `force_https` attribute of the corresponding `resource` block
   is set to `true`:
   ```tf
   resource "scalingo_app" my_app {
     name = "my-app"
     force_https = true
   }
   ```


## Technical Considerations

- Make sure your application works correctly using HTTPS before enabling the
  **Force HTTPS** feature. Once enabled, the application won't be reachable
  without HTTPS.

- Once the feature is enabled and some users have received the HSTS header,
  they will **always** keep using HTTPS to reach your application. Hence, make
  sure HTTPS access keeps working correctly, even if the feature is disabled.

- This feature adds a small lock-in to the platform as it depends on Scalingo's
  infrastructure. If that is something you'd like to avoid, you can implement
  it at the application level: libraries exist for most languages and
  frameworks.
- When using an HTTP verb other than `GET`, clients may not follow the
  [RFC][rfc2626] and use `GET` on the redirection instead of the original verb. \\
  This behavior is specified in [RFC2626][rfc2626], section 10.3.2:

    > If the 301 status code is received in response to a request other
    > than GET or HEAD, the user agent MUST NOT automatically redirect the
    > request unless it can be confirmed by the user, since this might
    > change the conditions under which the request was issued.
    >
    > Note: When automatically redirecting a POST request after
    > receiving a 301 status code, some existing HTTP/1.0 user agents
    > will erroneously change it into a GET request.



*[HSTS]: HTTP Strict Transport Security


[hsts]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Strict-Transport-Security
[rfc2626]: https://www.ietf.org/rfc/rfc2616.txt

[dashboard]: https://dashboard.scalingo.com/

[cli]: {% post_url tools/cli/2000-01-01-start %}

