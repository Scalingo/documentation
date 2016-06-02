---
title: Deploying Meteor for built-in mobile integration
modified_at: 2016-06-02 00:00:00
category: getting-started
tags: nodejs meteor android ios cordova
---

If you need to use your application as a backend for your Android and iOS application
you need to enable the mobile server build of your application.

You've to setup the `BUILD_MOBILE_PLATFORMS_SERVER` environment variable to `true`.

```bash
scalingo env-set BUILD_MOBILE_PLATFORMS_SERVER=true
```

> Then the buildpack will user the --server-only flag of Meteor. You need to use Meteor ≥ 1.3 to
> use this feature, otherwise it will result in a build error. 
