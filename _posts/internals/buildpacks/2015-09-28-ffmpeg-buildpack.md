---
title: FFmpeg Buildpack
modified_at: 2015-09-28 00:00:00
categories: internals
tags: buildpacks build image ffmpeg
permalink: /buildpacks/ffmpeg
---

# Purpose of this buildpack

You may need to have the binary `ffmpeg` installed alongside your application, this buildpack will fit this need.

## Set up this buildpack for your application

This buildpack won't work alone, you need to combine it with the buildpack of the technology you are using. To achieve
that you need to setup the [Multi Buildpack](http://doc.scalingo.com/buildpacks/multi):

{% highlight bash %}
scalingo env-set BUILDPACK_URL=https://github.com/Scalingo/multi-buildpack.git
{% endhighlight %}

Then you have to write a `.buildpacks` file with the reference to this buildpack and the one
you want to use:

{% highlight bash %}
https://github.com/Scalingo/ffmpeg-buildpack.git
https://github.com/Scalingo/go-buildpack.git
{% endhighlight %}

Add this file to your git repository:

{% highlight bash %}
git add .buildpacks
git commit -m "Setup .buildpacks to install ffmpeg alongside the application on Scalingo"
{% endhighlight %}

## Deploy your application

{% highlight bash %}
git push scalingo master
{% endhighlight %}

## Check everything is working

{% highlight bash %}
$ scalingo run 'ffmpeg -version'

ffmpeg version 2.8-static http://johnvansickle.com/ffmpeg/  Copyright (c) 2000-2015 the FFmpeg developers
built with gcc 4.9.3 (Debian 4.9.3-4)
configuration: --enable-gpl --enable-version3 --disable-shared --disable-debug --enable-runtime-cpudetect --enable-libmp3lame --enable-libx264 --enable-libx265 --enable-libwebp --enable-libspeex --enable-libvorbis --enable-libvpx --enable-libfreetype --enable-fontconfig --enable-libxvid --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libtheora --enable-libvo-aacenc --enable-libvo-amrwbenc --enable-gray --enable-libopenjpeg --enable-libopus --enable-libass --enable-gnutls --enable-libvidstab --enable-libsoxr --enable-frei0r --enable-libfribidi --cc=gcc-4.9
libavutil      54. 31.100 / 54. 31.100
libavcodec     56. 60.100 / 56. 60.100
libavformat    56. 40.101 / 56. 40.101
libavdevice    56.  4.100 / 56.  4.100
libavfilter     5. 40.101 /  5. 40.101
libswscale      3.  1.101 /  3.  1.101
libswresample   1.  2.101 /  1.  2.101
libpostproc    53.  3.100 / 53.  3.100
{% endhighlight %}

You should see ffmpeg output.

> Source: [https://github.com/Scalingo/ffmpeg-buildpack](https://github.com/Scalingo/ffmpeg-buildpack)
