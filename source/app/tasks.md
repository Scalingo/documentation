---
title: Application Tasks
date: 02/10/2014
tag: app, jobs, tasks
category: app
---

# Running application tasks

## Introduction

When your app is deployed in our infrastructure, the `Procfile` of your
project is analysed and the different way to start your project are
registered and are available for scaling in your dashboard.

For various reason you may need to run other tasks in the environment of your
application (a database migration, `rails console`, etc.)

## Examples

To achieve those operations you have to use the command `run` of our
[command line tool](/cli)

### Execute `bash`

```bash
$ scalingo --app my-app run bash
[10:45] Scalingo ~ $ ls
bin  Godeps  main.go  Procfile	README.md  templates
```

### Execute `bash` with custom environment variables

```bash
$ scalingo --app my-app run --env VAR1=VAL1 --env VAR2=VAL2 bash
[10:51] Scalingo ~ $ env | grep VAR
VAR1=VAL1
VAR2=VAL2
```

### Upload an archive and extract it on the server

* Use the `--file` flag to select the files to upload

```bash
$ scalingo --app my-app run --file ./dump.tar bash
Upload /tmp/job-file635294589/dump.tar to container.
```

* Uploaded files are located in the directory `/tmp/uploads`

```bash
[10:51] Scalingo ~ $ ls /tmp/uploads
dump.tar
```

* Extract the archive to `/tmp`

```bash
[10:51] Scalingo ~ $ tar -C /tmp -xvf /tmp/uploads/dump.tar
/tmp/dump
/tmp/dump/collection1.bson
/tmp/dump/collection1.metadata.json
/tmp/dump/collection2.bson
/tmp/dump/collection2.metadata.json
/tmp/dump/system.indexes.bson
/tmp/dump/system.users.bson
/tmp/dump/system.users.metadata.json
```
