---
title: Child Application
modified_at: 2023-12-22 00:00:00
tags: app child
index: 32
---

You may want to create an application that inherit from an existing
application. To ease this action, we created an endpoint on our API to [create
a child
application](https://developers.scalingo.com/apps.html#create-a-child-application).

A child application inherits some properties of the parent app:

* the stack
* the owner

This feature can be very interesting to implement your own [Review Apps]({%
post_url platform/app/2000-01-01-review-apps %}) for codes that are not hosted
on officially supported SCM tools.

## Deployment of a Child App

Creating a child app does not deploy it. You can deploy it with:

```sh
# child app name is 'child-app-1'
git remote add child-app-1 git@ssh.osc-fr1.scalingo.com:child-app-1.git
git push child-app-1 master
```

Note that the remote URL depends on the region of your application. You can get
it using our CLI with:

```bash
scalingo --app child-app-1 git-show
```

Or you can use our API to directly deploy an archive (.tar.gz).

The API documentation to trigger this deployment can be found
[here](https://developers.scalingo.com/deployments.html#trigger-manually-a-deployment-from-an-archive)
