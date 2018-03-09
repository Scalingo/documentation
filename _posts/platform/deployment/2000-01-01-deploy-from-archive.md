---
title: Deploy Directly from an Archive
modified_at: 2017-09-11 00:00:00
tags: source deploy
order: 1
---

Another way to deploy your application is to directly create a deployment from
a code archive. This article explains how to use our API to achieve this operation
to update your application.

## The Workflow

1. To deploy an application without Git or GitHub, you need to archive your
   application code in a `tar.gz` archive format.
2. The archive has to be uploaded somewhere accessible in order to let the
   platform fetch the code during the deployment process. You can either upload
   it yourself directly or use the [`Sources`
   resource](https://developers.scalingo.com/sources.html) of the API.
3. From the created source, a property named `download_url` should be used in
   order to create a new [`Deployment`
   resource](https://developers.scalingo.com/deployments.html#trigger-manually-a-deployment-from-an-archive)
   for your application.

That's it the deployment is starting, once finished with success it will
replace the current containers with the new version of the code.

## Create a `Deployment` resource with API

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

* The `AUTH_TOKEN` is a token authenticating the request, you can find tokens
  on your [dashboard](https://my.scalingo.com/profile) or from our API.
  Information are available
  [here](https://developers.scalingo.com/index.html#authentication).

* Replace `[:app]` by your application name which must be created in the first
  place. You can do that on our platform
  [my.scalingo.com](https://my.scalingo.com), [with our CLI]({% post_url
  platform/cli/2000-01-01-start %}#features) or [by using directly our API
  ](https://developers.scalingo.com/apps.html#create-an-application).

* The `git_ref` is optional. This attribute must provide any string identifying
  your archive.
* The `download_url` is the link where our platform can download your archive.

## Follow the deployment process

You can see your deployment progress and output in [your
dashboard](https://my.scalingo.com), in the 'Deployments' section of your
application, or using the `deployments-follow` command of [our command line
tool](http://cli.scalingo.com).

## Create a Source for the Archive

If the code archive has to be uploaded from your workstation, you can optionally
create a `Source` resource using the API. The source let you upload temporarily
code archives to trigger deployments with them.

### Create a Source

To create a source, you will have to make a POST request on
`https://api.scalingo.com/v1/sources`.

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

The source provide two important URL:

* a `upload_url`: used to upload your code on the source.
* a `download_url`: used to download the archive from the source.

### Upload on the Source

To upload your data on the source, you have to make a PUT request on the source
`upload_url`.

```bash
curl -L -X PUT --upload-file ./archive.tar.gz 'https://api.scalingo.com/v1/sources/123e4567-e89b-12d3-a456-426655440000?token=dc958153c3cd32659ffad5deeda9405d'
```

More information [here](https://developers.scalingo.com/sources.html).
