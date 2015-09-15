---
title: Clojure
modified_at: 2015-01-26 00:00:00
category: languages
tags: clojure
show_in_toc: true
---

Clojure is supported on Scalingo, you can deploy your apps

It uses [Leiningen](http://leiningen.org).

Note that you don't have to do anything special to use this buildpack
with Clojure apps on Scalingo; it will be used by default for all
projects containing a project.clj file, though it may be an older
revision than what you're currently looking at.

## Usage

Example usage for an app already stored in git:

{% highlight bash %}
$ tree
|-- Procfile
|-- project.clj
|-- README
`-- src
    `-- sample
        `-- core.clj

$ scalingo create clojure-app

$ git push scalingo master
...
-----> Fetching custom buildpack
-----> Clojure app detected
-----> Installing Leiningen
       Downloading: leiningen-2.2.0-standalone.jar
       Writing: lein script
-----> Building with Leiningen
       Running: with-profile production compile :all
       Downloading: org/clojure/clojure/1.2.1/clojure-1.2.1.pom from central
       Downloading: org/clojure/clojure/1.2.1/clojure-1.2.1.jar from central
       Copying 1 file to /tmp/build_2e5yol0778bcw/lib
-----> Discovering process types
       Procfile declares types -> core
Build complete, shipping your container
Waiting for you application to boot
<-- https://clojure-app.scalingo.io -->
{% endhighlight %}

The buildpack will detect your app as Clojure if it has a
`project.clj` file in the root. If you use the
[clojure-maven-plugin](https://github.com/talios/clojure-maven-plugin),
[the standard Java buildpack](http://github.com/Scalingo/java-buildpack)
should work instead.

## Configuration

Leiningen 1.7.1 will be used by default, but if you have
`:min-lein-version "2.0.0"` in project.clj (highly recommended) then
the latest Leiningen 2.x release will be used instead.

Your `Procfile` should declare what process types which make up your
app. Often in development Leiningen projects are launched using `lein
run -m my.project.namespace`, but this is not recommended in
production because it leaves Leiningen running in addition to your
project's process. It also uses profiles that are intended for
development, which can let test libraries and test configuration sneak
into production.

In order to ensure consistent builds, normally values set with `scalingo
env-set ...` (other than `LEIN_USERNAME`, `LEIN_PASSWORD`, and
`LEIN_PASSPHRASE`) will not be visible at compile time. To expose more
to the compilation process, set a `BUILD_CONFIG_WHITELIST` config var
containing a space-delimited list of config var names. Note that this
can result in unpredictable behaviour since changing your app's config
does not result in a rebuild of your app. So it's easy to get into a
situation where your build is broken, but you don't notice it until
later when you push. For this reason it's recommended to take care
with this feature and always push after changing a whitelisted config
value.

## Buildpack

More information at https://github.com/Scalingo/clojure-buildpack
