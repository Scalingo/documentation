---
title: How to migrate from Heroku
modified_at: 2015-10-14 17:21:00
tags: heroku tutorial
index: 11
---

Scalingo is a Platform as a Service [highly compatible with Heroku]({% post_url platform/getting-started/2000-01-01-heroku-compatibility %}). This page is here to help your migrate from Heroku to Scalingo as easily as possible.

## Requirements

To be able to follow this tutorial, we assume that you have:

- A Scalingo account
- The Scalingo [CLI]({% post_url platform/cli/2000-01-01-start %}) installed
- A local copy of the repository containing your app’s code

Please ensure you are running all commands above from the root of the repository containing your app’s code. 

```bash
$ cd <app directory>
```

Note: All operations described below can also be done through our web dashboard (instead of the command line tool). 

## Migration Steps

### Creating your Scalingo app

- Start by logging in to the Scalingo platform using our `cli` :

```bash
$ scalingo login
```

- You can now create your app:

```bash
# Replace my-app by your actual app name
$ scalingo create my-app
```

### Configure Environment Variables

- First retrieve the environment variables from your current Heroku app context:

```bash
$ heroku config
```

- Those environment variables need to be declared in your Scalingo app context. For instance, this command will set the `NODE_ENV` environment variable:  

```bash
$ scalingo --app my-app env-set NODE_ENV=production
```

More information about environnement variables can be found in the [dedicated documentation page]({% post_url platform/app/2000-01-01-environment %}).

### Deploying Your App

- You are now ready to deploy your app on Scalingo:

```bash
$ git push scalingo master
```

### Database Migration

- Once you have set your Scalingo addons according to those you had on Heroku, you need to migrate your database by dumping it from Heroku and restoring it to Scalingo. 
  * [Dump and restore a MongoDB database]({% post_url databases/mongodb/2000-01-01-dump-restore %})
  * [Dump and restore a PostgreSQL database]({% post_url databases/postgresql/2000-01-01-dump-restore %})
  * [Dump and restore a MySQL database]({% post_url databases/mysql/2000-01-01-dump-restore %})

### Where to Go Next?

- If your app is using a custom domain, follow the [instructions]({% post_url platform/app/2000-01-01-domain %}) to update your DNS configuration.
- Managing your [SSL certificate]({% post_url platform/app/2000-01-01-ssl %}).  

### Need Some Help? 

Have questions or need to report an issue? Feel free to reach our support team for further assistance through our live chat or by sending an email to [support@scalingo.com](mailto:support@scalingo.com).

