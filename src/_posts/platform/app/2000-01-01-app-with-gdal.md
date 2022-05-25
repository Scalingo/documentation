---
layout: page
title: Deploy an Application Including the GDAL Library
nav: App Including GDAL
modified_at: 2022-01-25 00:00:00
tags: app gdal geo
index: 120
---

The GDAL library is often used in application needing to manipulate geospatial data. This page describes the steps to deploy an application on Scalingo which makes use of the GDAL library.

## Install GDAL on a Scalingo Application

To install the GDAL library on a Scalingo application, you need to make use of [the APT buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-apt %}). Such a buildpack should be used as part of a [multi-buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-multi %}). For instance, if your application is developed using the Python programming language:

```bash
$ echo 'https://github.com/Scalingo/apt-buildpack' > .buildpacks
$ echo 'https://github.com/Scalingo/python-buildpack' >> .buildpacks
$ git add .buildpacks
$ git commit -m 'Add multi-buildpack'
```

You need to instruct the APT buildpack to install the GDAL library. Create a `Aptfile` at the root of your project with the following content:

```text
gdal-bin
libgdal-dev
```

{% note %}
If your application is using Python, note that GDAL does not seem to be compatible Python 3.9. Please stick with Python 3.8 for now.
{% endnote %}

Last, set the following environment variables on your application:

```sh
PYTHONPATH=/app/.apt/usr/lib/python3/dist-packages/
LD_LIBRARY_PATH=/app/.apt/usr/lib/x86_64-linux-gnu/blas/:/app/.apt/usr/lib/x86_64-linux-gnu/lapack/
PROJ_LIB=/app/.apt/usr/share/proj
```

Deploy your application, it is ready to use the GDAL library!
