---
title: Use a custom directory from the Git repository
modified_at: 2015-06-02 00:00:00
tags: deployment build customize
---

It may happen that your project is in a subfolder of your Git repository. It's
completely OK but remind that Scalingo's deployment system looks at the root of
the Git repository by default.

## Custom directory configuration

You need to setup the `PROJECT_DIR` environment variable for your application,
and our build system will automatically look at it. The variable has to target
a valid directory, otherwise the deployment process will fail.

## Example

If your project has the following architecture:

```text
/server
/server/server.go
/server/public/img/logo.png
/server/public/css/style.css
/server/public/js/app.js
/doc
/doc/api.md
```

You want to deploy what is in the `/server` directory, so you have to define
`PROJECT_DIR=server`. That's it! It will be taken into account at your next
deployment.

## Remark

Only the `PROJECT_DIR` directory will be present during runtime. The parent
directory is not added to the application image we are building at the
deployment phase.
