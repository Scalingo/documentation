---
title: Getting Started with WordPress on Scalingo
modified_at: 2024-08-19 12:00:00
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

4. Add a few environment variables, either via the Dashboard or via [the
   Scalingo command line tool]({% post_url platform/cli/2000-01-01-features %}#configure-their-environment):

   | Env Variable       | Description |
   | ------------------ | ----------- |
   | `WP_HOME`          | Mandatory. Full URL to Wordpress home.<br />i.e. `https://my-app.osc-fr1.scalingo.io`                           |
   | `WP_SITEURL`       | Mandatory. Full URL to Wordpress, including the subdirectory.<br />i.e. `https://my-app.osc-fr1.scalingo.io/wp` |
   | `WP_ENV`           | Can be set to either `development`, `staging`, or `production`. Defaults to `production`.                       |
   | `AUTH_KEY`         | Mandatory. Can be generated via [Roots WordPress Salts Generator](https://roots.io/salts.html)                  |
   | `SECURE_AUTH_KEY`  | Same as above |
   | `LOGGED_IN_KEY`    | Same as above |
   | `NONCE_KEY`        | Same as above |
   | `AUTH_SALT`        | Same as above |
   | `SECURE_AUTH_SALT` | Same as above |
   | `LOGGED_IN_SALT`   | Same as above |
   | `NONCE_SALT`       | Same as above |

5. (optional) Put your theme(s) in the `web/app/themes` directory.

   Don't forget to commit your changes:

   ```bash
   git add web/app/themes
   git commit -m "Add themes"
   ```

6. (optional) Add WordPress plugins using [Composer](https://getcomposer.org)
   or [WordPress Packagist](https://wpackagist.org/search?q=&type=plugin&search=):

   ```bash
   composer require --ignore-platform-reqs wpackagist-plugin/akismet
   ```

   Don't forget to commit your changes:

   ```bash
   git add composer.json composer.lock
   git commit -m "Add plugins"
   ```

7. (optional) The following steps describe how to setup an AWS S3 bucket for
   your WordPress instance. While we know this work, any S3 storage solution
   should also work.

   1. Create a **public** S3 bucket with ACL disabled
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
   3. Configure the bucket with the following policy:

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
   4. Create a few environment variables, either via the dashboard or using
      [the Scalingo command line tool]({% post_url platform/cli/2000-01-01-features %}#configure-their-environment):

      | Env Variable            | Description                              |
      | ----------------------- | ---------------------------------------- |
      | `S3_UPLOADS_BUCKET`     | Name of the S3 bucket to upload files to |
      | `S3_UPLOADS_KEY`        | AWS Access Key ID for S3 authentication  |
      | `S3_UPLOADS_SECRET`     | AWS Secret Key for S3 authentication     |
      | `S3_UPLOADS_REGION`     | Region of the S3 bucket                  |
      | `S3_UPLOADS_OBJECT_ACL` | Object permission of files uploaded to S3. Can be either `public-read`, `private` or `authenticated-read`. Defaults to `public-read` |


8. (optional) Instruct the platform to run the `web` process type in a single
   XL container:

   ```bash
   scalingo --app my-wordpress scale web:1:XL
   ```

9. Everything's ready, deploy to Scalingo:

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
