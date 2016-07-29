---
title: Private Beta - Scalingo Object Storage Addon
modified_at: 2016-07-29 00:00:00
category: addons
tags: fs filesystem addon custom feature storage
---

## Introduction

This addon will provision a bucket and credentials to access a S3-like Object
Storage service hosted in our infrastructure. The solution built ontop of
*NetApp StorageGrid*.

As Use this addon to store medias uploaded by your users and **persist them
through deployments, restart and scalingo operations**. If you were using the
standard, ephemeral file system of the container, the file will only be visible
from one of the two containers and will disappear when the application is
deployed/restarted.

## Setup

When you're adding the addon from our dashboard or with our command line tool:

```bash
scalingo scalingo-object-storage 5g
```

The following environment variables will be set:

```bash
SCALINGO_STORAGE_ACCESS_KEY_ID=<access key ID>
SCALINGO_STORAGE_SECRET_ACCESS_KEY=<secret access key>
SCALINGO_STORAGE_BUCKET=<bucket name>
SCALINGO_STORAGE_ENDPOINT=<S3 endpoint>
SCALINGO_STORAGE_REGION=<S3 region>
```

Your application, if deployed, will be restart with the newly created addon.

## Import/export Data

You may want to import or export data to or from your object storage bucket, in
this case you'll need some specific tools. There is an Amazon S3 compatible API
to access the data so any tool working with S3 will work with our solution.

### The case of 's3cmd'

Install the tool from the website [http://s3tools.org/repositories](http://s3tools.org/repositories)

Create a `.s3cfg` file in your user directory with the following content:

```python
access_key = "access key id"
secret_key = "secret access key"
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
