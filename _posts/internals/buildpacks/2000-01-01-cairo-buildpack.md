---
title: Cairo Buildpack
modified_at: 2016-06-13 00:00:00
categories: internals
tags: buildpacks build image cairo pango fontconfig pixman harfbuzz gitlib
---

## Purpose of this buildpack

This is a buildpack that installs [Cairo](http://cairographics.org/) and
its dependencies ([Pango](http://www.pango.org/), [Pixman](http://pixman.org/),
[FreeType](http://www.freetype.org/),
[HarfBuzz](http://www.freedesktop.org/wiki/Software/HarfBuzz/), and
[giflib](http://giflib.sourceforge.net/)) into a container image.

All the libs are installable separately using the `CAIRO_BUILDPACK_LIBS`
environment variable.

When used with
[multi-buildpack](https://github.com/Scalingo/multi-buildpack),
it enables subsequent buildpacks / steps to any of these libraries.

## Set up this buildpack for your application

You'll almost certainly want to use this in conjunction with one or more
additional buildpacks.

When creating a new Scalingo app:

```bash
scalingo create <appname>
scalingo env-set BUILDPACK_URL=https://github.com/Scalingo/multi-buildpack.git

cat << EOF > .buildpacks
https://github.com/Scalingo/cairo-buildpack.git
https://github.com/Scalingo/nodejs-buildpack.git
EOF

git push scalingo master
```

When modifying an existing Scalingo app:

```bash
scalingo env-set BUILDPACK_URL=https://github.com/Scalingo/multi-buildpack.git

cat << EOF > .buildpacks
https://github.com/Scalingo/cairo-buildpack.git
https://github.com/Scalingo/nodejs-buildpack.git
EOF

git push scalingo master
```

## Configuration

Without any particular configuration all the libraries will be installed, but you can specify
a particular set of libs to install thanks to the `CAIRO_BUILDPACK_LIBS` environment variable.

Example:

```
CAIRO_BUILDPACK_LIBS=giflib
CAIRO_BUILDPACK_LIBS=giflib,pixman
CAIRO_BUILDPACK_LIBS=pango,freetype
```

## Contibuting to the buildpack

Github: [Scalingo/cairo-buildpack](https://github.com/Scalingo/cairo-buildpack#hacking-building-librairies)
