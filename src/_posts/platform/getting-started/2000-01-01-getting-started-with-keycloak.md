---
index: 17
title: Getting Started with Keycloak
modified_at: 2026-02-01 12:00:00
---

Keycloak is an open-source identity and access management solution designed to
secure modern applications and services. It provides features such as single
sign-on (SSO), user federation, and social login integration. It supports
standard protocols like [OAuth 2.0], [OpenID Connect], and [SAML].  It also
offers centralized user management, role-based access control, and fine-grained
permissions. Overall, Keycloak helps organizations improve security while
simplifying the work of developers with authentication and authorization.


## Planning your Deployment

- Even if Keycloak provides quite precise [recommendations][kc-reco] in terms
  of CPU, RAM and databases, sizing nevertheless mostly depends on the foreseen
  usage and expected performances.

- Keycloak requires a rough minimum of 1.5GB of RAM to run, and quite a lot of
  CPU (Keycloak spends a lot of time hashing, opening TLS connections, etc.).
  Consequently, we advise provisioning at least one XL container.

- Keycloak requires its own database. Considering the key role Keycloak is
  generally playing, we advise to always deploy with a [Scalingo for
  PostgreSQL® Business addon][db-postgresql], mainly to benefit from the higher
  SLA and redundancy.

- Keycloak requires Java version 21 or above to run. We can instruct Scalingo
  to use a specific version of Java by using the `system.properties` file, as
  described in [our documentation][choose-jdk].

- Keycloak is designed for multi-node clustered setups. In production mode, it
  uses a distributed cache (implemented via Infinispan) to share some resources
  between nodes. To be able to benefit from this cache, which is highly
  recommended, we will deploy multiple Keycloak containers in a
  [Private Network][private-networking]:

  - Infinispan uses several TCP ports to run. Running inside a Private Network
    gives us the freedom to bind any port we want.

  - Infinispan also features some auto-discovery mechanism to automatically
    update the list of available nodes in the cluster. By relying on it, we can
    ensure the cache is always well distributed between the available nodes.

  - To do so, we have to make sure Keycloak listens on the [Private Network IP
    addresses][private-networking-addressing] for everything related to the
    Infinispan distributed cache.

- For greater control and security, we suggest to deploy behind a reverse
  proxy:

  - It prevents Keycloak from being directly exposed to the Internet.

  - It allows to setup features such as rate-limiting and IP allow/deny lists.

  - It allows to scale the reverse proxy so that it can handle traffic peaks or
    sudden load.

- To do so, we will deploy two applications in the same [Project][project]:
  one hosting Keycloak and the second one hosting the reverse proxy (nginx in
  this guide).

{% note %}
This guide aims at helping deploy Keycloak on Scalingo. Configuring and
managing Keycloak is out of the scope of this guide.
{% endnote %}


## Creating the Project

### Using the Command Line

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

### Using the Terraform Provider

1. Start by forking our [Keycloak repository][keycloak-scalingo]

2. Place the following `scalingo_project` resource block in your Terraform
   file:
   ```tf
   resource "scalingo_project" "keycloak-prj" {
     name    = "keycloak"
     default = false
   }
   ```


## Deploying Keycloak

### Using the Command Line

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
Private Network.

### Using the Terraform Provider

1. Place the following `scalingo_app` resource block in your Terraform file:
   ```tf
   resource "scalingo_app" "my-keycloak" {
     name           = "my-keycloak"
     project_id     = scalingo_project.keycloak-prj.id
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

6. Run `terraform plan` and check if the result looks good

7. If so, run `terraform apply`

8. Once Terraform is done, your Keycloak instance is ready to be deployed:
   1. Head to your [dashboard]
   2. Click on your Keycloak application
   3. Click on the Deploy tab
   4. Click on Manual deployment in the left menu
   5. Click the Trigger deployment button
   6. After a few seconds, your Keycloak instance is finally up and running!


## Deploying the Reverse Proxy

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

### Using the Command Line

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

### Using the Terraform Provider

1. Create a new git repository dedicated to nginx.

2. In this repository, create a `servers.conf.erb` file for nginx, using [the
   sample suggested above](#nginx-config), or your own.

3. Place the following `scalingo_private_network_domain` data block in your
   Terraform file:
   ```tf
   data "scalingo_private_network_domain" "pndn" {
     app = scalingo_app.my-nginx.name
   }
   ```

4. Place the following `scalingo_app` resource block in your Terraform file:
   ```tf
   resource "scalingo_app" "my-nginx" {
     name           = "my-nginx"
     project_id     = scalingo_project.keycloak-prj.id
     stack_id       = "scalingo-24"

     environment = {
       KEYCLOAK_PRIVATE_DOMAIN = "kc.${substr(data.scalingo_private_network_domain.pndn.domains[0], 0, -1)}"
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


## Exposing Health and Metrics

Keycloak allows to track instances status, health, and performances, thanks to
[several health checks][kc-health] and [metrics][kc-metrics] endpoints.

**When enabled**, these endpoints are exposed on the management port, which
defaults to TCP `9000`. **By default, they are not available**, and they must
be explicitely enabled.

{% note %}
Exposing health and metrics is oftenly considered a security risk.\\
Please consider completing the configuration samples given below with security
measures such as IP allow-list or authenticated access.
{% endnote %}

### Using the Command Line

1. Enable the health and/or metrics endpoints:
   ```bash
   scalingo --app my-keycloak env-set KC_HEALTH_ENABLED=true
   scalingo --app my-keycloak env-set KC_METRICS_ENABLED=true
   ```

2. (optional) Choose a port for the management interface:
   ```bash
   scalingo --app my-keycloak env-set KC_HTTP_MANAGEMENT_PORT=9000
   ```

3. Add a new `upstream` in the `servers.conf.erb` file:
   ```erb
   upstream mgmt {
     server <%= ENV["KEYCLOAK_PRIVATE_DOMAIN"] %>:<%= ENV["KC_HTTP_MANAGEMENT_PORT"] or 9000 %>;
   }
   ```

4. Add new `location` in the `servers.conf.erb` file:
   ```erb
   <% if ENV["KC_HEALTH_ENABLED"] %>
   location /health {
     proxy_pass       http://mgmt;
     proxy_redirect   default;
   }
   <% end %>

   <% if ENV["KC_METRICS_ENABLED"] %>
   location /metrics {
     proxy_pass       http://mgmt;
     proxy_redirect   default;
   }
   ```

5. Deploy to Scalingo.

### Using the Terraform Provider

1. Update the `scalingo_app` resource block of the Keycloak app to include the
   appropriate environment variables:
   ```tf
   resource "scalingo_app" "my-keycloak" {
     name           = "my-keycloak"
     project_id     = scalingo_project.keycloak_project.id
     stack_id       = "scalingo-24"

     environment = {
       KC_PROXY_HEADERS   = "xforwarded",
       KC_HTTP_ENABLED    = true,
       KC_HTTP_PORT       = 80,
       KC_HOSTNAME        = "<hostname>",
       KC_HEALTH_ENABLED  = true,
       KC_METRICS_ENABLED = true,
       KC_CACHE_EMBEDDED_NETWORK_BIND_ADDRESS = "match-address:10.240.\*",
       KC_BOOTSTRAP_ADMIN_USERNAME = "<admin_username>",
       KC_BOOTSTRAP_ADMIN_PASSWORD = "<admin_password>"
     }
   }
   ```

2. (optional) Update the `scalingo_app` resource block of the Keycloak app to
   set the management interface port:
   ```tf
   resource "scalingo_app" "my-keycloak" {
     name           = "my-keycloak"
     project_id     = scalingo_project.keycloak_project.id
     stack_id       = "scalingo-24"

     environment = {
       KC_PROXY_HEADERS   = "xforwarded",
       KC_HTTP_ENABLED    = true,
       KC_HTTP_PORT       = 80,
       KC_HOSTNAME        = "<hostname>",
       KC_HEALTH_ENABLED  = true,
       KC_METRICS_ENABLED = true,
       KC_CACHE_EMBEDDED_NETWORK_BIND_ADDRESS = "match-address:10.240.\*",
       KC_BOOTSTRAP_ADMIN_USERNAME = "<admin_username>",
       KC_BOOTSTRAP_ADMIN_PASSWORD = "<admin_password>",
       KC_HTTP_MANAGEMENT_PORT = 9000
     }
   }
   ```

3. Add a new `upstream` in the `servers.conf.erb` file:
   ```erb
   upstream mgmt {
     server <%= ENV["KEYCLOAK_PRIVATE_DOMAIN"] %>:<%= ENV["KC_HTTP_MANAGEMENT_PORT"] or 9000 %>;
   }
   ```

4. Add new `location` in the `servers.conf.erb` file:
   ```erb
   <% if ENV["KC_HEALTH_ENABLED"] %>
   location /health {
     proxy_pass       http://mgmt;
     proxy_redirect   default;
   }
   <% end %>

   <% if ENV["KC_METRICS_ENABLED"] %>
   location /metrics {
     proxy_pass       http://mgmt;
     proxy_redirect   default;
   }
   <% end %>
   ```

6. Deploy to Scalingo.


## Upgrading


## Customizing

### Environment

Keycloak supports [many environment variables][kc-config].

Moreover, the buildpack makes use of the following environment variables. They
can be leveraged to customize your deployment:

- `KEYCLOAK_VERSION`\\
  Allows to specify the version of Keycloak to deploy.

- `KEYCLOAK_PRIVATE_DOMAIN_NAME`\\
  Private domain name of the Keycloak process type. Allows the reverse proxy to
  know where the requests must be forwarded.


*[SSO]: Single Sign-On
*[SLA]: Service Level Agreement

[OAuth 2.0]: https://oauth.net/2/
[OpenID Connect]: https://openid.net
[SAML]: https://en.wikipedia.org/wiki/Security_Assertion_Markup_Language
[kc-reco]: https://www.keycloak.org/high-availability/single-cluster/concepts-memory-and-cpu-sizing
[kc-config]: https://www.keycloak.org/server/all-config?f=config
[kc-health]: https://www.keycloak.org/observability/health
[kc-metrics]: https://www.keycloak.org/observability/configuration-metrics

[keycloak-scalingo]: https://github.com/Scalingo/keycloak-scalingo

[dashboard]: https://dashboard.scalingo.com/

[db-postgresql]: {% post_url databases/postgresql/about/2000-01-01-overview %}
[choose-jdk]: {% post_url languages/java/2000-01-01-start %}#choose-a-jdk
[private-networking]: {% post_url platform/networking/private/2000-01-01-overview %}
[private domain name]: {% post_url platform/networking.private/2000-01-01-concepts %}#private-domain-names
[private-networking-addressing]: {% post_url platform/networking/private/2000-01-01-concepts %}#addressing
[deploy-nginx]: {% post_url platform/deployment/buildpacks/2000-01-01-nginx %}
[procfile]: {% post_url platform/app/2000-01-01-procfile %}
[project]: {% post_url platform/projects/2000-01-01-overview %}

