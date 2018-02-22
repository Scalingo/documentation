---
title: Wkhtmltopdf Buildpack
modified_at: 2016-10-27 00:00:00
categories: internals
tags: buildpacks build wkhtmltopdf
---

## Purpose of this buildpack

This is a buildpack that installs [wkhtmltopdf](http://wkhtmltopdf.org) into a container image.

{% note %}
  `wkhtmltopdf` is a command line tools to render HTML into PDF using the Qt WebKit rendering engine.
{% endnote %}

You may find useful to use such a tool as part of your web application. Hence, we developed a [specific buildpack](https://github.com/Scalingo/wkhtmltopdf-buildpack) to ease the installation of this tool. Such a buildpack should be use as part of a [multi-buildpack]({% post_url internals/buildpacks/2015-09-28-multi-buildpack %}).

## Disclaimer

Please be aware that this software is known to have different rendering depending on the installed version. This buildpack installs a specific version known to work on our infrastructure that might render things differently than your local installation.

## Set up this buildpack for your application

We describe in this section the different step to reproduce in order to use this buildpack depending on the technology you use.

You will need to setup your application to use a multi-buildpack environment. Then, your application will need both the `wkhtmltopdf` buildpack and the one for the technology you use in your application. Here is an example using the Ruby buildpack:

```bash
$ scalingo env-set 'BUILDPACK_URL=https://github.com/Scalingo/multi-buildpack.git'
$ echo 'https://github.com/Scalingo/wkhtmltopdf-buildpack' >> .buildpacks
$ echo 'https://github.com/Scalingo/ruby-buildpack' >> .buildpacks
$ git add .buildpacks
$ git commit -m 'Add multi-buildpack'
```

You will find a comprehensive list of our buildpacks on [this page]({% post_url internals/buildpacks/2015-01-04-buildpacks %}#buildpacks-included-on-scalingo).
