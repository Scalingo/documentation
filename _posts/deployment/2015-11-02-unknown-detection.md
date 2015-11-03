---
title: Unknown Technology
modified_at: 2015-11-03 10:26:00
category: deployment
tags: app error crash detection
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

If the project you want to deploy is not at the root of your GIT repository, you need to define the `PROJECT_DIR` the environment variable ([see documentation]({% post_url /deployment/2015-06-02-project-dir %})).

### Technology detection

See how we detect your technology:
* [Clojure]({% post_url /languages/clojure/2015-01-26-clojure %})
* [Erlang]({% post_url /languages/erlang/2015-01-26-erlang %})
* [Go]({% post_url /languages/go/2014-12-22-go %})
* [Groovy]({% post_url /languages/groovy/2015-01-26-groovy %})
* [Haskell]({% post_url /languages/haskell/2015-01-26-haskell %})
* [Java]({% post_url /languages/java/2015-09-01-java %})
* [Java]({% post_url /languages/java/2015-09-01-java %})
* [Javascript]({% post_url /languages/javascript/2015-02-09-javascript %})
* [Php]({% post_url /languages/php/2014-07-02-php %})
* [Python]({% post_url /languages/python/2015-04-05-python %})
* [Ruby]({% post_url /languages/ruby/2015-06-23-ruby %})
* [Scala]({% post_url /languages/scala/2015-01-26-scala %})
