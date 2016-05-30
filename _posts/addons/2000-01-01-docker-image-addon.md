---
title: Private Beta - Scalingo Docker Image Addon
modified_at: 2016-05-30 00:00:00
category: addons
tags: docker images download feature
---

## Introduction

Thanks to this addon, you'll be able to get back the docker image we're
building when delpoying your application in our infrastructure. You
can use it to debug your production code for instance or as a pledge
of reversibility.

## Setup of the addon

Provision the add for your application from our web dashboard or with our CLI:

```bash
$ scalingo addons-add scalingo-docker-image-addon base-plan
```

## Usage of the addon

Once this is done, has been added, the deployments panel of your app dashboard
will change, a **Docker logo** will be present. Click on it to get the instructions
to download the image of a given deployment.

![Dashboard example](https://cdn.scalingo.com/documentation/docker-image-addon/dashboard-example.png)

### Login to your application registry

```bash
$ docker login registry-2.scalingo.com
Username: <scalingo username>
Password: <scalingo API key>
Email:    <scalingo email>
```

The API key is available on [your profile](https://my.scalingo.com/profile), copy it from there.


### Download your image

```bash
$ docker pull registry-2.scalingo.com/app-myappname:0123456789abcdef
0123456789abcdef: Pulling from app-myappname
6599cadaf950: Downloading 59.99 MB/65.69 MB
23eda618d451: Download complete 
f0be3084efe9: Download complete 
52de432f084b: Download complete 
a3ed95caeb02: Download complete 
b11499e07372: Download complete 
40d9c9cec188: Download complete 
b7c87d00e3ba: Downloading 31.84 MB/362.9 MB
9aac245cd453: Downloading 23.74 MB/60.04 MB
f1ac1758a0cb: Waiting 
```

### Run your app

The entrypoint of the image is a script located at `/start`. Its usage is:

```bash
/start <container type>

# Example, start the web (default) process

/start web
```

The compelete docker command to start your app on port 4000 looks like the following:

```bash
docker run -it -e PORT=4000 -p 4000:4000 registry-2.scalingo.com/app-myappname:0123456789abcdef /start web
```

In this case no environment variable has been set, you need to add the environment variables required by your
app by adding multiple '-e' flags:

```bash
docker run -it \
  -e PORT=4000 \
  -e RAILS_ENV=production \
  -e RACK_ENV=production \
  -p 4000:4000 \
  registry-2.scalingo.com/app-myappname:0123456789abcdef /start web
```

That's it, your app is running with your environment.
