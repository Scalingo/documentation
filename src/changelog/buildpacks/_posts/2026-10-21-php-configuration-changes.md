---
modified_at: 2026-10-21 16:00:00
title: 'PHP: upload progress disabled and multipart requests blocked'
---

On October 21, 2026, Scalingo changed PHP upload handling in response to the
PHP2Shell vulnerabilities.

## Upload progress tracking

The Scalingo PHP buildpack now disables `session.upload_progress.enabled` in
`php.ini` and enforces it in the PHP-FPM pool. Applications must be rebuilt and
redeployed to receive this configuration. This disables upload progress tracking;
the setting itself does not disable file uploads.

We expect to re-enable `session.upload_progress.enabled` globally in a future
PHP buildpack update.

## Multipart requests

The router now returns **403 Forbidden** for requests to PHP applications with a
`multipart/*` content type, including file uploads and forms using
`multipart/form-data`. These requests do not reach the application. The rule
applies immediately, without a rebuild or restart.

Redeploying with a fixed PHP version does not remove the router restriction.

For now, **only Scalingo support can re-enable multipart requests** for your
application. Contact support if your application requires multipart uploads.
We will make multipart request blocking configurable in our user interfaces.

See [security bulletin SSB-2026-005][bulletin] for the deployment instructions
and incident details.

[bulletin]: {% post_url security/bulletins/2026-10-21-SSB-2026-005 %}
