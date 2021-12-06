---
title: Install Puppeteer
modified_at: 2021-12-03 00:00:00
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
$ echo 'https://github.com/Scalingo/apt-buildpack' > .buildpacks
$ echo 'https://github.com/Scalingo/nodejs-buildpack' >> .buildpacks
$ git add .buildpacks
$ git commit -m 'Add multi-buildpack'
```

You need to instruct the APT buildpack to install the dependencies Puppeteer requires. Create a `Aptfile` at the root of your project with the following content:

```
gconf-service libasound2 libatk1.0-0 libatk-bridge2.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget libcairo-gobject2 libxinerama1 libgtk2.0-0 libpangoft2-1.0-0 libthai0 libpixman-1-0 libxcb-render0 libharfbuzz0b libdatrie1 libgraphite2-3
```
