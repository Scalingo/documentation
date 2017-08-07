---
title: Deploy Directly from Source
modified_at: 2017-08-04 00:00:00
category: deployment
tags: source deploy
order: 1
---

Deploy directly from source is available on Scalingo. Indeed it is possible to deploy an archive which contains your application directly from your shell.

Before using this type of deployment, you need an auth-token for Scalingo that you can find on your [dashboard](https://my.scalingo.com/profile) or from our API. Every information are [here](https://developers.scalingo.com/index.html#authentication).

You also need to have created an application on our platform with [my.scalingo.com](https://my.scalingo.com) or [from your shell](https://developers.scalingo.com/apps.html#create-an-application).

## The Workflow

The first step of your deployment is to archive your application code in the format `tar.gz`.

After that, you have to push your code on a `source` provide by Scalingo (see the section Create a Source) with an `upload_url` (which is explain in the section Update your Application).

The application is now able to be deploy thanks to the `download_url` (see the section Deploy your application).


## Create a Source

To create a source you will have to make a POST request on `https://api.scalingo.com/v1/sources`.

```bash
curl -H "Accept: application/json" -H "Content-Type: application/json" -u :$AUTH_TOKEN \
  -X POST https://api.scalingo.com/v1/sources -d ''
```

The respond will look like:

```json
{
  "upload_url": "https://api.scalingo.com/v1/sources/123e4567-e89b-12d3-a456-426655440000?token=dc958153c3cd32659ffad5deeda9405d",
  "download_url": "https://api.scalingo.com/v1/sources/123e4567-e89b-12d3-a456-426655440000?token=9df650a60014571abff0ee4e2d06a8fc"
}
```

`upload_url`: used to upload your application on the source. 

`download_url`: used to recover the data of your application for his deployment.

## Update your Application

```bash
curl -L -X PUT --upload-file ./archive.tar.gz '$upload_url'
```

More information [HERE](https://developers.scalingo.com/sources.html).

If there is a problem with the url, check that your JSON is correctly encoded.

## Deploy your Application

You will have to make a POST request on `https://api.scalingo.com/v1/apps/[:app]/deployments`.

<blockquote>
  The <code class="highlighter-rouge">git_ref</code> is optional. You can use this attribute to provide any string identifying your archive.
</blockquote>

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

## And Next?

Your application is deployed! If there is any problem, please see our page [Application crash]({% post_url app/2014-09-10-crash %}).
We strongly advise you to look at the logs of your application using the web dashboard or by using the [CLI tool](http://cli.scalingo.com).
