---
modified_at: 2025-12-08 12:00:00
title: 'Scala - Buildpack updates'
github: 'https://github.com/Scalingo/scala-buildpack'
---

- Remove automatic deletion of `project/play-fork-run.sbt` files.
- Remove Ivy cache priming feature.
- Remove build directory symlinking. Modern `sbt` versions no longer require a
  stable build path for caching.
- Deprecate Scala buildpack configuration via `system.properties`.
- Deprecate `SBT_PRE_TASKS` configuration option.
- Improve `SBT_PROJECT` handling for multi-project builds.
- Improve plugin detection using `sbt about` instead of parsing
  `project/plugins.sbt` files.
- Replace `sbt-extras` with direct `sbt` launcher installation.
- Sanitize `SBT_OPTS` by removing the `-J` prefix from arguments.
- Fail builds early for `sbt` versions older than `0.13.18`.

[Full changelog](https://github.com/Scalingo/scalingo-buildpack-scala/blob/main/CHANGELOG.md)
