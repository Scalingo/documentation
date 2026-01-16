---
title: How to migrate from Heroku
modified_at: 2026-01-02 12:00:00
tags: heroku tutorial
index: 11
---

Scalingo is a Platform as a Service [highly compatible with Heroku]({% post_url platform/getting-started/2000-01-01-heroku-compatibility %}). This page is here to help you migrate from Heroku to Scalingo as easily as possible.

## Requirements

To be able to follow this tutorial, we assume that you have:

- [A Scalingo account](https://auth.scalingo.com/users/sign_up)
- The Scalingo [CLI]({% post_url tools/cli/2000-01-01-start %}) installed
- A local copy of the repository containing your app’s code ([How can I download my code from Heroku?](https://help.heroku.com/FZDDCBLB/how-can-i-download-my-code-from-heroku))

Please ensure you are running all commands above from the root of the repository containing your app’s code. 

```bash
$ cd <app directory>
```

All operations described below can also be executed through [our dashboard](https://dashboard.scalingo.com).

## Migration Steps

### Creating your Scalingo app

- Start by logging in to the Scalingo platform using our CLI:

```bash
$ scalingo login
```

- You can now create your app:

```bash
# Replace my-app with your actual app name
$ scalingo create my-app
```

### Configure Environment Variables

- First, retrieve the environment variables from your current Heroku app context:

```bash
$ heroku config
```

- Those environment variables need to be declared in your Scalingo app context. For instance, this command will set the `NODE_ENV` environment variable:  

```bash
$ scalingo --app my-app env-set NODE_ENV=production
```

More information about environment variables can be found in the [dedicated documentation page]({% post_url platform/app/2000-01-01-environment %}).

### Deploying Your App

- You are now ready to deploy your app on Scalingo:

```bash
$ git push scalingo master
```

### Database Migration

- Once you have set your Scalingo addons according to those you had on Heroku, you need to migrate your database by dumping it from Heroku and restoring it to Scalingo. 
  * [Dump and restore a Scalingo for MongoDB® database]({% post_url databases/mongodb/2000-01-01-dump-restore %})
  * [Dump]({% post_url databases/postgresql/guides/2000-01-01-backing-up %}#dumping-the-database)
    and [restore]({% post_url databases/postgresql/guides/2000-01-01-restoring %}#restoring-a-dump)
    a Scalingo for PostgreSQL® database
  * [Dump]({% post_url databases/mysql/guides/2000-01-01-backing-up %}#dumping-the-database)
    and [restore]({% post_url databases/mysql/guides/2000-01-01-restoring %}#restoring-a-dump)
    a Scalingo for MySQL® database.

### Where to Go Next?

- If your app is using a custom domain, follow the [instructions]({% post_url platform/networking/public/domains/2000-01-01-custom %}) to update your DNS configuration.
- Managing your [SSL certificate]({% post_url platform/networking/public/cert/2000-01-01-overview %}).

### Need Some Help? 

Have questions or need to report an issue? Feel free to reach our support team for further assistance through our live chat or by sending an email to [support@scalingo.com](mailto:support@scalingo.com).

