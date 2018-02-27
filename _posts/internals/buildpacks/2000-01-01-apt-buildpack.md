---
title: APT Buildpack
modified_at: 2018-02-23 00:00:00
categories: internals
tags: buildpacks build apt dependencies
---

## Purpose of this buildpack

The environment used to build and run applications, based on Ubuntu, is
embedding a wide set of libraries and binaries. However it is possible that
your application requires one or multiple dependencies which are not present by
default. The [APT buildpack](https://github.com/Scalingo/apt-buildpack) aims at
installing additional packages using the `apt` package manager.

Details about the default environment can be found on the following page:
[Scalingo Builder - Our base Docker image]({% post_url
internals/2000-01-01-scalingo-builder-base-docker-image %})

## Set up this buildpack for your application

This buildpack is designed to be used in conjunction with one or more additional
buildpacks, thanks to the [multi buildpack]({% post_url internals/buildpacks/2015-09-28-multi-buildpack %})

When creating a new Scalingo app:

```console
$ scalingo create <appname>
$ scalingo env-set BUILDPACK_URL=https://github.com/Scalingo/multi-buildpack.git

$ cat << EOF > .buildpacks
https://github.com/Scalingo/apt-buildpack.git
https://github.com/Scalingo/ruby-buildpack.git
EOF
```

The above commands configure your application to use the multi buildpack, and
defines the `.buildpacks` file, defining the different buildpacks to apply, in this
example, the APT buildpack, and the Ruby builidpack.

## Configuration

Once the buildpack is configured for your app, the packages to install have to be defined in a file named 
`Aptfile` which should be located at the root of the application.

It can contain three types of information:

* A package name present in the Ubuntu repository
* An URL to a `.deb` package which will be downloaded and installed
* A `:repo:deb` instruction to add a APT repository to download packages from

Example:

```
popplers-utils
http://downloads.sourceforge.net/project/wkhtmltopdf/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb
:repo:deb http://cz.archive.ubuntu.com/ubuntu artful main universe
```

## Output

At the next deployment, the APT buildpack should be doing its job (example with `popplers-utils` package):

```
=====> Downloading Buildpack: https://github.com/Scalingo/apt-buildpack
=====> Detected Framework: Apt
-----> Reusing cache
-----> Updating apt caches
       Ign http://archive.ubuntu.com trusty InRelease
       ...
       Hit http://apt.postgresql.org trusty-pgdg/main amd64 Packages
       Reading package lists...
-----> Fetching .debs for poppler-utils
       Reading package lists...
       Building dependency tree...
       The following extra packages will be installed:
         libpoppler44
       The following NEW packages will be installed:
         libpoppler44 poppler-utils
       0 upgraded, 2 newly installed, 0 to remove and 73 not upgraded.
       Need to get 0 B/824 kB of archives.
       After this operation, 3066 kB of additional disk space will be used.
       Download complete and in download only mode
-----> Installing libpoppler44_0.24.5-2ubuntu4.9_amd64.deb
-----> Installing poppler-utils_0.24.5-2ubuntu4.9_amd64.deb
-----> Writing profile script
-----> Rewrite package-config files
```
