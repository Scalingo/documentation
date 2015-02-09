---
title: Meteor
category: languages
date: 09/02/2015
tags: programming, dev, nodejs, language, meteor, scaling
---

# Meteor

Meteor is a complete open source platform for building web and mobile apps in pure JavaScript.
It focuses problematics around real time web to emphasize the most fluent experience possible.

## Getting Started

Deploy your first __Meteor__ application: [URL](/languages/javascript/nodejs/getting-started-with-meteor.html)

## Configuration

### Node.js version

As you don't always have a `package.json` file in a Meteor project, we've built a way to specify the node
version you want to use. You just have to create a `.node-version` file at the root of your project,
containing the version requirement:

Example:

```
0.12.x
```

### Meteor settings

According to the 12 factors, the environment should be the source of all the configuration of your app.
However sometimes, it's not enough and you want to user Meteor built-in settings system. No problem
with that.

If you have a `settings.json` or a `config/settings.json` file you usually run with
`meteor --settings settings.json`, it will automatically be detected and the variable `METEOR_SETTINGS`
will be set with its content. Allowing Meteor to handle the settings file.

## How to scale __Meteor__

As a real time framework, the number of scaling constraints is higher than another more classical
framework. Each instance is keeping some stateful information and each instance has to be able to
get instantly the most up-to-date data. To achieve that, the two common processes used are the
_sticky sessions_ and the _oplog_ feature of MongoDB.

### Oplog

__Oplog__ is a MongoDB feature which logs all the operations achieved on a MongoDB cluster. __Meteor__
uses this feature to sync different instances of an application.

> See also [Oplog Observe Driver](https://github.com/meteor/meteor/wiki/Oplog-Observe-Driver)

It can be enabled from the addon database dashboard. When activated it wil automatically add the
`MONGO_OPLOG_URL` in your application. This variable name is the standard name to configure __Meteor__.
As a result, you juste have to restart your application.

> ![Link to Dashboard](/assets/images/database/link-to-dashboard.png)

<blockquote class="info">
  This operation will restart your database instance so your application may raise an exception
</blockquote>

### Sticky Sessions

> The usage of _sticky sessions_ is also know as _session affinity_

Session affinity is the process save on which instance a given user has been routed, and to use
this route again for a given time. Our load balancers have _sticky sessions_ enabled automatically
for __Meteor__ apps. A user will keep using the same route during 1 hour.

You have nothing to do except increasing the amount of containers you are using, to do
so, open the dashboard of your application and in the _containers_ tab, then you can increase the amount
of containers as needed, click on _scale_ and the amount of instances will be scaled instantly.

