---
title: Deploy Directly from Source
modified_at: 2017-08-04 00:00:00
category: deployment
tags: source deploy
order: 1
---

Deploy directly from source is available on Scalingo. Indeed it is possible to deploy an archive which contains your application directly from your shell.

For that, you need an auth-token for Scalingo that you can find on your [dashbord](https://my.scalingo.com/profile) or from our API, every informations are [here](https://developers.scalingo.com/index.html#authentication).

You also need to have created an application on our platform with [my.scalingo.com](https://my.scalingo.com) or [from your shell](https://developers.scalingo.com/apps.html#create-an-application).


## Create a source

To create a source you'll have to make a POST request on `https://api.scalingo.com/v1/sources`.

```bash
curl -H "Accept: application/json" -H "Content-Type: application/json" -u :$AUTH_TOKEN \
  -X POST https://api.scalingo.com/v1/sources -d ''
```

You'll receive a respond like:

```json
{
  "upload_url": "https://api.scalingo.com/v1/sources/123e4567-e89b-12d3-a456-426655440000?token=dc958153c3cd32659ffad5deeda9405d",
  "download_url": "https://api.scalingo.com/v1/sources/123e4567-e89b-12d3-a456-426655440000?token=9df650a60014571abff0ee4e2d06a8fc"
}
```

Upload_url: used to upload your application on the source. 

Download_url: used to recover the data of your application for his deployment for example.

## Update your application

```bash
curl -L -X PUT --upload-file ./archive.tar.gz '$upload_url'
```

More information [here](https://developers.scalingo.com/sources.html).

If there is a problem with the url, see that your JSON is correctly encoding.

## Deploy your application

You'll have to make a POST request on `https://api.scalingo.com/v1/apps/[:app]/deployments`.

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

## And next?

Your application is deployed! If there is any problem, please see our page [Application crash]({% post_url app/2014-09-10-crash %}).
We stronly advise you to look at the logs of your application using the web dashboard or by using the [CLI tool](http://cli.scalingo.com).
