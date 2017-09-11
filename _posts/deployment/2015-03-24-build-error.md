---
title: Build Errors
modified_at: 2015-03-24 00:00:00
category: deployment
tags: app error deployment quota
---

When your application is deployed, the dependencies are gathered and are packaged
into an _application image_

<h2>Invalid return code from buildpack</h2>

You application image is built using a buildpack ([List of buildpacks]({% post_url internals/buildpacks/2015-01-04-buildpacks %})).
If the buildpack exits with an error, it is probably linked to your project. You should 
be able to see the content of the error in your console, then adapt your code according to it.

If you think the error comes from our buildpacks, feel free to contact us and we will fix
it as soon as we can.

<h2>Image too large</h2>

The maximal size of an application image is __650MB__. If your assets, your
dependencies and the code of your application is weighing more that this limit.
Different solutions are available to lighten the image of your application:

* Try to remove unused external dependencies or assets.
* Define a [.slugignore file]({% post_url internals/2015-03-24-slugignore %}) to exclude files from the
  image.

If you absolutely need all these data, please contact us at
[support@scalingo.com](mailto:support@scalingo.com).

<blockquote class="bg-info">
  Why this quota? Besides being a simple security limit, this quota is also present to
  preserve the PaaS user experience. A large image results in longer deployments, the
  instantaneity aspect is lost.
</blockquote>
