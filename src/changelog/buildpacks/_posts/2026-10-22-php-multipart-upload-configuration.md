---
modified_at: 2026-10-22 00:00:00
title: 'PHP: multipart uploads can now be configured with the CLI'
---

You can now enable or disable multipart requests on your application's router
with the `router-multipart-upload` command in Scalingo CLI **1.51.0** or later.
You no longer need to contact support to change this setting.

To re-enable file uploads and form submissions using `multipart/form-data`:

```sh
scalingo --app my-app router-multipart-upload --enable
```

We recommend deploying a fixed PHP version before re-enabling multipart
requests. See [security bulletin SSB-2026-005][bulletin] for the update
instructions.

This command changes the router setting only. PHP session upload progress
(`session.upload_progress.enabled`) remains disabled by the PHP buildpack.

[bulletin]: {% post_url security/bulletins/2026-10-21-SSB-2026-005 %}
