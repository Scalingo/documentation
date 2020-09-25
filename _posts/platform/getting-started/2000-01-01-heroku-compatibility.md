---
title: Heroku Compatibility
modified_at: 2020-09-25 00:00:00
tags: heroku
index: 10
---

Our aim for Scalingo is to be fully compatible with Heroku. If your app works
on Heroku, it will work on Scalingo. We've added several compatibility layers
for that matter.

## Procfile

If a **Procfile** is available in the source of your app, it will be used. See
the [dedicated Procfile page]({% post_url platform/app/2000-01-01-procfile %})
for more informations.

The Procfile `release` entry does not exist on Scalingo thus it won't be executed. The
[postdeploy hook]({% post_url platform/app/2000-01-01-postdeploy-hook %}) exists with similar functionality. The difference is that the
*postdeploy* hook is only getting executed at the end of a successful
deployment, not at each change of variable/addon modification (creating a
release).

## Buildpacks

Most buildpacks and their functionalities work exactly the same as on Heroku.
Some buildpacks are written and maintained by our own. It's open source. Check
our [GitHub account](https://github.com/Scalingo/?query=buildpack) to see the
whole list.

## Environment Variables

Because we'd like to conform as much as possible to the
[12-factor](http://12factor.net/) principle, you can configure your app through
[environment variables]({% post_url platform/app/2000-01-01-environment %})
which are injected into the context of your application.

## Realtime Deployment

Based on a Git hook. Just git push your code!

## Open API and Command Line Client

* [Open API](http://developers.scalingo.com/)
* [Command Line Interface client](http://cli.scalingo.com/)
