---
title: Deploying AngularJS on Scalingo
nav: AngularJS
modified_at: 2023-02-16 00:00:00
tags: nodejs angularjs
index: 4
---

AngularJS applications can be hosted on Scalingo. It requires some specific instructions as usually the application generate static files during the deployment. And these files requires a web server to be served to your clients.

Deploying an AngularJS application requires to use the [Multi Buildpacks]({% post_url platform/deployment/buildpacks/2000-01-01-multi %}). It will be used to generate the static files using Node.js during the deployment, and run a Nginx to serve the generated files.

Create a `.buildpacks` file:

```
https://github.com/Scalingo/nodejs-buildpack
https://github.com/Scalingo/nginx-buildpack
```

Configure Nginx to serve the generated files by creating a `nginx.conf` file. The following configuration assumes that the files have been generated in the `dist` folder:

```nginx
root /app/dist;

location / {
  try_files $uri $uri/ /index.html =404;
}
```

Then instruct Scalingo how to start the application with a [`Procfile`]({% post_url platform/app/2000-01-01-procfile %}):

```yaml
web: bin/run
```

The `bin/run` script is generated during the deployment by the Nginx buildpack and starts a Nginx listening on the port defined in the `PORT` environment variable.
