---
title: Setup your GeoDjango application
modified_at: 2015-11-19 00:00:00
tags: python django tutorial postgis geospatial geodjango
index: 2
---

The Django framework integrates extensions to handle geospatial data. To setup
an application which is using such extensions, a bit of work is required:

* PostgreSQL with PostGIS extension
* Geospatial libraries

## Enable PostgreSQL PostGIS Extension

Scalingo PostgreSQL includes [several extensions]({% post_url
addons/scalingo-postgresql/2000-01-01-extensions %}). PostGIS is an extension to
handle geospatial data. After adding a PostgreSQL database to your application,
you can enable the PostGIS extension with:

```bash
$ scalingo --app my-app pgsql-console
> CREATE EXTENSION postgis;
```

Next step is to install the libraries Django requires to manipulate these data.

## Install Geospatial Libraries

These libraries are **proj**, **geos** and **gdal**. Considering that they are
not used commonly, they are not included in our default environment so you need
to install them at deployment time.

### Usage of the geo-buildpack

To deploy an application with these libraries you need to use an additional
buildpack along with the default Python buildpack.

{% note %}
  Reminder: a buildpack is a piece of software able to detect and install
  dependencies of a given technology.  More information about <a href="{% post_url platform/deployment/buildpacks/2000-01-01-buildpacks %}">Scalingo's
  buildpacks</a>.
{% endnote %}

Create a `.buildpacks` file at the root of your project with the following
content:

```text
https://github.com/Scalingo/geo-buildpack
https://github.com/Scalingo/python-buildpack
```

Then setup the [multi buildpack]({% post_url
platform/deployment/buildpacks/2000-01-01-multi %}) for your project to handle
this file:

```bash
scalingo env-set BUILDPACK_URL=https://github.com/Scalingo/multi-buildpack
```

### Deploy your application

```bash
git add .buildpacks
git commit -m "Use geo-buildpack as long as python-buildpack"
git push scalingo master
```

Then you'll see in your deployment output:

```text
=====> Downloading Buildpack: https://github.com/Scalingo/geo-buildpack.git
=====> Detected Framework: geos/gdal/proj
       Using geos version: 3.4.2
       Using gdal version: 1.11.1
       Using proj version: 4.8.0_1
       ...
```

