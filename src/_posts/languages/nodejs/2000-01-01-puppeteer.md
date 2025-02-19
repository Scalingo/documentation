---
title: Install Puppeteer
modified_at: 2023-08-28 00:00:00
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

You need to instruct the APT buildpack to install the [dependencies Puppeteer requires](https://pptr.dev/guides/system-requirements/). Create a `Aptfile` at the root of your project with the following content:

```
libasound2
libatk-bridge2.0-0
libatk1.0-0
libatspi2.0-0
libc6
libcairo2
libcups2
libdbus-1-3
libdrm2
libexpat1
libgbm1
libglib2.0-0
libnspr4
libnss3
libpango-1.0-0
libpangocairo-1.0-0
libstdc++6
libudev1
libuuid1
libx11-6
libx11-xcb1
libxcb-dri3-0
libxcb1
libxcomposite1
libxcursor1
libxdamage1
libxext6
libxfixes3
libxi6
libxkbcommon0
libxrandr2
libxrender1
libxshmfence1
libxss1
libxtst6
```

Puppeteer must be run with the option `--no-sandbox` on Scalingo. This option must be added with care. You should only add this option against some code you own.
