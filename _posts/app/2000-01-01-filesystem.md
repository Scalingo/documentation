---
title: File system and file storage
modified_at: 2017-01-03 00:00:00
category: management
tags: app runtime file system disk storage
order: 4
---

## Introduction

Applications often need to store files, users uploads or simply runtime
temporary files for instance. The file system located on the disk alongside your app on the
platform is temporary, it means that each time your application is restarted or
redeployed, it gets a new file system, files stored previously on it won't be
present anymore.

## Where you can write temporary files

Two directories are writable by your application:

* The application directory `/app` where it can read and write as wished (eg. Ruby on Rails
  storing upload in the `tmp` directory inside the project, so it will write in `/app/tmp`)

* The global temporary directory `/tmp`.

So in both these directories you can store temporary files, but keep in mind they
will be lost when the app will be restarted.

## Good practices

### External storage service

If you need to store files in a persistant manner, the good practice is to use
an external storage service solution like:

* Amazon S3
* Google Cloud Storage
* Azure Blob Storage
* OVH Public Cloud Storage

Then the workflow, already implemented in numerous frameworks and libraries is the
following:

1. Client upload file to application
2. File is stored temporarily in the app file system
3. Application send the temp file to the storage service
4. Display URL to the remote file to the client in the rendered HTML/JSON

### Large size upload

You may need to upload large files (≥ 50MB for instance), in this case the workflow
previously explained won't work so well because each step will be slow, because of
network transfers.

All the previous third-party providers offer a mecanisme of Signed URL, it let your
app generates a temporary authenticated URL your users can use to upload a file. With
this system, no file needs to uploaded through the platform infrastructure, it will
be directly uploaded to the storage service which is much more efficient.

The workflow becomes:

1. The client asks to upload a file to the app
2. The application generates a signed URL for this client and returns it
3. The client uses this URL to upload its file directly
4. Once done, the client notifies the application the file has been uploaded

As a result, no file operation alongside your app, you delegate everything to the storage
provider.
