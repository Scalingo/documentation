---
title: Deploy Directly from an Archive
modified_at: 2017-08-04 00:00:00
category: deployment
tags: source deploy
order: 1
---

A way to deploy your application on Scalingo is to use an url where your application code is upload on the format archive.

## The Workflow

If you want to deploy an application without git or github, you can put your application code in an archive `tar.gz`.

Then you need to upload your application on a source, a repo on the web where your application will be conserved. If you do not know how do that, see the section [Create a Repo for the Archive]({% post_url deployment/2017-08-04-deploy-from-archive %}create-a-repo-for-the-archive).

From your source, your repo, you must have a download_url that Scalingo can use to deploy your application.

Thus, you have to provide your download_url on the Scalingo Api (https://api.scalingo.com/v1/apps/[:app]/deployments) with a request POST, see the section [Deployment]({% post_url deployment/2017-08-04-deploy-from-archive %}#to-deploy-an-archive).

Once our platform receives your achive, the deployment begins.

## To deploy an archive

To deploy your archive, you have to make a POST request on `https://api.scalingo.com/v1/apps/[:app]/deployments`, like this:

```bash
curl -H "Accept: application/json" -H "Content-Type: application/json" -u ":$AUTH_TOKEN" \
    -X POST https://api.scalingo.com/v1/apps/[example-app]/deployments -d \
        '{
            "deployment": {
                "git_ref": "v0.0.2",
                "download_url": "https://github.com/Scalingo/sample-go-martini/archive/master.tar.gz"
            }
        }'
```

* The `auth-token` is specific for Scalingo, you can find it on your [dashboard](https://my.scalingo.com/profile) or from our API. Every information are [here](https://developers.scalingo.com/index.html#authentication).

* You have to replace `[example-app]` by your application name which must be created before. You can do that on our platform [my.scalingo.com](https://my.scalingo.com) or [from your shell](https://developers.scalingo.com/apps.html#create-an-application).

* The `git_ref` is optional. This attribute must provide any string identifying your archive.

* The `download_url` is the link where our platform can access to your archive.

##### And after?

Your application is deployed! If there is any problem, please see our page [Application crash]({% post_url app/2014-09-10-crash %}).
We strongly advise you to look at the logs of your application using the web dashboard or by using the [CLI tool](http://cli.scalingo.com).

If you do not know how create the repo to provide to our platform the download_url, see the next [section]({% post_url deployment/2017-08-04-deploy-from-archive %}create-a-repo-for-the-archive).

## Create a Repo for the Archive

It is possible to create your repo with Scalingo, that will be a source.
A source is a place from which data can be took.

### Create a Source

To create a source, you will have to make a POST request on `https://api.scalingo.com/v1/sources`.

```bash
curl -H "Accept: application/json" -H "Content-Type: application/json" -u :$AUTH_TOKEN \
  -X POST https://api.scalingo.com/v1/sources -d ''
```

The response will look like:

```json
{
  "upload_url": "https://api.scalingo.com/v1/sources/123e4567-e89b-12d3-a456-426655440000?token=dc958153c3cd32659ffad5deeda9405d",
  "download_url": "https://api.scalingo.com/v1/sources/123e4567-e89b-12d3-a456-426655440000?token=9df650a60014571abff0ee4e2d06a8fc"
}
```

The source provide two important url:

* a `upload_url`: used to upload your code on the source. 

* a `download_url`: used to recover the data from the source.

### Upload on the Source

To upload your data on the source, you have to make a 'PUT' request on the source upload_url.

```bash
curl -L -X PUT --upload-file ./archive.tar.gz '$upload_url'
```

More information [here](https://developers.scalingo.com/sources.html).

If there is some problem with the url, check that your JSON is correctly encoded.
