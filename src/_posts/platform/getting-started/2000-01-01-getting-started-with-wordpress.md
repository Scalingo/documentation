---
title: Getting Started with WordPress on Scalingo
modified_at: 2025-04-01 17:00:00
tags: php, http, framework, wordpress, deployment
index: 14
---

WordPress is a popular open-source web content management system (CMS) used for
building and managing websites. Initially released as a blogging platform, it
has since evolved into a versatile tool supporting a wide range of web
applications, such as e-commerce, portfolios, forums, and more. It's well-known
for its ease of use and extensive themes and plugins ecosystem.


## Planning your Deployment

{% note %}
**WordPress is not well suited to be directly deployed on Scalingo**. This is
mainly due to the fact that WordPress developers do not follow modern best
practices for cloud deployments, such as **[12 factor](https://12factor.net)**.\
\
Hopefully, the [Roots](https://roots.io/about/) team has created
**[Bedrock](https://roots.io/bedrock/)**, a modern WordPress boilerplate that
greatly improves WordPress development by leveraging [Composer to manage
dependencies]({% post_url languages/php/2000-01-01-dependencies %}), providing
a better folder structure, facilitating environment-specific configurations,
improving security and offering better Git integration.\
Basically everything we love at Scalingo!
{% endnote %}

- For all the reasons presented above, we will use Bedrock.
- WordPress is written in PHP. We will use the PHP buildpack along with an
  Nginx web server.
- It requires a MySQL® database to store all the website content as well as
  parts of its configuration. Chosing the appropriate plan mostly depends on
  the traffic your WordPress has to handle. We usually advise to start with a
  [MySQL® for Scalingo Starter/Business 512 addon](https://scalingo.com/databases/mysql)
  and upscale later if need be.
- Since relying on the local filesystem to store data is not allowed on
  Scalingo, we will use an S3-compatible object storage solution. Our Bedrock
  distribution fully supports it, thanks to the [`humanmade/s3-uploads`](https://github.com/humanmade/S3-Uploads)
  embedded. In the following guide, we will use an AWS S3 bucket but any
  S3-compatible solution should be OK.


## Deploying

### Using our One-Click Deploy Button

Click the One-Click Deploy button below to automatically deploy WordPress with
you Scalingo account:

[![Deploy](https://cdn.scalingo.com/deploy/button.svg)](https://dashboard.scalingo.com/deploy?source=https://github.com/Scalingo/wordpress-scalingo)

### Using the Command Line

We maintain a repository called [wordpress-scalingo](https://github.com/Scalingo/wordpress-scalingo)
on GitHub to help you deploy WordPress on Scalingo. Here are the few steps you
will need to follow:

1. Clone our repository:

   ```bash
   git clone https://github.com/Scalingo/wordpress-scalingo
   cd wordpress-scalingo
   ```

2. Create the application on Scalingo:

   ```bash
   scalingo create my-wordpress
   ```

   Notice that our Command Line automatically detects the git repository, and
   adds a git remote to Scalingo:

   ```bash
   git remote -v

   origin   https://github.com/Scalingo/wordpress-scalingo (fetch)
   origin   https://github.com/Scalingo/wordpress-scalingo (push)
   scalingo git@ssh.osc-fr1.scalingo.com:my-wordpress.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:my-wordpress.git (push)
   ```

3. Attach a MySQL® by Scalingo addon to the application:
   ```bash
   scalingo --app my-wordpress addons-add mysql mysql-starter-512
   ```

4. Add a few mandatory environment variables, either via the Dashboard or via
   [the Scalingo command line tool]({% post_url platform/cli/2000-01-01-features %}#configure-their-environment):

   | Env Variable       | Description |
   | ------------------ | ----------- |
   | `WP_HOME`          | Full URL to Wordpress home.<br />i.e. `https://my-app.osc-fr1.scalingo.io`                           |
   | `WP_SITEURL`       | Full URL to Wordpress, including the subdirectory.<br />i.e. `https://my-app.osc-fr1.scalingo.io/wp` |
   | `WP_ENV`           | Environment. See [`WP_ENV`](#environment) below. |

5. Generate and add a few security keys and salts, also as environment
   variables. These are random strings of characters that are used to enhance
   the security of WordPress, for example, by encrypting some data.

   They can be generated via [Roots WordPress Salts Generator](https://roots.io/salts.html),
   and must be added as environment variable, either via the Dashboard or via
   the [Scalingo command line tool]({% post_url platform/cli/2000-01-01-features %}#configure-their-environment):

   - `AUTH_KEY`, `SECURE_AUTH_KEY`, `LOGGED_IN_KEY`, `NONCE_KEY`
   - `AUTH_SALT`, `SECURE_AUTH_SALT`, `LOGGED_IN_SALT`, `NONCE_SALT`

6. Setup the S3 bucket:

   {% note %}
   The following instructions describe the process for an AWS S3 bucket. Please
   refer to your provider's documentation to setup your S3 storage.
   {% endnote %}

   1. Create a **public** S3 bucket with **ACL disabled**, and with the
      following policy:

      ```json
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::BUCKETNAME-HERE/*"
          }
        ]
      }
      ```

   2. Configure the IAM user with the following policy:

      ```json
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Action": [
              "s3:PutObject",
              "s3:PutObjectAcl",
              "s3:PutObjectVersionAcl",
              "s3:AbortMultipartUpload",
              "s3:ListBucket",
              "s3:DeleteObject",
              "s3:GetObject"
            ],
            "Effect": "Allow",
            "Resource": [
              "arn:aws:s3:::BUCKETNAME-HERE",
              "arn:aws:s3:::BUCKETNAME-HERE/*"
            ]
          }
        ]
      }
      ```

   If you want to use another provider than AWS (OVH, Scaleway, etc.), you can setup the IAM according your bucket and add the env variable `S3_UPLOADS_ENDPOINT` with the url of the provider. 

7. (optional) Instruct the platform to run the `web` process type in a single
   XL container:

   ```bash
   scalingo --app my-wordpress scale web:1:XL
   ```

8. Everything's ready, deploy to Scalingo:

   ```bash
   git push scalingo master
   ```

   During the deployment process, you should see the following output
   mentioning that the framework has correctly been detected:

   ```text
   -----> Detected Bedrock WordPress
   -----> Setting up Bedrock WordPress
   ...
   ```

   Once your WordPress instance is up and running, you can access the admin
   page at `https://my-wordpress.osc-fr1.scalingo.io/wp/wp-admin`.

### Using the Terraform Provider

{% note %}
The following code blocks are given as examples.\
You will have to adjust some values to suit your needs.
{% endnote %}

1. Start by forking our [WordPress/Bedrock repository](https://github.com/Scalingo/wordpress-scalingo)

2. Place the following block in your Terraform file to create the app. You can
   use [Roots WordPress Salts Generator](https://roots.io/salts.html) to
   generate the security keys and salts:

   ```terraform
   resource "scalingo_app" "my-wordpress" {
     name        = "my-wordpress"
     stack_id    = "scalingo-22"
     force_https = true

     environment = {
       WP_HOME          = "https://my-wordpress.osc-fr1.scalingo.io",
       WP_SITEURL       = "https://my-wordpress.osc-fr1.scalingo.io/wp",
       WP_ENV           = "development",
       AUTH_KEY         = "",
       SECURE_AUTH_KEY  = "",
       LOGGED_IN_KEY    = "",
       NONCE_KEY        = "",
       AUTH_SALT        = "",
       SECURE_AUTH_SALT = "",
       LOGGED_IN_SALT   = "",
       NONCE_SALT       = ""
     }
   }
   ```

3. Link the app to your forked repository:

   ```terraform
   data "scalingo_scm_integration" "github" {
     scm_type = "github"
   }

   resource "scalingo_scm_repo_link" "default" {
     auth_integration_uuid = data.scalingo_scm_integration.github.id
     app                   = scalingo_app.my-wordpress.id
     source                = "https://github.com/<username>/wordpress-scalingo"
     branch                = "master"
   }
   ```

4. Create a Starter-512 MySQL® addon and attach it to your app:

   ```terraform
   resource "scalingo_addon" "my-wordpress-db" {
     app         = scalingo_app.my-wordpress.id
     provider_id = "mysql"
     plan        = "mysql-starter-512"
   }
   ```

5. [Follow steps 6, 7 and 8 described previously](#using-the-command-line) to
   respectively setup your S3 object storage, to add your themes and your
   plugins. If you setup an S3 object storage, don't forget to add the
   corresponding environment variables to your `scalingo_app` resource:

   ```terraform
   resource "scalingo_app" "my-wordpress" {
     [...]
     environment = {
       [...]
       S3_UPLOADS_BUCKET     = "",
       S3_UPLOADS_KEY        = "",
       S3_UPLOADS_SECRET     = "",
       S3_UPLOADS_REGION     = "",
       S3_UPLOADS_OBJECT_ACL = "public-read"
     }
   }
   ```

6. (optional) Instruct the platform to run the `web` process type in a single
   XL container:

   ```terraform
   resource "scalingo_container_type" "web" {
     app    = scalingo_app.my-wordpress.id
     name   = "web"
     size   = "XL"
     amount = 1
   }
   ```

7. Run `terraform plan` and check if the result looks good
8. If so, run `terraform apply`
9. Once Terraform is done, your WordPress instance is ready to be deployed:
   1. Head to [your dashboard](https://dashboard.scalingo.com/apps/)
   2. Click on your WordPress application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button
   6. After a few seconds, your WordPress instance is finally up and running!


## Updating

Scalingo automatically deploys the latest version of Bedrock we have tested.

Consequently, updating WordPress only consists of triggering a new deployment
of your WordPress instance.

{% note %}
- Scalingo **does not** provide any guarantee in terms of availability after
  each Bedrock release. We do our best to keep our repository up-to-date, but
  can't guarantee it.
- Please feel free to get in touch with our support team, should you need a
  specific version.
{% endnote %}

### Using the Command Line

1. In your WordPress repository, create an empty commit and push it to Scalingo:

   ```bash
   git commit --allow-empty -m "Update WordPress"
   git push scalingo master
   ```

### Using the Terraform Provider

1. Head to [your dashboard](https://dashboard.scalingo.com/apps/)
2. Click on your WordPress application
3. Click on the **Deploy** tab
4. Click on **Manual deployment** in the left menu
5. Click the **Trigger deployment** button
6. After a few seconds, your updated WordPress instance is ready!


## Customizing

### Installing Plugins

1. Add plugins using [Composer](https://getcomposer.org) or
   [WordPress Packagist](https://wpackagist.org/search?q=&type=plugin&search=):

   ```bash
   composer require --ignore-platform-reqs wpackagist-plugin/akismet
   ```

2. Don't forget to commit your changes:

   ```bash
   git add composer.json composer.lock
   git commit -m "Add plugins"
   ```

   The last steps depend on the method chosen to deploy your WordPress
   instance (see below).

#### Using the Command Line

1. Make sure you have followed [the first steps](#installing-plugins)

2. From your WordPress repository, trigger a new deployment:

   ```bash
   git push scalingo master
   ```

#### Using the Terraform Provider

1. Make sure you have followed [the first steps](#installing-plugins)

2. Push your changes to the repository linked to your app:

   ```bash
   git push origin master
   ```

3. Trigger a new deployment:

   1. Head to [your dashboard](https://dashboard.scalingo.com/apps/)
   2. Click on your Metabase application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button

### Installing Themes

1. Put your theme(s) in the `web/app/themes` directory of your WordPress
   repository.

2. Don't forget to commit your changes:

   ```bash
   git add web/app/themes
   git commit -m "Add themes"
   ```

   The last steps depend on the method chosen to deploy your WordPress
   instance (see below).

#### Using the Command Line

1. Make sure you have followed [the first steps](#installing-themes)

2. From your WordPress repository, trigger a new deployment:

   ```bash
   git push scalingo master
   ```

#### Using the Terraform Provider

1. Make sure you have followed [the first steps](#installing-themes)

2. Push your changes to the repository linked to your app:

   ```bash
   git push origin master
   ```

3. Trigger a new deployment:

   1. Head to [your dashboard](https://dashboard.scalingo.com/apps/)
   2. Click on your Metabase application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button

### Environment

Bedrock supports some environment variables. Here are a few ones that are
mandatory or worth considering:

- **`WP_HOME`**\
  MUST be set to the base URL of your WordPress application.\
  Defaults to being unset.

- **`WP_SITEURL`**\
  MUST be set to the home URL of your WordPress instance (i.e. including the
  path to WordPress).\
  Defaults to being unset.

- **`WP_ENV`**\
  Allows to automatically enable or disable some settings (such as the log
  level, debugging, ...) depending on the value provided.\
  Out of the box, can be either `development`, `staging` or `production`.\
  We advise to start setting it to `staging` or `development` and switch to
  `production` only once the S3 storage is successfully configured.\
  You can define your own custom environment and settings by creating a new one
  in `config/environments/<custom_environment_name>.php`.\
  Defaults to `production`.

- **`DISABLE_WP_CRON`**\
  Allows to disable WordPress' jobs scheduler.\
  Can be set to either `true` to disable WordPress cron or `false` to enable
  it.\
  Defaults to `false`.

- **`WP_POST_REVISIONS`**\
  Allows to limit the number of post revisions.\
  Can be set to either `true` to keep all revisions, `false` to ignore all
  revisions or to *n* (integer) to keep *n* revisions.\
  Defaults to `true`.

- **`WP_DEBUG_LOG`**\
  Instructs WordPress to log errors in a *debug.log* file.\
  Only available in *development* environment.\
  Can be set to either `true` to enable the logging or `false` to disable it.\
  Defaults to `true` in *development* environment, else defaults to `false`.
