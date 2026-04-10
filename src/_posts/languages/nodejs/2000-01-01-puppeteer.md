---
title: Install Puppeteer
modified_at: 2026-04-09 00:00:00
tags: nodejs puppeteer
---

Puppeteer is a library to headless Chrome API. In short, most things that you can do manually in the browser can be achieved with a program using Puppeteer. By default, installing Puppeteer on a Scalingo application fails because the X11 library are not included in Scalingo base image. The error message is:

```
[Nest] 31 - 10/24/2019, 4:08:50 PM [ExceptionsHandler] Failed to launch chrome!
/app/node_modules/puppeteer/.local-chromium/linux-686378/chrome-linux/chrome: error while loading shared libraries: libX11-xcb.so.1: cannot open shared object file: No such file or directory
```

## Install Puppeteer on a Scalingo Application

To install Puppeteer on a Scalingo application, you need to make use of [the APT buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-apt %}). Such a buildpack should be used as part of a [multi-buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-multi %}).

```bash
echo 'https://github.com/Scalingo/apt-buildpack' > .buildpacks
echo 'https://github.com/Scalingo/nodejs-buildpack' >> .buildpacks
git add .buildpacks
git commit --message="Add multi-buildpack"
```

Depending on your stack, you'll need different system dependencies in the `Aptfile` at the root of your project.

- For `scalingo-22`:

- For `scalingo-24`:

{% note %}
These are minimal dependencies, a more thorough list of system dependencies is available in the chromium [source repository](https://source.chromium.org/chromium/chromium/src/+/main:chrome/installer/linux/debian/dist_package_versions.json;l=150)
{% endnote %}

```
```

{% warning %}
Puppeteer must be run with the option `--no-sandbox` on Scalingo. This option must be added with care. You should only add this option against some code you own.
{% endwarning %}
