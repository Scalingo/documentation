---
title: Use a custom directory from the GIT repository
modified_at: 2015-06-02 00:00:00
category: deployment
tags: deployment build customize
---

It may happen that your project is in a subfolder of your GIT repository.
It's completely OK but you have to notice Scalingo's deployment system about
it as the default behaviour is to look at the root of the GIT repository.

## Custom directory configuration

You need to setup the `PROJECT_DIR` environment variable for your application,
and automatically our build system will look at it. The variable has to target
a valid directory, otherwise the deployment process will fail.

## Example

If your project has the following architecture:

{% highlight text %}
/server
/server/server.go
/server/public/img/logo.png
/server/public/css/style.css
/server/public/js/app.js
/doc
/doc/api.md
{% endhighlight %}

You want to deploy what is in the `/server` directory, so you have to define
`PROJECT_DIR=server`. That's it, it will be taken into account at your next
deployment.

## Remark

Only the `PROJECT_DIR` directory will be present during runtime, the parent
directory is not added to the application image we are building at the
deployment time.
