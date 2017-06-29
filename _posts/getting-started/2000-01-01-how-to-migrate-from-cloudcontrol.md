---
title: How to migrate from CloudControl
modified_at: 2016-02-16 11:14:00
category: getting-started
tags: cloudcontrol control cloud ror ruby rails tutorial
permalink: /how-to-migrate-from-cloudcontrol/
---

Scalingo's approach to Platform as a Service is close to CloudControl model.
Both services are based on buildpacks and Procfile. Thanks to these
similarities, the process only takes a few minute.

<blockquote class="bg-info">
  Even though we think this migration documentation is comprehensive enough,
  don't hesitate to contact our <a href="mailto:support@scalingo.com">support</a>
  to help you in the migration process.
</blockquote>

## 1. Create an account on Scalingo

Just go at [https://scalingo.com](https://scalingo.com) and follow the
instructions to get an account.

## 2. Get used to the environment

### Dashboard

Scalingo is proposing different ways communicate with its service, the more commoon
is to use the web dashboard [https://my.scalingo.com](https://my.scalingo.com). Here,
you'll be able to create and configure your applications.

### Command line tool

The command line interface (CLI) is pretty simple to install. Just go at
[http://cli.scalingo.com](http://cli.scalingo.com) and follow the instructions.
It is essentialy like installing a single binary on your system, there is no
dependency to install, it just works.

You will find its documentation at following page: [Introducing the CLI]({% post_url cli/2015-09-18-command-line-tool %}).

Everything which can be done in the web dashboard can be done with the CLI, and even
more, like accessible your databases with helper commands or running one-off jobs for
your apps.

### Advanced usage: API

If you need to get things done automatically, you can use our open API. Its
documentation can be located at
[http://developers.scalingo.com](http://developers.scalingo.com). Everything
which can be done through our web dashboard or our CLI can be done with this API
as we're also using it.

## 3. Create your applications

Clicking on '+' in the dashboard or with the CLI:

```bash
# Create an application named cloud-app
scalingo create cloud-app
```

## 4. Install required addons

Your application often need a database to run correctly. Most kind of databases
are provided directly by Scalingo as addons. As previously you can do it on the
dashboard by going in the 'Addons' tab of your application, or with our CLI:

```bash
# List all the addons available
scalingo addons-list

# List all the plans for an addon
scalingo addons-plans scalingo-postgresql

# Provision the 1GB plan of the PostgreSQL addon
scalingo addons-add -a cloud-app scalingo-postgresql 1g
```

You'll find more information about these addons at
[https://scalingo.com/addons](https://scalingo.com/addons)

If an addon does not have an equivalent on Scalingo, you can use the environment
variables of your CloudControl app, directly in your Scalingo app.

## 5. Configure your account to push your code

Before pushing your code, youd should setup your SSH key to authenticate your
GIT pushes. With the dashboard, go on the ['Keys'
page](https://my.scalingo.com/keys) and upload your public SSH key (usually
`$HOME/.ssh/id_rsa.pub`). Or obviously, you can do it with the CLI:

```bash
# Add a key named 'workstation-key' located at $HOME/.ssh/id_rsa.pub
scalingo keys-add workstation-key $HOME/.ssh/id_rsa.pub
```

## 6. Push your application

We're using the same workflow as CloudControl, so you first need to add a
remote to your git repository:

```bash
# Add Scalingo remote for 'cloud-app'
git remote add scalingo git@scalingo.com:cloud-app.git

# Push your code
git push scalingo master
```

That's it, your application will be live in a minute.

## 7. Move your data from CloudControl to Scalingo

You can find in CloudControl
[documentation](https://www.cloudcontrol.com/dev-center/add-on-documentation),
for each database addon, the way to export your data.

To import them on Scalingo, it will depend the type of database you're using.

* [Import/Export your MySQL Database]({% post_url databases/2015-10-01-dump-restore-mysql %})
* [Import/Export your PostgreSQL Database]({% post_url databases/2015-10-01-dump-restore-postgresql %})
* [Import/Export your MongoDB Database]({% post_url databases/2015-09-30-dump-restore-mongodb %})

You'll find all the pieces of information you may need in the [Databases]({%
post_url databases/2015-06-24-access-database %}) page of this documentation.

## 8. Handling the custom domain names

What is called 'alias' on cloudcontrol is named 'custom domain names' on
Scalingo. To migrate your app you've to modify the configuration of your app on
Scalingo, and also the DNS field at your domain name registrar dashboard.

```bash
# Add the 'my.cloudapp.com' domain name to you application
scalingo -a cloud-app domains-add my.cloudapp.com
```

For more informations about domains on Scalingo, take a look at our dedicated
[domain name management page]({% post_url app/2015-04-01-domain
%}#configure-your-domain-name).


## Something else specific to your app?

Don't hesitate to contact us at <a
href="mailto:support@scalingo.com">support@scalingo.com</a>
