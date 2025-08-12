---
title: Wkhtmltopdf Buildpack
modified_at: 2023-12-22 00:00:00
tags: buildpacks build wkhtmltopdf
---

{% warning %}
Wkhtmltopdf repository is deprecated since January 2023. You should rather use [Puppeteer]({% post_url languages/nodejs/2000-01-01-puppeteer %}) and the [`pdf`](https://pptr.dev/api/puppeteer.page.pdf/) method.
{% endwarning %}

## Purpose of This Buildpack

This is a buildpack that installs [wkhtmltopdf](https://wkhtmltopdf.org) into a container image.

{% note %}
  `wkhtmltopdf` is a command line tools to render HTML into PDF using the Qt WebKit rendering engine.
{% endnote %}

You may find useful to use such a tool as part of your web application. Hence, we developed a [specific buildpack](https://github.com/Scalingo/wkhtmltopdf-buildpack) to ease the installation of this tool. Such a buildpack should be used as part of a [multi-buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-multi %}).

## Disclaimer

Please be aware that this software is known to have different rendering depending on the installed version. This buildpack installs a specific version known to work on our infrastructure that might render things differently than your local installation.

## Set up This Buildpack for Your Application

We describe in this section the different step to reproduce in order to use this buildpack depending on the technology you use.

You need to setup your application to use a multi-buildpack environment. Then, your application need both the `wkhtmltopdf` buildpack and the one for the technology you use in your application. Here is an example using the Ruby buildpack:

```bash
$ echo 'https://github.com/Scalingo/wkhtmltopdf-buildpack' >> .buildpacks
$ echo 'https://github.com/Scalingo/ruby-buildpack' >> .buildpacks
$ git add .buildpacks
$ git commit -m 'Add multi-buildpack'
```

You find a comprehensive list of our buildpacks on [this page]({% post_url platform/deployment/buildpacks/2000-01-01-intro %}#buildpacks-included-on-scalingo).
