---
title: Use a custom buildpack
modified_at: 2015-01-04 00:00:00
category: internals
tags: custom, buildpacks, build, image,
---

If you need to deploy a technology which is not supported by Scalingo,
you can used an open-source buildpack or a buildpack you have developed.

To achieve this, you need to define the following environment variable in
the environment of the concerned application: `BUILDPACK_URL`.

Example:

{% highlight text %}
BUILDPACK_URL=https://github.com/cloudfoundry/java-buildpack
{% endhighlight %}

Then during the deployment, you'll be able to see:

{% highlight text %}
<-- Start deployment of myapp -->
-----> Cloning custom buildpack: 'https://github.com/cloudfoundry/java-buildpack'

-- SNIP --
{% endhighlight %}

## Build a custom buildpack

Our execution stack is public and can be found as a docker image on the __Docker Hub__
Its name is [appsdeck/builder:latest](https://registry.hub.docker.com/u/appsdeck/builder/)

{% highlight bash %}
docker pull appsdeck/builder
docker run -v ./custom-buildpack:/buildpack appsdeck/builder:latest bash
{% endhighlight %}

Then if you need to build third-party binaries, you'll be assured that they will work
on our platform.
