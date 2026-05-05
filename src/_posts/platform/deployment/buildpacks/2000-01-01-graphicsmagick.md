---
title: GraphicsMagick Buildpack
modified_at: 2024-10-08 00:00:00
tags: buildpacks build image graphicsmagick
---

## Purpose of this buildpack

By default, our runtime image embeds ImageMagick as image manipulation toolset.
However, you may prefer to have GraphicsMagick tools installed alongside your
application, this buildpack will fit this need.

## Set up this buildpack for your application

This buildpack won't work alone, you need to combine it with the buildpack of the technology you are using. To achieve that you need to make use of the [multi-buildpacks]({% post_url platform/deployment/buildpacks/2000-01-01-multi %}).

You have to write a `.buildpacks` file with the reference to this buildpack and the one
you want to use:

```bash
https://github.com/Scalingo/graphicsmagick-buildpack.git
https://github.com/Scalingo/nodejs-buildpack.git
```

Add this file to your git repository:

```bash
git add .buildpacks
git commit --message="Setup .buildpacks to install GraphicsMagick alongside the application on Scalingo"
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

{% note %}
  Source: [https://github.com/Scalingo/graphicsmagick-buildpack](https://github.com/Scalingo/graphicsmagick-buildpack)
{% endnote %}

## Limiting ImageMagick Resources

ImageMagick supports configuration [via the environment](https://www.imagemagick.org/script/resources.php#environment). You may want to limit the resources used by ImageMagick with the following environment variables:
* `MAGICK_MEMORY_LIMIT`: Set maximum amount of memory in bytes to allocate for the pixel cache from the heap. When this limit is exceeded, the image pixels are cached to memory-mapped disk.
* `MAGICK_MAP_LIMIT`: Set maximum amount of memory map in bytes to allocate for the pixel cache. When this limit is exceeded, the image pixels are cached to disk.
* `MAGICK_TIME_LIMIT`: Set maximum time in seconds. When this limit is exceeded, an exception is thrown and processing stops.
