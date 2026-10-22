---
modified_at: 2026-10-22 00:00:00
title: 'Routing: multipart uploads can now be configured with the CLI'
---

You can now enable or disable multipart requests on your application's router
with the `router-multipart-upload` command in Scalingo CLI **1.51.0** or later.

This setting is available for all applications, regardless of their language or
buildpack.

{% note %}
If you deployed a PHP application before October 21, 2026, you must explicitly
re-enable multipart requests to accept them again.
{% endnote %}

To re-enable file uploads and form submissions using `multipart/form-data`:

```sh
scalingo --app my-app router-multipart-upload --enable
```

See [Multipart Uploads][multipart-uploads] for details about this router setting.

[multipart-uploads]: {% post_url platform/networking/public/2000-01-01-routing %}#multipart-uploads
