---
title: Child application
modified_at: 2017-03-10 00:00:00
category: app
tags: app child
---

You may want to create an application that inherit from an existing application. To ease this action, we created an endpoint on our API to [create a child application](http://developers.scalingo.com/apps.html#create-a-child-application).

When creating a child application, the following elements are cloned:

* Environment variables
* Addons
* Collaborators
* Notifications settings

This feature can be very interesting to implement your own [Review Apps]({% post_url 2017-03-10-review-apps %}) for codes that are not hosted on GitHub.
