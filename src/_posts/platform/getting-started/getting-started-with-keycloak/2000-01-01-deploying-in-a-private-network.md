---
index: 2
title: Deploying in a Private Network
modified_at: 2026-02-03 12:00:00
---


{% note %}
Please consider reading [Planning your Deployment][deploy-plan] for more
information about the choices made in this guide.
{% endnote %}


## Using the Command Line

### Creating a Project

1. From the command line, create a new [Project][project] to host Keycloak:
   ```bash
   scalingo projects-add keycloak
   ```

2. Retrieve the project ID:
   ```bash
   scalingo projects
   ```
   The output should look like this:
   ```bash
    /!\  This command only displays projects where you are the owner
   ┌──────────┬─────────┬──────────────────────────────────────────┬─────────────────┐
   │   NAME   │ DEFAULT │                    ID                    │ PRIVATE NETWORK │
   ├──────────┼─────────┼──────────────────────────────────────────┼─────────────────┤
   │ keycloak │ false   │ prj-32232e93-8c8a-4898-8a68-d10ff1e63f7a │ true            │
   ```

3. Identify the project you've just created and keep its ID aside.

4. Reach out to our Support team to enable Private Network for your Project.

### Creating the App

1. Create the application **in the project**:
   ```bash
   scalingo create my-keycloak --project-id <project_id>
   ```
   With `project_id` being the ID of the project just created.

   Notice that our Command Line automatically detects the git repository, and
   adds a git remote to Scalingo:
   ```bash
   git remote -v

   origin   https://github.com/Scalingo/keycloak-scalingo (fetch)
   origin   https://github.com/Scalingo/keycloak-scalingo (push)
   scalingo git@ssh.osc-fr1.scalingo.com:my-keycloak.git (fetch)
   scalingo git@ssh.osc-fr1.scalingo.com:my-keycloak.git (push)
   ```

2. Provision a Scalingo for PostgreSQL® Business 1G database:
   ```bash
   scalingo --app my-keycloak addons-add postgresql postgresql-business-1024
   ```

3. Enable sticky sessions:
   ```bash
   scalingo --app my-keycloak sticky-session --enable
   ```

4. Create a few **mandatory** environment variables:
   ```bash
   scalingo --app my-keycloak env-set KC_PROXY_HEADERS=xforwarded
   scalingo --app my-keycloak env-set KC_HTTP_ENABLED=true
   scalingo --app my-keycloak env-set KC_HTTP_PORT=\$PORT
   scalingo --app my-keycloak env-set KC_HOSTNAME=<hostname>
   scalingo --app my-keycloak env-set KC_CACHE_EMBEDDED_NETWORK_BIND_ADDRESS="match-address:10.240.\*"
   ```
   With `hostname` being the address at which Keycloak is listening\\
   (e.g. `my-keycloak.scalingo.io`).

5. (optional) Create credentials for the initial administrator user:
   ```bash
   scalingo --app my-keycloak env-set KC_BOOTSTRAP_ADMIN_USERNAME=<admin_username>
   scalingo --app my-keycloak env-set KC_BOOTSTRAP_ADMIN_PASSWORD=<admin_password>
   ```

6. (optional) Instruct the platform to run the `web` process type in three XL
   containers:
   ```bash
   scalingo --app my-keycloak scale web:3:XL
   ```

7. Everything’s ready, deploy to Scalingo:
   ```bash
   git push scalingo master
   ```


## Using the Terraform Provider

### Creating a Project

1. Start by forking our [Keycloak repository][keycloak-scalingo]

2. Place the following `scalingo_project` resource block in your Terraform
   file:
   ```tf
   resource "scalingo_project" "keycloak_project" {
     name    = "keycloak"
     default = false
   }
   ```

### Creating the App

1. Place the following `scalingo_app` resource block in your Terraform file:
   ```tf
   resource "scalingo_app" "my-keycloak" {
     name           = "my-keycloak"
     project_id     = scalingo_project.keycloak_project.id
     stack_id       = "scalingo-24"
     force_https    = true
     sticky_session = true

     environment = {
       KC_PROXY_HEADERS = "xforwarded",
       KC_HTTP_ENABLED  = true,
       KC_HTTP_PORT     = $PORT,
       KC_HOSTNAME      = "<hostname>",
       KC_CACHE_EMBEDDED_NETWORK_BIND_ADDRESS = "match-address:10.240.\*",
       KC_BOOTSTRAP_ADMIN_USERNAME = "<admin_username>",
       KC_BOOTSTRAP_ADMIN_PASSWORD = "<admin_password>"
     }
   }
   ```

2. Link the app to your forked repository:
   ```tf
   data "scalingo_scm_integration" "github" {
     scm_type = "github"
   }

   resource "scalingo_scm_repo_link" "default" {
     auth_integration_uuid = data.scalingo_scm_integration.github.id
     app                   = scalingo_app.my-keycloak.id
     source                = "https://github.com/<username>/keycloak-scalingo"
     branch                = "master"
   }
   ```

3. Place the following `scalingo_addon` resource block in your Terraform file
   to provision a Scalingo for PostgreSQL® Business 1G database and attach it
   to your app:
   ```tf
   resource "scalingo_addon" "my-keycloak-db" {
     app         = scalingo_app.my-keycloak.id
     provider_id = "postgresql"
     plan        = "postgresql-business-1024"
   }
   ```

4. (optional) Instruct the platform to run the `web` process type in three XL
   containers:
   ```tf
   resource "scalingo_container_type" "web" {
     app    = scalingo_app.my-keycloak.id
     name   = "web"
     size   = "XL"
     amount = 3
   }
   ```

5. Run `terraform plan` and check if the result looks good

6. If so, run `terraform apply`

7. Once Terraform is done, your Keycloak instance is ready to be deployed:
   1. Head to your [dashboard]
   2. Click on your Keycloak application
   3. Click on the Deploy tab
   4. Click on Manual deployment in the left menu
   5. Click the Trigger deployment button
   6. After a few seconds, your Keycloak instance is finally up and running!




[keycloak-scalingo]: https://github.com/Scalingo/keycloak-scalingo

[dashboard]: https://dashboard.scalingo.com/

[deploy-plan]: {% post_url platform/getting-started/getting-started-with-keycloak/2000-01-01-overview %}#planning-your-deployment
[project]: {% post_url platform/projects/2000-01-01-overview %}

