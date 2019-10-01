---
title: Child application
modified_at: 2019-08-26 00:00:00
tags: app child
index: 32
---

You may want to create an application that inherit from an existing
application. To ease this action, we created an endpoint on our API to [create
a child
application](http://developers.scalingo.com/apps.html#create-a-child-application).

When creating a child application, the following elements are cloned:

* Environment variables
* Addons
* Collaborators
* Notifications settings

This feature can be very interesting to implement your own [Review Apps]({%
post_url platform/app/2000-01-01-review-apps %}) for codes that are not hosted
on unsupported SCM tools.

## Deployment of a child app

When you create a child app of an application, it inherits resources from its
parent app, but you still need to deploy it.

It can be done thanks to a git push:

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
