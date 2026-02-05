---
index: 3
title: Deploying Behind a Reverse Proxy
modified_at: 2026-02-03 12:00:00
---


{% note %}
Please consider reading [Planning your Deployment][deploy-plan] for more
information about the choices made in this guide.
{% endnote %}

Deploying Keycloak behind a reverse proxy is highly recommenced, since it
allows for even greater control and security:
- It prevents Keycloak from being directly exposed to the Internet.
- It allows to setup features such as rate-limiting and IP allow/deny lists.
- It allows to scale the reverse proxy so that it can handle traffic peaks or
  sudden load.

In this scenario, we use nginx as the reverse proxy. Keycloak is deployed in
a [Private Network][private-networking] and stays hidden behind the reverse
proxy.

Here is a very basic working example of nginx configuration that can be used as
a starting point. It only proxies the strictly required endpoints, which has
the advantage to drastically lower the attack surface of Keycloak:

{: #nginx-config}
```erb
upstream keycloak {
  server <%= ENV["KEYCLOAK_PRIVATE_DOMAIN"] %>:80;
  ip_hash;
}

server {
  server_name localhost;
  listen <%= ENV["PORT"] %>;
  charset utf-8;

  location /realms/ {
    proxy_pass      http://keycloak/realms/;
    proxy_redirect  default;
  }

  location /resources/ {
    proxy_pass      http://keycloak/resources/;
    proxy_redirect  default;
  }

  location /.well-known/ {
    proxy_pass      http://keycloak/.well-known/;
    proxy_redirect  default;
  }
}
```


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

3. Identify the project you just created and keep its ID aside.

4. Reach out to our Support team to enable Private Network for your Project.

### Creating the Keycloak App

1. Create a new application **in the project**:
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

3. Create a few **mandatory** environment variables:
   ```bash
   scalingo --app my-keycloak env-set KC_PROXY_HEADERS=xforwarded
   scalingo --app my-keycloak env-set KC_HTTP_ENABLED=true
   scalingo --app my-keycloak env-set KC_HTTP_PORT=80
   scalingo --app my-keycloak env-set KC_HOSTNAME=<hostname>
   scalingo --app my-keycloak env-set KC_CACHE_EMBEDDED_NETWORK_BIND_ADDRESS="match-address:10.240.\*"
   ```
   With `hostname` being the address at which Keycloak is listening\\
   (e.g. `my-keycloak.scalingo.io`).

   Using port 80 is an example, you can choose any port number.

4. (optional) Create credentials for the initial administrator user:
   ```bash
   scalingo --app my-keycloak env-set KC_BOOTSTRAP_ADMIN_USERNAME=<admin_username>
   scalingo --app my-keycloak env-set KC_BOOTSTRAP_ADMIN_PASSWORD=<admin_password>
   ```

5. Add a [`Procfile`][procfile] to your git repository, with the following
   content:
   ```yaml
   kc: /app/keycloak/bin/kc.sh start --optimized
   ```
   This instructs the platform to start Keycloak in a [process type][procfile]
   named `kc` (instead of `web`), which can't be publicly exposed.

6. (optional) Instruct the platform to run the `kc` process type in three XL
   containers:
   ```bash
   scalingo --app my-keycloak scale kc:3:XL
   ```

7. Everything’s ready, deploy to Scalingo:
   ```bash
   git push scalingo master
   ```

From this point, you should have a working Keycloak cluster running in its own
Private Network. Let's go on with the next step: deploying the reverse proxy.

### Creating the Reverse Proxy App

1. Create a new application **in the same Project**:
   ```bash
   scalingo create --project-id <project_id> my-nginx
   ```

2. Follow [our documentation][deploy-nginx] to deploy nginx.

3. Create an environment variable to store the `kc` process type's [private
   domain name]:
   ```bash
   scalingo --app my-nginx env-set KEYCLOAK_PRIVATE_DOMAIN=kc.<private_network_fqdn>
   ```
   With `private_network_fqdn` being the private domain name of the application
   hosting the Keycloak cluster.

4. Create a `servers.conf.erb` file for nginx, using [the sample suggested
   above](#nginx-config), or your own.

5. Deploy:
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

### Creating the Keycloak App

1. Place the following `scalingo_app` resource block in your Terraform file:
   ```tf
   resource "scalingo_app" "my-keycloak" {
     name           = "my-keycloak"
     project_id     = scalingo_project.keycloak_project.id
     stack_id       = "scalingo-24"
     force_https    = true

     environment = {
       KC_PROXY_HEADERS = "xforwarded",
       KC_HTTP_ENABLED  = true,
       KC_HTTP_PORT     = 80,
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

   resource "scalingo_scm_repo_link" "my-keycloak-repo" {
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

4. Add a [`Procfile`][procfile] to your git repository, with the following
   content:
   ```yaml
   kc: /app/keycloak/bin/kc.sh start --optimized
   ```
   This instructs the platform to start Keycloak in a [process type][procfile]
   named `kc` (instead of `web`), which can't be publicly exposed.

5. (optional) Instruct the platform to run the `kc` process type in three XL
   containers:
   ```tf
   resource "scalingo_container_type" "kc" {
     app    = scalingo_app.my-keycloak.id
     name   = "kc"
     size   = "XL"
     amount = 3
   }
   ```

### Creating the Reverse Proxy App

1. Create a new git repository dedicated to nginx.

2. In this repository, create a `servers.conf.erb` file for nginx, using [the
   sample suggested above](#nginx-config), or your own.

3. Place the following `scalingo_private_network_domain` data block in your
   Terraform file:
   ```tf
   data "scalingo_private_network_domain" "pndn" {
     app = ""
   }
   ```

4. Place the following `scalingo_app` resource block in your Terraform file:
   ```tf
   resource "scalingo_app" "my-nginx" {
     name           = "my-nginx"
     project_id     = scalingo_project.keycloak.id
     stack_id       = "scalingo-24"

     environment = {
       KEYCLOAK_PRIVATE_DOMAIN = "kc.<private_network_fqdn>"
     }
   }
   ```
   With `private_network_fqdn` being the [private domain name] of the `kc`
   process type of the Keycloak app.

5. Link the app to your repository:
   ```tf
   resource "scalingo_scm_repo_link" "my-nginx-repo" {
     auth_integration_uuid = data.scalingo_scm_integration.github.id
     app                   = scalingo_app.my-nginx.id
     source                = "https://github.com/<username>/my-nginx"
     branch                = "master"
   }
   ```

5. (optional) Instruct the platform to run the `web` process type in a single L
   container:
   ```tf
   resource "scalingo_container_type" "web" {
     app    = scalingo_app.my-nginx.id
     name   = "web"
     size   = "L"
     amount = 1
   }
   ```

6. Run `terraform plan` and check if the result looks good

7. If so, run `terraform apply`

8. Once Terraform is done, your Keycloak instance is ready to be deployed:
   1. Head to your [dashboard]
   2. Click on your Keycloak application
   3. Click on the Deploy tab
   4. Click on Manual deployment in the left menu
   5. Click the Trigger deployment button
   6. After a few seconds, your Keycloak instance is finally up and running!



[keycloak-scalingo]: https://github.com/Scalingo/keycloak-scalingo

[dashboard]: https://dashboard.scalingo.com/

[deploy-plan]: {% post_url platform/getting-started/getting-started-with-keycloak/2000-01-01-overview %}#planning-your-deployment
[private-networking]: {% post_url platform/networking/private/2000-01-01-overview %}
[project]: {% post_url platform/projects/2000-01-01-overview %}
[procfile]: {% post_url platform/app/2000-01-01-procfile %}
[deploy-nginx]: {% post_url platform/deployment/buildpacks/2000-01-01-nginx %}
[private domain name]: {% post_url platform/networking.private/2000-01-01-concepts %}#private-domain-names

