---
title: Setup your GeoDjango application
modified_at: 2015-11-19 00:00:00
category: languages
tags: python django tutorial postgis geospatial geodjango
index: 3
permalink: /languages/python/setup-geodjango-postgis-libraries/
---

The Django framework integrates extensions to handle geospatial data. To setup
an application which is using such extensions, a bit of work is required:

* PostgreSQL with postgis extension
* Geospatial Libraries

## Enable PostgreSQL 'postgis' extension

Scalingo PostgreSQL includes [several extensions]({% post_url databases/2000-01-01-postgresql-extensions %}).
Postgis the extension to handle geospatial data is among them. To use it with your application, your need
to enable it.

```bash
$ scalingo -a appname pgsql-console
> CREATE EXTENSION postgis;
```

Then the database is ready, next step is to install the libraries django requires to manipulate these data.

## Install Geospatial libraries

These libraries are **proj**, **geos** and **gdal**. Considered that they are not used commonly, they are
not included in our default environment so you need to install them at deployment time.

### Usage of the geo-buildpack

To deploy an application with these libraries you need to use an additional the default python buildpack.

<blockquote class="info">
Reminder, a buildpack is a piece of software able to detect and install dependencies of a given technology.
More information about <a href="{% post_url internals/buildpacks/2015-01-04-buildpacks %}">Scalingo's buildpacks</a>.
</blockquote>

Create a `.buildpacks` file at the root of your project with the following content:

```bash
https://github.com/Scalingo/geo-buildpack
https://github.com/Scalingo/python-buildpack
```

Then setup the [multi buildpack]({% post_url internals/buildpacks/2015-09-28-multi-buildpack %}) for your project to handle this file:

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

