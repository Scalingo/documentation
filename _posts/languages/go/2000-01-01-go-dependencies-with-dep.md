---
title: Manage Go dependencies with dep
modified_at: 2017-10-06 00:00:00
category: languages
tags: go depndencies
---

This tutorial explains how to deploy a Go application which is using `dep`
to manage its dependencies.  To handle the version management of the
dependencies, please follow [the offical dep
guide](https://github.com/golang/dep), this page will focus on the
deployment of the app.

## Configuration

During the deployment of a dep-ed application, entries in the **Gopkg.toml** files are
used to give our deployment system the data required to deploy correctly the application:

* `metadata.scalingo['root-package']` (String): the root package name of the
  packages you are pushing to Scalingo.You can find this locally with `go list -e
  .`. There is no default for this and it must be specified.
* `metadata.scalingo['go-version']` (String): the major version of go you would
  like to use when compiling your code: if not specified defaults to the
  most recent supported version of Go.
* `metadata.scalingo['install']` (Array of Strings): a list of the packages you
  want to install. If not specified, this defaults to `["."]`. Other common
  choices are: `["./cmd/..."]` (all packages and sub packages in the `cmd`
  directory) and `["./..."]` (all packages and sub packages of the current
  directory). The exact choice depends on the layout of your repository though.
  Please note that `./...`, for versions of go < 1.9, includes any packages in
  your `vendor` directory.
* `metadata.scalingo['ensure']` (String): if this is set to false then dep
  ensure is not run.
* `metadata.scalingo['additional-tools']` (Array of Strings): a list of
  additional tools that the buildpack is aware of that you want it to install.
  If the tool has multiple versions an optional `@<version>` suffix can be
  specified to select that specific version of the tool. Otherwise the
  buildpack’s default version is chosen. Currently the only supported tool is
  `github.com/mattes/migrate` at `v3.0.0` (also the default version).

Here is an example with [https://github.com/Scalingo/sample-go-martini](https://github.com/Scalingo/sample-go-martini/tree/deps-dep)

```toml
[metadata.scalingo]
  root-package = "github.com/Scalingo/sample-go-martini"
  go-version = "go1.9.1"
  install = [ "./..." ]
...
```

## Ignored vendor/ sub directories

The command `dep ensure` is run during the deployment. It means that if you
haven't checked in vendor dependencies in your GIT repository they will be
downloaded at that precise moment. Otherwise the command has no effect and your
deployment will go on.
