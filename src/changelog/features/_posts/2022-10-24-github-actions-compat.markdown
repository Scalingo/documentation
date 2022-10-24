---
modified_at:	2022-10-24 10:00:00
title:	'GitHub Actions Compatibility for Auto-deploy and Review Apps'
---

Until now, if GitHub Actions were configured on a repository, Scalingo GitHub
integration was not waiting for its status to be successful to initiate a
deployment or the creation of a review app.

This is not the case anymore, GitHub Actions will be waited just like other CIs
in Scalingo integration.

It also adds the compatibilty with any Continuous Integration provider using the
Check Suite/Check Run API from GitHub instead of Commit Status API.
