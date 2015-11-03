---
title: Unknown Technology
modified_at: 2015-11-03 17:03:00
category: deployment
tags: app error detection
---

When pushing your app to Scalingo, you might get the following error:

{% highlight text %}
<-- Start deployment of [my-app] -->
 !     We didn't find the type of technology your are using...
       We're sorry this build is failing!
       If you can't find the issue in your application code,
       please send us an email at support@scalingo.com

       <3,
       Scalingo
 !   Error deploying the application
 !   → Invalid return code from buildpack
{% endhighlight %}

## Solutions

### Project in a subdirectory of the git repository

If the project you want to deploy is not at the root of your GIT repository, you need to define the `PROJECT_DIR` environment variable ([see documentation]({% post_url /deployment/2015-06-02-project-dir %})).

### Technology detection

To do so, we are iterating over technologies alphabetically.
If your project contains multiple technologies you will need to specify it by setting an environment variable whose value is the custom multi-buildpack's URL.

More information on [buildpacks](http://doc.scalingo.com/buildpacks/) or [multi-buildpacks](http://doc.scalingo.com/buildpacks/multi)

See how we detect your technology:

#### [Ruby]({% post_url /languages/ruby/2015-06-23-ruby %})

A `Gemfile` should be present at the root of your repository.

#### [Node.js]({% post_url /languages/javascript/nodejs/2015-09-20-nodejs %})

The file `package.json` should be present at the root of the project.

#### [Meteor]({% post_url /languages/javascript/meteor/2015-03-22-meteor %})

The directory `.meteor` should be present at the root of your project.

#### [PHP]({% post_url /languages/php/2014-07-02-php %})

You need to have either an `index.php` file or both `composer.json` + `composer.lock` files at the root of your project.

#### [Python]({% post_url /languages/python/2015-04-05-python %})

The file `requirements.txt` and `setup.py` should be present at the root of your project.

#### [Java]({% post_url /languages/java/2015-09-01-java %})

The file `pom.xml` should be present at the root of your project.

#### [Scala]({% post_url /languages/scala/2015-01-26-scala %})

You need to have at least an `*.sbt` file or a `project/*.scala`/`.sbt/*.scala` file or a `project/build.properties` file.

#### [Groovy]({% post_url /languages/groovy/2015-01-26-groovy %})

The file `grails-app` must be at the root of your project.

#### [Clojure]({% post_url /languages/clojure/2015-01-26-clojure %})

The file `project.clj` must be at the root of your project.

#### [Go]({% post_url /languages/go/2014-12-22-go %})

You need to have at least one `*.go` file at the root of your project.
Then, we detect the Go language and install any dependency with your `Godeps` directory (see more about [Godeps](https://github.com/tools/godep)).

#### [Haskell]({% post_url /languages/haskell/2015-01-26-haskell %})

A file `*.cabal` must be at the root of your project.

#### [Erlang]({% post_url /languages/erlang/2015-01-26-erlang %})

You need to have either a `rebar.config` file or a 'ebin` file at the root of your project.