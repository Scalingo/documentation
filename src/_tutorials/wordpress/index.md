---
title: Deploying WordPress
logo: bedrock
category: cms
products:
  - Scalingo for MySQL®
modified_at: 2025-08-13
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
practices for cloud deployments, such as **[12 factor]**.

Hopefully, the [Roots] team has created **[Bedrock]**, a modern WordPress
boilerplate that greatly improves WordPress development by leveraging [Composer
to manage dependencies][composer-dependencies], providing a better folder
structure, facilitating environment-specific configurations, improving security
and offering better Git integration.\\
Basically everything we love at Scalingo!
{% endnote %}

- For all the reasons presented above, we will use Bedrock.

- WordPress is written in PHP. We will use the PHP buildpack along with an
  nginx web server.

- It requires a MySQL® database to store all the website content as well as
  parts of its configuration. Chosing the appropriate plan mostly depends on
  the traffic your WordPress has to handle. We usually advise to start with a
  [MySQL® for Scalingo Starter or Business 512 addon][db-mysql] and upscale
  later if need be.

- Since relying on the local filesystem to store data is not allowed on
  Scalingo, we will use an S3-compatible object storage solution. Our Bedrock
  distribution fully supports it, thanks to the
  [`humanmade/s3-uploads`][s3-uploads] embedded.

- In the following guide, we will use an AWS S3 bucket but any S3-compatible
  solution should be OK.


## Deploying

### Using the Command Line

We maintain a repository called [wordpress-scalingo] on GitHub to help you
deploy WordPress on Scalingo. Here are the few additional steps you will need
to follow:

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

3. Provision a Scalingo for MySQL® Starter 512 addon:
   ```bash
   scalingo --app my-wordpress addons-add mysql mysql-starter-512
   ```

4. Set a few **mandatory** environment variables:

   | Env Variable       | Description |
   | ------------------ | ----------- |
   | `WP_HOME`          | Mandatory. Full URL to Wordpress home.<br />i.e. `https://my-wordpress.osc-fr1.scalingo.io`                           |
   | `WP_SITEURL`       | Mandatory. Full URL to Wordpress, including the subdirectory.<br />i.e. `https://my-wordpress.osc-fr1.scalingo.io/wp` |
   | `WP_ENV`           | Can be set to either `development`, `staging`, or `production`. Defaults to `production`.                             |
   | `AUTH_KEY`         | Mandatory. Can be generated via [Roots WordPress Salts Generator](https://roots.io/salts.html)                        |

5. Generate and add a few security keys and salts, also as environment
   variables. These are random strings of characters that are used to enhance
   the security of WordPress, for example, by encrypting some data.

   They can be generated via [Roots WordPress Salts Generator][salts-gen],
   and must be added as environment variable, either via the Dashboard or via
   the [Scalingo command line tool][cli]

   - `AUTH_KEY`, `SECURE_AUTH_KEY`, `LOGGED_IN_KEY`, `NONCE_KEY`
   - `AUTH_SALT`, `SECURE_AUTH_SALT`, `LOGGED_IN_SALT`, `NONCE_SALT`

6. Setup the S3 bucket:

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
   3. Create a few additional environment variables:

      | Env Variable            | Description                              |
      | ----------------------- | ---------------------------------------- |
      | `S3_UPLOADS_BUCKET`     | Name of the S3 bucket to upload files to |
      | `S3_UPLOADS_KEY`        | AWS Access Key ID for S3 authentication  |
      | `S3_UPLOADS_SECRET`     | AWS Secret Key for S3 authentication     |
      | `S3_UPLOADS_REGION`     | Region of the S3 bucket                  |
      | `S3_UPLOADS_OBJECT_ACL` | Object permission of files uploaded to S3. Can be either `public-read`, `private` or `authenticated-read`. Defaults to `public-read` |


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
The following code blocks are given as examples.\\
Please adjust the values to suit your needs.
{% endnote %}

1. Start by forking our [WordPress/Bedrock repository][wordpress-scalingo]

2. Place the following block in your Terraform file to create the app. You can
   use [Roots WordPress Salts Generator][salts-gen] to generate the security
   keys and salts:

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

4. Provision a Scalingo for MySQL® Starter 512 addon and attach it to your app:
   ```terraform
   resource "scalingo_addon" "my-wordpress-db" {
     app         = scalingo_app.my-wordpress.id
     provider_id = "mysql"
     plan        = "mysql-starter-512"
   }
   ```

5. [Follow step 6 described previously](#using-the-command-line) to setup your
   S3 object storage. Don't forget to add the corresponding environment
   variables to your `scalingo_app` resource:
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
   1. Head to your [dashboard]
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

1. In your WordPress repository, create an empty commit and push it to
   Scalingo:
   ```bash
   git commit --allow-empty -m "Update WordPress"
   git push scalingo master
   ```

### Using the Terraform Provider

1. Head to your [dashboard]
2. Click on your WordPress application
3. Click on the **Deploy** tab
4. Click on **Manual deployment** in the left menu
5. Click the **Trigger deployment** button
6. After a few seconds, your updated WordPress instance is ready!


## Customizing

### Installing Plugins

1. Add plugins using [Composer] or [WordPress Packagist]
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
   1. Head to your [dashboard]
   2. Click on your WordPress application
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
   1. Head to your [dashboard]
   2. Click on your WordPress application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button

### Environment

Bedrock supports some environment variables. Here are a few ones that are
mandatory or worth considering:

- **`WP_HOME`**\\
  MUST be set to the base URL of your WordPress application.\\
  Defaults to being unset.

- **`WP_SITEURL`**\\
  MUST be set to the home URL of your WordPress instance (i.e. including the
  path to WordPress).\\
  Defaults to being unset.

- **`WP_ENV`**\\
  Allows to automatically enable or disable some settings (such as the log
  level, debugging, ...) depending on the value provided.\\
  Out of the box, can be either `development`, `staging` or `production`.\\
  We advise to start setting it to `staging` or `development` and switch to
  `production` only once the S3 storage is successfully configured.\\
  You can define your own custom environment and settings by creating a new one
  in `config/environments/<custom_environment_name>.php`.\\
  Defaults to `production`.

- **`DISABLE_WP_CRON`**\\
  Allows to disable WordPress' jobs scheduler.\\
  Can be set to either `true` to disable WordPress cron or `false` to enable
  it.\\
  Defaults to `false`.

- **`WP_POST_REVISIONS`**\\
  Allows to limit the number of post revisions.\\
  Can be set to either `true` to keep all revisions, `false` to ignore all
  revisions or to *n* (integer) to keep *n* revisions.\\
  Defaults to `true`.

- **`WP_DEBUG_LOG`**\\
  Instructs WordPress to log errors in a *debug.log* file.\\
  Only available in *development* environment.\\
  Can be set to either `true` to enable the logging or `false` to disable it.\\
  Defaults to `true` in *development* environment, else defaults to `false`.


[12 factor]: https://12factor.net
[Roots]: https://roots.io/about/
[Bedrock]: https://roots.io/bedrock/
[salts-gen]: https://roots.io/salts.html
[s3-uploads]: https://github.com/humanmade/S3-Uploads
[Composer]: https://getcomposer.org
[WordPress Packagist]: https://wpackagist.org/search?q=&type=plugin&search=
[wordpress-scalingo]: https://github.com/Scalingo/wordpress-scalingo

[db-mysql]: https://www.scalingo.com/databases/mysql
[dashboard]: https://dashboard.scalingo.com/apps/
[one-click]: https://dashboard.scalingo.com/create/app?source=https://github.com/Scalingo/wordpress-scalingo

[cli]: {% post_url tools/cli/2000-01-01-features %}#configure-their-environment
[composer-dependencies]: {% post_url languages/php/2000-01-01-dependencies %}
