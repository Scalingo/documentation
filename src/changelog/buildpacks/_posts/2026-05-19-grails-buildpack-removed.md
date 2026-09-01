---
modified_at: 2026-05-19 00:00:00
title: 'Grails - Deprecation'
github: 'https://github.com/Scalingo/grails-buildpack'
---

The [grails-buildpack](https://github.com/Scalingo/grails-buildpack), used for
legacy Grails 1 and Grails 2 applications, has been deprecated and archived on
the 14th of October 2021.

Groovy applications using Gradle or Maven as their build system may still be
deployed with the [Java]({% post_url languages/java/2000-01-01-start %}) or
[Gradle]({% post_url languages/java/2000-01-01-gradle %}) buildpack.

Grails 3 and later applications can use the
[Gradle buildpack]({% post_url languages/java/2000-01-01-gradle %}), as Grails 3 
and later use Gradle as their build system.

We won't provide any support for Grails 1 and Grails 2 applications anymore.
