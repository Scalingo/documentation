---
title: Private Beta - Scalingo Shared Filesystem Addon
modified_at: 2016-02-03 00:00:00
category: addons
tags: fs filesystem addon custom feature storage
---

## Introduction

This addon will add a common storage directory in all the containers of your
application which will be synchronized in real time.

For instance if you're running multiple containers and one of your users upload
a picture, if you're using the standard, ephemeral file system of the container,
the file will only be visible from one of the two containers and will disappear
when the application is deployed/restarted.

In the case the file is stored on this shared storage facility. It will be visible
from all the containers and persistant between deployments or any application
operation.

{% note %}Please keep it mind that using a shared file system
is still one step longer than using an external storage service directly as the
file has to be downloaded first in your container and then send to the user
browser.{% endnote %}

The addon is backed by a S3-like storage facility and is using the
[s3fs](https://github.com/s3fs-fuse/s3fs-fuse) to mount a bucket in your
containers. Thus, accessing your file corresponds to make HTTP calls to the
storage facility, creating some overhead compared to direct file access.

## Setup

When you're adding the addon from our dashboard or with our command line tool:

```bash
scalingo scalingo-shared-filesystem 5g
```

The following environment variable will be set:

```bash
SCALINGO_SHAREDFS_CREDENTIALS='<credentials>'
```

Your application, if deployed, will be restart with the newly created addon.

## Access data in the containers

By default, the shared directory will be located at the path `/storage` of your
container. So ensure, by configuring your application, that you'll read and
write data from there. 

If for some reason your want the directory to be available at other places, you
can define the following environment variable `SCALINGO_SHAREDFS_SYMLINKS`.
This variable should contain a `:` separated list of relative paths. Theses
paths are relative to the root of your application. Example:

```bash
# Rails app
SCALINGO_SHAREDFS_SYMLINKS=public/system

# Wordpress app
SCALINGO_SHAREDFS_SYMLINKS=wp-content/uploads
```

## Import/export Data

You may want to import or export data to or from your shared filesystem
directory, in this case you'll need some specific tools. There is an Amazon S3
compatible API to access the data so any tool working with S3 will work with
our solution.

### Decomposition of SCALINGO_SHAREDFS_CREDENTIALS

The variable has the following format: `access key id:secret key:bucket name`

### The case of 's3cmd'

Install the tool from the website [http://s3tools.org/repositories](http://s3tools.org/repositories)

Create a `.s3cfg` file in your user directory with the following content:

```python
access_key = "access key id"
secret_key = "secret token"
bucket_location = generic
host_base = s3.myagora.fr
host_bucket = s3.myagora.fr/%(bucket)
signature_v2 = True
use_https = True
```

### Example of usage

```bash
# List all the files of your bucket
s3cmd ls s3://bucket-name

# Download a file from the bucket
s3cmd get s3://bucket-name/filename.png

# Upload a file to the bucket
s3cmd put ./document.pdf s3://bucket-name

# Access help to get list of commands
s3cmd --help
```
