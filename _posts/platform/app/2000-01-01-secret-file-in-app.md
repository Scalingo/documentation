---
layout: page
title: Access Secret File From the Application
modified_at: 2019-12-06 16:00:00
tags: secret files
index: 100
---

## Problematic

You may need to access some files, such as a SSH key, from your application
hosted on Scalingo. Committing these files on your Git repository is not a good
security practice. This page guide you through the steps to securely share that
kind of secret files with your application.

## Access Secret File From the Application

Let's say you want the file `private.pem` to be available in your application.
You first need to set it in base64 as environment variable of your application:

```bash
scalingo --app my-app env-set SECRET_FILE=$(base64 -w 0 ./private.pem)
```

Then you need to modify the way your application starts so that it first write
the content of the environment variable `SECRET_FILE` to the disk then
effectively start the application.

Update (or add) a [`Procfile`]({% post_url platform/app/2000-01-01-procfile %})
to define the web container:

```
web: ./bin/start-app.sh
```

And create the script `bin/start-app.sh` with the following content:

```
#!/bin/bash

echo $SECRET_FILE | base64 -d > ./private.pem
# Start default script for PHP apps
$HOME/bin/run
```

Commit both files and deploy your application. Your application has now access
to your secret file in `/app/private.pem`!
