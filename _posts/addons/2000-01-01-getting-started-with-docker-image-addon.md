---
title: Getting started with Docker Image Addon
modified_at: 2016-06-10 00:00:00
category: addons
tags: docker images download feature
---

Here our goal will be to build our sample todo list application built using Meteor on Scalingo and running it locally.

## Requirements
Before doing this tutorial you should have setup your environment:

  * [Install `scalingo` Command Line Interface](http://localhost:4000/app/command-line-tool.html)
  * [Install docker](https://docs.docker.com/engine/installation/)

## Introduction

The first step is to build your app on Scalingo. You should have a working application on scalingo. Here we will use our [meteor todo list example](https://github.com/Scalingo/sample-meteor-todo).

To deploy it on scalingo just [click here](https://my.scalingo.com/deploy?source=https://github.com/johnsudaar/sample-meteor-todo)

Your application do not need to be running you can set your containers to 0.

```bash
$ scalingo -a my-app scale web:0
```

## Get your docker image


### Add the docker-image-addon

To get the docker image you must add the `scalingo-docker-image-addon`.

```bash
$ scalingo -a my-app addons-add scalingo-docker-image-addon base-plan
```

Once this is done, the deployments panel of your app dashboard
will change, a **Docker logo** will be present. Click on it to get the instructions
to download the image of a given deployment.

{% assign img_url = "https://cdn.scalingo.com/documentation/docker-image-addon/dashboard-example.png" %}
{% include mdl_img.html %}

### Login to your application registry

```bash
$ docker login registry.scalingo.com
Username: <scalingo username>
Password: <scalingo API key>
Email:    <scalingo email>
```
The API key is available on [your profile](https://my.scalingo.com/profile), copy it from there.

### Download your image

The pull link is available on the deployment panel of your dashboard by clicking on the **Docker logo**.

```bash
$ docker pull registry.scalingo.com/myapp:da03fc67e7c52d6
```

## Get your database image

If you are using a database with your application you must download it from the docker hub.

To do so you will need to get your database version from your database dashboard. In the `Docker Image Version` field.
![database informations](/assets/images/database/database-addon.png)

In our case we are using Mongodb on version `3.2.6-2`. To download our image you can use the docker official repository:

```bash
docker pull scalingo/<database-type>:<databse-version>
```

For this app:

```bash
docker pull scalingo/mongo:3.2.6-2
```

## Launch your application

Once you've donloaded all the needed images, you must run them on your system.

### Run the database image

To run pour database image you need to have a folder which will be used to store your database data. Here we will be using `/mount/db/mongo/my-app`.

To launch the DB image type:

```bash
docke run --name=<container-name> -v /mount/db/mongo/my-app:/var/lib/<database-version> scalingo/<database-type>:<database-version> /mongo <user> <password> <admin_password>
```

The `user` and `password` can be set to anything. Just keep them for the next step.
The `container-name` is a name that will be used for your database container.
If you are nunning mongodb you must pass the `MONGO_WIRED_TIGER_CACHE_SIZE_MB` environment variable.

In our case:

```bash
docke run -d --name=mongo_my-app \
    -e MONGO_WIRED_TIGER_CACHE_SIZE_MB=250 \
    -v /mount/db/mongo/my-app:/var/lib/mongodb \
    scalingo/mongo:3.2.6-2 /mongo my-app password password
```

### Run the application image

To run the application image you must:
  * Link it with the database image
  * Set the needed environment variables
  * Expose the listening port

The general command is:

```bash
$ scalingo run \
  -e MY_ENVIRONMENT_VARIBLE=SOME_VALUE \
  -p EXPOSED_PORT:EXPOSED_PORT
  --link MY_DATABASE_CONTAINER:NAME
  registry.scalingo.com/<image_name> /start ENVIRONMENT
```

In this example we need to set the `PORT` environment variable to 4000 and expose this port to our host computer.

Since it's a meteor application, we need to set the `ROOT_URL` environment variable to `http://localhost:4000`

```bash
$ scalingo run \
  -e PORT=4000 \
  -e ROOT_URL=http://localhost:4000 \
  -e MONGO_URL=mongo://my-app:password@mongo/my-app \
  -p 4000:4000 \
  --link mongo_my-app:mongo \
  registry.scalingo.commyapp:da03fc67e7c52d6/ /start web
```
