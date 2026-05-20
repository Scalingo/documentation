---
modified_at: 2026-05-19 00:00:00
title: 'Grails - Deprecation'
github: 'https://github.com/Scalingo/grails-buildpack'
---

The [grails-buildpack](https://github.com/Scalingo/grails-buildpack), used for
legacy Grails 1 and Grails 2 applications, has been deprecated and archived on
the 14th of October 2021.

Groovy applications using a
standard Maven or Gradle JVM project structure may still be deployed with the
Java or Gradle buildpack.

Grails 3 and later applications can use the
[Gradle buildpack]({% post_url languages/java/2000-01-01-gradle %}), as Grails
3 and later use Gradle as their packaging mechanism.

We won't provide any support for Grails 1 and Grails 2 applications anymore.
