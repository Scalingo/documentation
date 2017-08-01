---
title: GraphicsMagick Buildpack
modified_at: 2016-05-24 00:00:00
categories: buildpacks
tags: build buildpacks image graphicsmagick
---

# Purpose of this buildpack

By default, our runtime image embeds ImageMagick as image manipulation toolset.
However, you may prefer to have GraphicsMagick tools installed alongside your
application, this buildpack will fit this need.

## Set up this buildpack for your application

This buildpack won't work alone, you need to combine it with the buildpack of the technology you are using. To achieve
that you need to setup the [Multi Buildpack](http://doc.scalingo.com/buildpacks/multi):

```bash
scalingo env-set BUILDPACK_URL=https://github.com/Scalingo/multi-buildpack.git
```

Then you have to write a `.buildpacks` file with the reference to this buildpack and the one
you want to use:

```bash
https://github.com/Scalingo/graphicsmagick-buildpack.git
https://github.com/Scalingo/nodejs-buildpack.git
```

Add this file to your git repository:

```bash
git add .buildpacks
git commit -m "Setup .buildpacks to install GraphicsMagick alongside the application on Scalingo"
```

## Deploy your application

```bash
git push scalingo master
```

## Check everything is working

```bash
$ scalingo run gm version

GraphicsMagick 1.3.23 2015-11-07 Q8 http://www.GraphicsMagick.org/
Copyright (C) 2002-2015 GraphicsMagick Group.
Additional copyrights and licenses apply to this software.
See http://www.GraphicsMagick.org/www/Copyright.html for details.

Feature Support:
  Native Thread Safe       yes
  Large Files (> 32 bit)   yes
  Large Memory (> 32 bit)  yes
  BZIP                     yes
  DPS                      no
  FlashPix                 no
  FreeType                 yes
  Ghostscript (Library)    no
  JBIG                     yes
  JPEG-2000                yes
  JPEG                     yes
  Little CMS               yes
  Loadable Modules         no
  OpenMP                   yes (201107)
  PNG                      yes
  TIFF                     yes
  TRIO                     no
  UMEM                     no
  WebP                     no
  WMF                      yes
  X11                      yes
  XML                      yes
  ZLIB                     yes

Host type: x86_64-unknown-linux-gnu

Configured using the command:
  ./configure  '--prefix' '/app/vendor/graphicsmagick'

Final Build Parameters:
  CC       = gcc -std=gnu99
  CFLAGS   = -fopenmp -g -O2 -Wall -pthread
  CPPFLAGS = -I/usr/include/freetype2 -I/usr/include/libxml2
  CXX      = g++
  CXXFLAGS = -pthread
  LDFLAGS  = -L/usr/lib/x86_64-linux-gnu
  LIBS     = -ljbig -llcms2 -ltiff -lfreetype -ljasper -ljpeg -lpng12 -lwmflite -lXext -lSM -lICE -lX11 -llzma -lbz2 -lxml2 -lz -lm -lgomp -lpthread
```

You should see GraphicsMagick output.

> Source: [https://github.com/Scalingo/graphicsmagick-buildpack](https://github.com/Scalingo/graphicsmagick-buildpack)
