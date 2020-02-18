---
title: Deploy Directly from an Archive
nav: Deploy from Archive
modified_at: 2020-02-18 00:00:00
tags: source deploy archive
index: 6
---

One way to deploy your application is to directly create a deployment from a
code archive. This article explains how to use this feature using Scalingo
command line tool.

{% include info_command_line_tool.md %}

## Usage of the `deploy` Command

To deploy an application without Git or GitHub, you need to archive your
application code in a `tar.gz` archive format. The archive must contain the
source code at the root of the archive (i.e. not in a subfolder).

For example, if your archive is named `my-app.tar.gz`, its content should look
like:

```sh
$ tar -ztvf master.tar.gz
-rw-rw-r-- root/root       277 2019-12-02 18:26 README.md
-rw-rw-r-- root/root       167 2019-12-02 18:26 composer.json
-rw-rw-r-- root/root         3 2019-12-02 18:26 composer.lock
-rw-rw-r-- root/root        19 2019-12-02 18:26 index.php
```

And you can deploy it using Scalingo CLI:

```sh
$ scalingo --app my-app deploy my-app.tar.gz
-----> Deploying tarball archive: master.tar.gz
-----> Uploading archive…
       Deployment started, streaming output:
[LOG] <-- Start deployment of my-app -->
[LOG] Fetching source code
[...]
[STATUS] New status: pushing
[LOG]  Build complete, shipping your container...
[STATUS] New status: pushing →  starting
[LOG]  Waiting for your application to boot...
[LOG] <-- https://my-app.osc-fr1.scalingo.io -->
[STATUS] New status: starting →  success
```

{% note %}
Protip: If you want to create an archive from a Git repository and deploy it to
Scalingo, here is a clever one-liner:

```
$ git archive --prefix=master/ master > master.tar && \
```
```
  gzip master.tar && \
```
```
  scalingo --app my-app deploy master.tar.gz
```
{% endnote %}

### And After?

See [Deployment Environment]({% post_url platform/app/2000-01-01-environment
%}#build-environment) to configure your application and [Procfile]({% post_url
platform/app/2000-01-01-procfile %}).
