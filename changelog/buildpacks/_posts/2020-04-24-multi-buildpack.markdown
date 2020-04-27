---
modified_at:	2020-04-24 11:00:00
title:	'Default detection of multi-buildpack'
github: 'https://github.com/Scalingo/multi-buildpack'
---

The [multi-buildpacks]({% post_url platform/deployment/buildpacks/2000-01-01-multi %}) is now automatically detected if you have a `.buildpacks` file at the root of your project.

It means the environment variable `BUILDPACK_URL` is not required anymore to activate it.
