---
title: Scala
modified_at: 2015-01-26 00:00:00
category: languages
tags: scala
show_in_toc: true
---

Scala is officially supported on Scalingo

It uses [sbt](https://github.com/harrah/xsbt/) 0.11.0+.

Usage
-----

Example usage:

{% highlight bash %}
$ ls
Procfile build.sbt project src

$ scalingo create scala-app

$ git push scalingo master
...
-----> Scala app detected
-----> Building app with sbt
-----> Running: sbt compile stage
{% endhighlight %}

The buildpack will detect your app as Scala if it has the project/build.properties and either .sbt or .scala based build config.  It vendors a version of sbt and your popluated .ivy/cache into your container.  The .ivy2 directory will be cached between builds to allow for faster build times.

Clean builds
------------

In some cases, builds need to clean artifacts before compiling. If a clean build is necessary, configure builds to perform clean by setting `SBT_CLEAN=true`:

{% highlight bash %}
$ scalingo env-set SBT_CLEAN=true
SBT_CLEAN has been set to true.
{% endhighlight %}

All subsequent deploys will use the clean task. To remove the clean task, unset `SBT_CLEAN`:

{% highlight bash %}
$ scalingo env-unset SBT_CLEAN
SBT_CLEAN has been unset.
{% endhighlight %}

Buildpack
---------

More details at https://github.com/Scalingo/scala-buildpack
