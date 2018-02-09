---
title: Using PhantomJS and Spiderable to build static pages with Meteor
modified_at: 2016-08-14 00:00:00
category: languages
tags: nodejs meteor tutorial fragment phantomjs spiderable crawler static
permalink: /languages/javascript/meteor/spiderable-phantomjs-static-fragment/
---

## Context

A Meteor application is a fully dynamic website. When a request is done
to the application it returns an almost empty page containing one JavaScript
file which takes care to start the app on the client browser.

When a crawler like **GoogleBot** is looking at your website it is specifying
the following query parameter `_escaped_fragment_=`

In this case Meteor has been built to use PhantomJS through the `spiderable`
package to generate the static rendering of your application.

## Meteor package 'ongoworks:spiderable'

```bash
meteor add ongoworks:spiderable
```

By adding this package, your website will automatically respond to the requests
of static fragment. You can try the following request on your application in
development:

```
curl http://localhost:3000?_escaped_fragment_=
```

## Incompatible package `spiderable`

The package named `spiderable` is not compatible with restricted environment
like Scalingo's containers, that is why we are advising you to use
`ongoworks:spiderable` instead of `spiderable`

## Installation of PhantomJS

### Meteor version ≥ 1.3

PhantomJS installation has to be done from the npm package of the same name.

```bash
meteor npm install --save phantomjs
```

### Meteor version < 1.3

npm modules can't be used easily, so we have to use a wrapper around the
original npm module, use the package `dfischer:phantomjs` from atmosphere:

```bash
meteor add dfischer:phantomjs
```

## Common problem

### `spiderable` package is used

```text
Resolved Spiderable request / to http://localhost:8080/
spiderable: phantomjs failed at http://localhost:8080/
stderr:
stdout:
spiderable: phantomjs failed: Error: Command failed:
    at ChildProcess.exithandler (child_process.js:658:15)
    at ChildProcess.emit (events.js:98:17)
    at maybeClose (child_process.js:766:16)
    at Process.ChildProcess._handle.onexit (child_process.js:833:5)
stderr:
Resolved Spiderable request / to http://localhost:8080/
Error: Meteor code must always run within a Fiber. Try wrapping callbacks that you pass to non-Meteor libraries with Meteor.bindEnvironment.
    at Object.Meteor._nodeCodeMustBeInFiber (packages/meteor/dynamics_nodejs.js:9:1)
    at [object Object]._.extend.get (packages/meteor/dynamics_nodejs.js:21:1)
    at [object Object].RouteController.lookupOption (packages/iron_router/lib/route_controller.js:66:1)
    at new Controller.extend.constructor (packages/iron_router/lib/route_controller.js:26:1)
    at [object Object].ctor (packages/iron_core/lib/iron_core.js:88:1)
    at Function.Router.createController (packages/iron_router/lib/router.js:201:1)
    at Function.Router.dispatch (packages/iron_router/lib/router_server.js:39:1)
    at Object.router (packages/iron_router/lib/router.js:15:1)
    at next (/app/.app-build/bundle/programs/server/npm/webapp/node_modules/connect/lib/proto.js:190:15)
    at packages/spiderable/spiderable_server.js:128:1
    at ChildProcess.exithandler (child_process.js:656:7)
    at ChildProcess.emit (events.js:98:17)
    at maybeClose (child_process.js:766:16)
    at Process.ChildProcess._handle.onexit (child_process.js:833:5)
spiderable: phantomjs failed at http://localhost:8080/: null
```

As stated in this article the package `ongoworks:spiderable` should be used as
in-place replacement of the `spiderable` package, please run the following
commands:

```bash
meteor remove spiderable
meteor add ongoworks:spiderable
git add .meteor/versions .meteor/packages
git commit -m "use ongoworks:spiderable instead of spiderable"
git push scalingo master
```
