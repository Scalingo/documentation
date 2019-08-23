---
title: Child application
modified_at: 2019-08-23 00:00:00
tags: app child
index: 30
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
post_url platform/app/2000-01-01-review-apps %}) for codes that are not hosted on unsupported SCM tools.

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

Or you can use our API to directly deploy an archive from
GitHub/GitLab/Bitbucket according to your setup.

The API documentation to trigger this deployment can be found
[here](https://developers.scalingo.com/deployments.html#trigger-manually-a-deployment-from-an-archive)

## Example with GitLab

The following script lets you create and deploy a child app from any GitLab instance:

```sh
export AUTH_TOKEN=<scalingo auth token>
export APP=<scalingo app name>
export GITLAB_TOKEN=<gitlab auth token>

./child-app-gitlab.rb my-child-app-1 user/my-private-app development-branch
```

Output:

```
Deployment started (56b226d9-dcab-42cb-bb70-f3ad13beb5b5) for my-child-app-1, waiting.............
Deployment of app 'my-child-app-1' finished with status 'success'
URL is: https://my-child-app-1.scalingo.io

Child apps for <scalingo app name>:
* my-child-app-1 (58d2a7416547b65316b6690e) - https://my-child-app-1.scalingo.io
```

Here is the code of the `child-app-gitlab.rb` script:

<script src="https://gist.github.com/Soulou/2a97e6adfa232526472336ef991489a9.js"></script>

