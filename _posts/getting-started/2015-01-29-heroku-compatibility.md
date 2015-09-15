---
title: Heroku Compatibility
modified_at: 2015-01-29 00:00:00
category: getting-started
tags: heroku
---

Scalingo uses buildpack technology. Thus, if your application works on Heroku, it will work on Scalingo.

## Procfile

If a Procfile is available in the source of your app, it will be used.

## Buildpacks

Most buildpacks and their functionnalities work exactly the same as on Heroku. If we had customized it, it's open source. Check your [Github account](https://github.com/Scalingo/) to see the whole list.

## Realtime deployment

Based on a Git hook. Just git push your code!

## Open API and command-line client

* [Open API](http://developers.scalingo.com/)
* [Command Line Interface client](http://cli.scalingo.com/)
