---
title: Heroku Compatibility
modified_at: 2015-09-17 21:00:00
category: first-steps
order: 3
tags: heroku
permalink: /heroku-compatibility/
---

Our aim for Scalingo is to be fully compatible with Heroku. If your app works on Heroku, it will work on Scalingo. We've added several compatibility layers for that matter.

## Procfile

If a Procfile is available in the source of your app, it will be used. See the [dedicated Procfile page](/internals/procfile.html) for more informations.

## Buildpacks

Most buildpacks and their functionnalities work exactly the same as on Heroku. Some buildpacks are written and maintained by our own. It's open source. Check your [Github account](https://github.com/Scalingo/?query=buildpack) to see the whole list.

## Environment variables

Because we'd like to conform as much as possible to the [12 factor](http://12factor.net/) principle, you can configure your app through [environment variables](/app/environment.html) which are injected into the context of your application.

## Realtime deployment

Based on a Git hook. Just git push your code!

## Open API and command-line client

* [Open API](http://developers.scalingo.com/)
* [Command Line Interface client](http://cli.scalingo.com/)
