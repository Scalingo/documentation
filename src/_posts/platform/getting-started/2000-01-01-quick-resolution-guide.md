---
title: Quick Resolution Guide
modified_at: 2026-04-10 00:00:00
tags: getting-started deployment buildpack procfile ssh
index: 7
---

This guide helps you verify the basics before your first deployment on
Scalingo. If your deployment already started and failed, jump to [Deployment
Issues]({% post_url platform/app/troubleshooting/2000-01-01-deployment-issues %})
or [Boot and Startup Errors]({% post_url
platform/app/troubleshooting/2000-01-01-boot-and-startup-errors %}).

## What Scalingo Needs to Deploy Your App

Before pushing your code, make sure:

* Git is installed on your machine.
* Your SSH key is configured for your Scalingo account.
* Your application code is committed in a Git repository.
* The files used to detect your technology are present at the root of the
  repository, unless you configure `PROJECT_DIR`.

If you have not configured Git or SSH yet, start with [First Steps On
Scalingo]({% post_url platform/getting-started/2000-01-01-first-steps %}) and
[Troubleshooting SSH]({% post_url
platform/getting-started/2000-01-01-troubleshooting-ssh %}).

## How Stack Detection Works

Scalingo detects your technology from files present at the root of the
repository. If your application code lives in a subdirectory, set the
`PROJECT_DIR` environment variable so the platform inspects that directory
instead.

If your repository contains multiple technologies, Scalingo iterates over the
supported technologies alphabetically and uses the first match. If needed, you
can force a buildpack with `BUILDPACK_NAME`, or use
[multi-buildpacks]({% post_url platform/deployment/buildpacks/2000-01-01-multi %}).

## Check These Files at the Repository Root

| Technology | Detection files | Guide |
| --- | --- | --- |
| Ruby | `Gemfile` | [Ruby]({% post_url languages/ruby/2000-01-01-start %}) |
| Node.js | `package.json` | [Node.js]({% post_url languages/nodejs/2000-01-01-start %}) |
| Meteor | `.meteor/` | [Meteor]({% post_url languages/meteorjs/2000-01-01-start %}) |
| PHP | `index.php` or `composer.json` + `composer.lock` | [PHP]({% post_url languages/php/2000-01-01-start %}) |
| Python | `Pipfile`, `requirements.txt`, or `setup.py` | [Python]({% post_url languages/python/2000-01-01-start %}) |
| Java | `pom.xml` | [Java]({% post_url languages/java/2000-01-01-start %}) |
| Scala | `*.sbt`, `project/*.scala`, `.sbt/*.scala`, or `project/build.properties` | [Scala]({% post_url languages/scala/2000-01-01-start %}) |
| Groovy | `grails-app/` | [Groovy]({% post_url languages/groovy/2000-01-01-start %}) |
| Clojure | `project.clj` | [Clojure]({% post_url languages/clojure/2000-01-01-start %}) |
| Go | `*.go` at the repository root | [Go]({% post_url languages/go/2000-01-01-start %}) |
| Crystal | `shard.yml` | [Crystal]({% post_url languages/crystal/2000-01-01-start %}) |
| Elixir | `.buildpacks` declaring the Elixir buildpack | [Elixir]({% post_url languages/elixir/2000-01-01-start %}) |

## Common First-Deploy Blockers

### Missing Root Files

If Scalingo cannot detect your stack, first verify that the expected detection
files are present at the repository root.

### App in a Subdirectory {#project-in-a-subdirectory}

If the deployable code is not at the root of the repository, set
`PROJECT_DIR` to the correct subdirectory. Keep in mind that only this
directory will be present at runtime.

### SSH or Git Setup

If you cannot push your code at all, verify your local Git installation and SSH
setup first:

* [First Steps On Scalingo]({% post_url platform/getting-started/2000-01-01-first-steps %})
* [Troubleshooting SSH]({% post_url platform/getting-started/2000-01-01-troubleshooting-ssh %})

### Procfile and Process Types

Most buildpacks define a default `web` process type, but not every application
can rely on defaults. If your application needs custom start commands, worker
processes, or a `postdeploy` hook, define them in a [Procfile]({% post_url
platform/app/2000-01-01-procfile %}).

## If the Deployment Already Started and Failed

Use the troubleshooting pages depending on where the failure happens:

* [Deployment Issues]({% post_url platform/app/troubleshooting/2000-01-01-deployment-issues %}): detection, buildpack, archive, image, source layout.
* [Boot and Startup Errors]({% post_url platform/app/troubleshooting/2000-01-01-boot-and-startup-errors %}): the image is built, but the app does not start or bind to `PORT`.
* [Runtime Issues]({% post_url platform/app/troubleshooting/2000-01-01-runtime-issues %}): the app starts successfully and fails later.
