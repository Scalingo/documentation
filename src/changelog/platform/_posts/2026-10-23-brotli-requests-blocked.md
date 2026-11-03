---
modified_at: 2026-10-23 00:00:00
title: 'Existing Node.js and multi-buildpack apps: Brotli-compressed requests blocked'
---

Scalingo is changing incoming request filtering for existing applications using the
[Node.js buildpack][nodejs] or [multi-buildpack][multi-buildpack], in response to the
[Node.js Brotli decoder vulnerability (Node2Shell)][advisory].

The rule also applies to multi-buildpack applications that do not run Node.js.

## Incoming requests

Starting October 23, 2026 at **15:00 CEST (UTC+2)**, Scalingo will reject incoming
requests with the `Content-Encoding: br` header to applications that already
exist at that time and use either buildpack. **Applications created after this
time are not affected by this change.**

Only requests with this header will be blocked by this rule. Scalingo will return
**HTTP 415 Unsupported Media Type**; these requests will not reach the application.

Contact [Scalingo support][support] if you need the filtering rule disabled.
Disabling it can expose applications that decode Brotli request bodies on an
unpatched Node.js version.

## Node.js updates

This filtering applies only to incoming requests. If your application runs
Node.js, you still need to update it to address Brotli-compressed responses
fetched by your application.
Rebuild and redeploy with a fixed release: **22.23.4**, **24.22.1** or **26.12.1**
on the corresponding Node.js release line, or a later version.

See [security bulletin SSB-2026-007][bulletin] for deployment instructions and
incident details.

[advisory]: https://nodejs.org/en/blog/vulnerability/october-2026-security-releases#nodejs-brotli-decoder-out-of-bounds-write-permits-remote-code-execution-cve-2026-111497---high
[bulletin]: {% post_url security/bulletins/2026-10-23-SSB-2026-007 %}
[nodejs]: {% post_url languages/nodejs/2000-01-01-start %}
[multi-buildpack]: {% post_url platform/deployment/buildpacks/2000-01-01-multi %}
[support]: mailto:support@scalingo.com
