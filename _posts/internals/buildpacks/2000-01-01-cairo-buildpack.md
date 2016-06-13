---
title: Cairo Buildpack
modified_at: 2016-06-13 00:00:00
categories: internals
tags: buildpacks build image cairo pango fontconfig pixman harfbuzz gitlib
---

# Purpose of this buildpack

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

## [Hacking] Building librairies

It uses Docker and Scalingo builder stack image
[`scalingo/builder`](https://hub.docker.com/r/scalingo/builder)

```bash
make
```

Artifacts will be dropped in `dist/`.  See `cairo-scalingo/Dockerfile` for build options.

## [Hacking] Uploading to S3

The following variables should be defined:

* `AWS_ACCESS_KEY`
* `AWS_SECRET_KEY`

The buckets files will get uploaded to is defined in `config/s3.sh`

```bash
make
support/upload_to_s3.sh
```

That's it, result of make has been synced in your S3 bucket.

## Cairo Configuration

```
cairo (version 1.14.6 [release]) will be compiled with:

The following surface backends:
  Image:         yes (always builtin)
  Recording:     yes (always builtin)
  Observer:      yes (always builtin)
  Mime:          yes (always builtin)
  Tee:           no (disabled, use --enable-tee to enable)
  XML:           no (disabled, use --enable-xml to enable)
  Skia:          no (disabled, use --enable-skia to enable)
  Xlib:          yes
  Xlib Xrender:  no (requires  http://freedesktop.org/Software/xlibs)
  Qt:            no (disabled, use --enable-qt to enable)
  Quartz:        no (requires CoreGraphics framework)
  Quartz-image:  no (disabled, use --enable-quartz-image to enable)
  XCB:           no (requires xcb >= 1.6 xcb-render >= 1.6 http://xcb.freedesktop.org)
  Win32:         no (requires a Win32 platform)
  OS2:           no (disabled, use --enable-os2 to enable)
  CairoScript:   yes
  PostScript:    yes
  PDF:           yes
  SVG:           yes
  OpenGL:        no (disabled, use --enable-gl to enable)
  OpenGL ES 2.0: no (disabled, use --enable-glesv2 to enable)
  BeOS:          no (disabled, use --enable-beos to enable)
  DirectFB:      no (disabled, use --enable-directfb to enable)
  OpenVG:        no (disabled, use --enable-vg to enable)
  DRM:           no (disabled, use --enable-drm to enable)
  Cogl:          no (disabled, use --enable-cogl to enable)

The following font backends:
  User:          yes (always builtin)
  FreeType:      yes
  Fontconfig:    yes
  Win32:         no (requires a Win32 platform)
  Quartz:        no (requires CoreGraphics framework)

The following functions:
  PNG functions:   yes
  GLX functions:   no (not required by any backend)
  WGL functions:   no (not required by any backend)
  EGL functions:   no (not required by any backend)
  X11-xcb functions: no (disabled, use --enable-xlib-xcb to enable)
  XCB-shm functions: no (requires --enable-xcb)

The following features and utilities:
  cairo-trace:                yes
  cairo-script-interpreter:   yes

And the following internal features:
  pthread:       yes
  gtk-doc:       no
  gcov support:  no
  symbol-lookup: no (requires bfd)
  test surfaces: no (disabled, use --enable-test-surfaces to enable)
  ps testing:    no (requires libspectre)
  pdf testing:   no (requires poppler-glib >= 0.17.4)
  svg testing:   no (requires librsvg-2.0 >= 2.35.0)
```

## Harfbuzz Configuration

```
Build configuration:

Unicode callbacks (you want at least one):
	Glib:			true
	ICU:			false
	UCDN:			false

Font callbacks (the more the better):
	FreeType:		true

Tools used for command-line utilities:
	Cairo:			true

Additional shapers (the more the better):
	Graphite2:		false

Platform shapers (not normally needed):
	CoreText:		false
	Uniscribe:		false

Other features:
	Documentation:		no
	GObject bindings:	false
	Introspection:		false
```

