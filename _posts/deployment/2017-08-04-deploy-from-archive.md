---
title: Deploy Directly from an Archive
modified_at: 2017-08-04 00:00:00
category: deployment
tags: source deploy
order: 1
---

A way to deploy your application on Scalingo is to use an url where your application code is uploaded on the format archive.

## The Workflow

If you want to deploy an application without Git or GitHub, you can archive your application code in a `tar.gz` format.

Then you need to upload your application on a web server for Scalingo to be able to fetch the archive containing your application source code. More information on how to do that in the section [Create a Source for the Archive]({% post_url deployment/2017-08-04-deploy-from-archive %}#create-a-source-for-the-archive).

From your source, you must have a `download_url` that Scalingo can use to deploy your application.

You have to provide your `download_url` on the Scalingo Api (https://api.scalingo.com/v1/apps/[:app]/deployments) with a POST request, see the section [Deployment]({% post_url deployment/2017-08-04-deploy-from-archive %}#to-deploy-an-archive).

Once our platform downloads your archive, the deployment begins.

## To Deploy an Archive

To deploy your archive, you have to make a POST request on `https://api.scalingo.com/v1/apps/[:app]/deployments`:

```bash
curl -H "Accept: application/json" -H "Content-Type: application/json" -u ":$AUTH_TOKEN" \
    -X POST https://api.scalingo.com/v1/apps/[:app]/deployments -d \
        '{
            "deployment": {
                "git_ref": "v0.0.2",
                "download_url": "https://github.com/Scalingo/sample-go-martini/archive/master.tar.gz"
            }
        }'
```

* The `auth-token` is specific for Scalingo, you can find it on your [dashboard](https://my.scalingo.com/profile) or from our API. Every information are [here](https://developers.scalingo.com/index.html#authentication).

* You have to replace `[:app]` by your application name which must be created in the first place. You can do that on our platform [my.scalingo.com](https://my.scalingo.com), [with our CLI]({% post_url cli/2015-09-18-command-line-tool %}#features) or [with a curl](https://developers.scalingo.com/apps.html#create-an-application).

* The `git_ref` is optional. This attribute must provide any string identifying your archive.

* The `download_url` is the link where our platform can download your archive.

##### And after?

Your application is deployed! If there is any problem, please see our page [Application crash]({% post_url app/2014-09-10-crash %}).
We strongly advise you to look at the logs of your application using the web dashboard or by using the [CLI tool](http://cli.scalingo.com).

If you do not know how create the source to provide to our platform the download_url, see the next [section]({% post_url deployment/2017-08-04-deploy-from-archive %}#create-a-source-for-the-archive).

## Create a Source for the Archive

It is possible to create your source with Scalingo.
A source is a place from which data can be uploaded and downloaded.

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

* a `download_url`: used to download the archive from the source.

### Upload on the Source

To upload your data on the source, you have to make a PUT request on the source `upload_url`.

```bash
curl -L -X PUT --upload-file ./archive.tar.gz 'https://api.scalingo.com/v1/sources/123e4567-e89b-12d3-a456-426655440000?token=dc958153c3cd32659ffad5deeda9405d'
```

More information [here](https://developers.scalingo.com/sources.html).

If there is some problem with the url, check that your JSON is correctly encoded.
