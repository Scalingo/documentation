---
title: Deploying SonarQube
logo: sonarqube
category: security
products:
  - Scalingo for PostgreSQL®
  - Multi-buildpack
modified_at: 2025-08-07
---

SonarQube is an automatic code review tool to detect bugs, vulnerabilities, and
code smells in your project. It can integrate with your existing workflow to
enable continuous code inspection across your project branches and pull
requests.


## Planning your Deployment

- SonarQube requires its own database. We usually advise to use a [PostgreSQL®
  Starter or Business 512 addon][db-postgresql] for this purpose.

- SonarQube requires quite a lot of RAM to run properly. You most probably
  won't be able to deploy on a container smaller than 2XL.

- SonarQube requires Java version 17 to run. We can instruct Scalingo to use
  this version of JAVA by using the `system.properties` file as described in
  [our documentation][install-jdk].


## Deploying

### Using the Command Line

We maintain a repository called [sonarqube-scalingo] on GitHub to help you
deploy SonarQube **Community Edition** on Scalingo. Here are the few additional
steps you will need to follow:

1. Clone our repository:
   ```bash
   git clone https://github.com/Scalingo/sonarqube-scalingo
   cd sonarqube-scalingo
   ```

2. Create the application on Scalingo:
   ```bash
   scalingo create my-sonarqube
   ```

   Notice that our Command Line automatically detects the git repository, and
   adds a git remote to Scalingo:
   ```bash
   git remote -v

   origin   https://github.com/Scalingo/sonarqube-scalingo (fetch)
   origin   https://github.com/Scalingo/sonarqube-scalingo (push)
   scalingo git@ssh.osc-fr1.scalingo.com:my-sonarqube.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:my-sonarqube.git (push)
   ```

3. Provision a Scalingo for PostgreSQL® Starter 512 addon:
   ```bash
   scalingo --app my-sonarqube addons-add postgresql postgresql-starter-512
   ```

4. (optional) Instruct the platform to run the `web` process type in a single
   2XL container:
   ```bash
   scalingo --app my-sonarqube scale web:1:2XL
   ```

5. Everything's ready, deploy to Scalingo:
   ```bash
   git push scalingo master
   ```

   The default credentials after a first deployment are `admin` and `admin`.
   After a first successful login, SonarQube asks you to update the admin
   password.

### Using the Terraform Provider

{% note%}
The following code blocks are given as examples.\\
Please adjust the values to suit your needs.
{% endnote %}

1. Start by forking our [SonarQube repository][sonarqube-scalingo]

2. Place the following block in your Terraform file to create the app:
   ```terraform
   resource "scalingo_app" "my-sonarqube" {
     name        = "my-sonarqube"
     stack_id    = "scalingo-22"
     force_https = true
   }
   ```

3. Link the app to your forked repository:
   ```terraform
   data "scalingo_scm_integration" "github" {
     scm_type = "github"
   }

   resource "scalingo_scm_repo_link" "default" {
     auth_integration_uuid = data.scalingo_scm_integration.github.id
     app                   = scalingo_app.my-sonarqube.id
     source                = "https://github.com/<username>/sonarqube-scalingo"
     branch                = "master"
   }
   ```

4. Provision a Scalingo for PostgreSQL® Starter 512 addon and attach it to your
   app:
   ```terraform
   resource "scalingo_addon" "my-sonarqube-db" {
     app         = scalingo_app.my-sonarqube.id
     provider_id = "postgresql"
     plan        = "postgresql-starter-512"
   }
   ```

5. (optional) Instruct the platform to run the `web` process type in a single
   2XL container:
   ```terraform
   resource "scalingo_container_type" "web" {
     app    = scalingo_app.my-sonarqube.id
     name   = "web"
     size   = "2XL"
     amount = 1
   }
   ```

6. Run `terraform plan` and check if the result looks good

7. If so, run `terraform apply`

8. Once Terraform is done, your SonarQube instance is ready to be deployed:
   1. Head to your [dashboard]
   2. Click on your SonarQube application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button
   6. After a few seconds, your SonarQube instance is finally up and running!


## Updating

By default, Scalingo tries to install the latest **LTS version of the Community
Edition**.

Consequently, updating SonarQube only consists of triggering a new deployment
of your instance.

{% note %}
- Scalingo **does not** provide any guarantee in terms of packaging and
  availability after each SonarQube release. We do our best to keep it
  up-to-date, but can't guarantee it.
- You can use the dedicated environment variable ([see below](#environment)) to
  deploy a specific version.
- You can still get in touch with our support team, should you need a specific
  version.
{% endnote %}

### Using the Command Line

1. In your SonarQube repository, create an empty commit and push it to
   Scalingo:
   ```bash
   git commit --allow-empty -m "Update SonarQube"
   git push scalingo master
   ```

### Using the Terraform Provider

1. Head to your [dashboard]
2. Click on your SonarQube application
3. Click on the **Deploy** tab
4. Click on **Manual deployment** in the left menu
5. Click the **Trigger deployment** button
6. After a few seconds, your updated SonarQube instance is ready!


## Customizing

### Installing Plugins

1. Copy the plugin(s) JAR archive(s) into the `plugins` folder of your
   repository

2. Don't forget to commit your changes:
   ```bash
   git add plugins/
   git commit -m "Add plugins"
   ```

   The last steps depend on the method chosent to deploy your SonarQube
   instance (see below).

#### Using the Command Line

1. Make sure you have followed [the first steps](#installing-plugins)

2. From your SonarQube repository, trigger a new deployment:
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
   2. Click on your SonarQube application
   3. Click on the **Deploy** tab
   4. Click on **Manual deployment** in the left menu
   5. Click the **Trigger deployment** button

### Environment

[SonarQube supports many environment variables][sonarqube-env].

Moreover, the buildpack makes use of the following environment variable(s).
They can be leveraged to customize your deployment:

- **`SONARQUBE_VERSION`**\\
  Allows to specify the SonarQube version to deploy.\\
  Defaults to the version set in the buildpack.


[sonarqube-env]: https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/configure-and-operate-a-server/environment-variables/
[sonarqube-scalingo]: https://github.com/Scalingo/sonarqube-scalingo

[db-postgresql]: https://www.scalingo.com/databases/postgresql
[dashboard]: https://dashboard.scalingo.com/apps/
[one-click]: https://dashboard.scalingo.com/create/app?source=https://github.com/Scalingo/sonarqube-scalingo

[install-jdk]: {% post_url languages/java/2000-01-01-start %}#choose-a-jdk
