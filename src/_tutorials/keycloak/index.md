---
title: Deploying Keycloak
logo: keycloak
category: security
products:
  - Scalingo for PostgreSQL
  - Projects
  - Private Networks
permalink: /tutorials/keycloak
modified_at: 2026-05-22
last_reviewed_at: 2026-05-22
---

Keycloak is an open-source identity and access management solution designed to
secure modern applications and services. It provides features such as single
sign-on (SSO), user federation, and social login integration. It supports
standard protocols like [OAuth 2.0], [OpenID Connect], and [SAML].  It also
offers centralized user management, role-based access control, and fine-grained
permissions. Overall, Keycloak helps organizations improve security while
simplifying the work of developers with authentication and authorization.


{% include tutorial_disclaimer.md %}


## Planning your Deployment

- Even if Keycloak provides quite precise [recommendations][kc-reco] in terms
  of CPU, RAM and databases, sizing still mostly depends on the foreseen
  usage and expected performances.

- Keycloak requires a rough minimum of 1.5GB of RAM to run, and quite a lot of
  CPU (Keycloak spends a lot of time hashing, opening TLS connections, etc.).
  Consequently, we advise provisioning at least one XL container, and possibly
  change for a more powerful plan later.

- Keycloak requires its own database. Considering the key role Keycloak is
  generally playing, we advise to always deploy with at least a [Business
  service class][db-business-class], mainly to benefit from the higher SLA and
  redundancy. In this tutorial, we deploy a [Scalingo for PostgreSQL® Business
  1G][db-postgresql].

- Keycloak is designed for multi-node clustered setups. In production mode, it
  uses a distributed cache (implemented via Infinispan) to share some resources
  between nodes. To be able to benefit from this cache, which is highly
  recommended, we deploy multiple Keycloak containers in a
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
  - It allows to set up features such as rate-limiting and IP allow/deny lists.
  - It allows to scale the reverse proxy so that it can handle traffic peaks or
    sudden load.

- To do so, we deploy two applications, grouped in the same [Project][project]:
  one hosting Keycloak and the second one hosting the reverse proxy.

- Keycloak provides an [exhaustive list of configuration options][kc-config],
  recommendations to [run in production][kc-production], and documentation
  for [administrating][kc-admin] Keycloak.\\
  We strongly suggest to read these pages before entering prodution.


## Creating the Project

### Using the Command Line

1. From the command line, create a new [Project][project] to host the
   applications:
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

### Using the Terraform Provider

1. Place the following `scalingo_project` resource block in your Terraform
   file:
   ```tf
   resource "scalingo_project" "keycloak-prj" {
     name    = "keycloak"
     default = false
   }
   ```


## Deploying Keycloak

### Using the Command Line

1. Fork our [Keycloak repository][keycloak-scalingo]

2. Create a new application **in the project**:
   ```bash
   scalingo create my-keycloak --project-id <project_id>
   ```
   With `project_id` being the ID of the newly created project.

3. Provision a Scalingo for PostgreSQL® Business 1G database:
   ```bash
   scalingo --app my-keycloak addons-add postgresql postgresql-business-1024
   ```

4. Let the platform know what buildpack it must use:
   ```bash
   scalingo --app my-keycloak env-set BUILDPACK_URL=https://github.com/Scalingo/keycloak-buildpack
   ```

5. Create a few **mandatory** environment variables:

   - These make sure Keycloak runs properly on Scalingo:
     ```bash
     scalingo --app my-keycloak env-set KC_PROXY_HEADERS=xforwarded
     scalingo --app my-keycloak env-set KC_HTTP_ENABLED=true
     scalingo --app my-keycloak env-set KC_HTTP_PORT=80
     scalingo --app my-keycloak env-set KC_HOSTNAME=<hostname>
     ```
     With `hostname` being the publicly exposed address at which Keycloak is
     available\\
     (e.g. `my-keycloak.osc-fr1.scalingo.io`).

     Using port 80 is an example, you can choose any port number.

   - This one restricts the cache communications to the Private Network only:
     ```bash
     scalingo --app my-keycloak env-set KC_CACHE_EMBEDDED_NETWORK_BIND_ADDRESS="match-address:10.240.\*"
     ```

   - These are used to create the initial credentials for the administrator
     user (remember to use a **strong** password):
     ```bash
     scalingo --app my-keycloak env-set KC_BOOTSTRAP_ADMIN_USERNAME=<admin_username>
     scalingo --app my-keycloak env-set KC_BOOTSTRAP_ADMIN_PASSWORD=<admin_password>
     ```

6. Create a few more **recommended** environment variables:

   - This one pins the version of Keycloak. This prevents against unintentional
     updates:
     ```bash
     scalingo --app my-keycloak env-set KEYCLOAK_VERSION="<version>"
     ```
     With `version` being the version number to deploy.

   - This one restricts the communication with the reverse proxy to the Private
     Network only:
     ```bash
     scalingo --app my-keycloak env-set KC_PROXY_TRUSTED_ADDRESSES="10.240.0.0/22"
     ```

   - This one allows to limit the number of queued requests, which is important
     to protect the cluster against overload situations:
     ```bash
     scalingo --app my-keycloak env-set KC_HTTP_MAX_QUEUED_REQUESTS=<number>
     ```
     With `number` being the number of requests Keycloak can keep in queue
     before dropping additional ones. Set this to a number matching your
     environment.

7. Add a [`Procfile`][procfile] to your git repository, with the following
   content:
   ```yml
   kc: /app/keycloak/bin/kc.sh start --optimized
   ```
   This instructs the platform to start Keycloak in a [process type][procfile]
   named `kc`, which, unlike `web`, can **not** be publicly exposed.

8. (optional) Instruct the platform to run the `kc` process type in three XL
   containers:
   ```bash
   scalingo --app my-keycloak scale kc:3:XL
   ```

9. Everything’s ready, deploy to Scalingo:
   ```bash
   git push scalingo master
   ```

From this point, you should have a working Keycloak cluster running in its own
Private Network on Scalingo.

### Using the Terraform Provider

1. Fork our [Keycloak repository][keycloak-scalingo]

2. Place the following `scalingo_app` resource block in your Terraform file:
   ```tf
   resource "scalingo_app" "my-keycloak" {
     name           = "my-keycloak"
     project_id     = scalingo_project.keycloak-prj.id
     stack_id       = "scalingo-24"
     force_https    = true

     environment = {
       BUILDPACK_URL    = "https://github.com/Scalingo/keycloak-buildpack",
       KEYCLOAK_VERSION = "<version>",
       KC_PROXY_HEADERS = "xforwarded",
       KC_HTTP_ENABLED  = true,
       KC_HTTP_PORT     = 80,
       KC_HOSTNAME      = "<hostname>",
       KC_CACHE_EMBEDDED_NETWORK_BIND_ADDRESS = "match-address:10.240.\*",
       KC_PROXY_TRUSTED_ADDRESSES  = "10.240.0.0/24",
       KC_HTTP_MAX_QUEUED_REQUESTS = <number>,
       KC_BOOTSTRAP_ADMIN_USERNAME = "<admin_username>",
       KC_BOOTSTRAP_ADMIN_PASSWORD = "<admin_password>"
     }
   }
   ```

3. Link the app to your forked repository:
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

4. Place the following `scalingo_addon` resource block in your Terraform file
   to provision a Scalingo for PostgreSQL® Business 1G database and attach it
   to your app:
   ```tf
   resource "scalingo_addon" "my-keycloak-db" {
     app         = scalingo_app.my-keycloak.id
     provider_id = "postgresql"
     plan        = "postgresql-business-1024"
   }
   ```

5. Add a [`Procfile`][procfile] to your git repository, with the following
   content:
   ```yml
   kc: /app/keycloak/bin/kc.sh start --optimized
   ```
   This instructs the platform to start Keycloak in a [process type][procfile]
   named `kc`, which, unlike `web`, can **not** be publicly exposed.

6. (optional) Instruct the platform to run the `kc` process type in three XL
   containers:
   ```tf
   resource "scalingo_container_type" "kc" {
     app    = scalingo_app.my-keycloak.id
     name   = "kc"
     size   = "XL"
     amount = 3
   }
   ```

7. Run `terraform plan` and check if the result looks good

8. If so, run `terraform apply`

9. Once Terraform is done, your Keycloak instance is ready to be deployed:
   1. Head to your [dashboard]
   2. Click on your Keycloak application
   3. Click on the Deploy tab
   4. Click on Manual deployment in the left menu
   5. Click the Trigger deployment button
   6. After a few seconds, your Keycloak cluster is finally up and running!


## Deploying the Reverse Proxy

Here is a very basic working example of nginx configuration that can be used as
a starting point. It only proxies the strictly required endpoints, which has
the advantage of drastically lowering the attack surface of Keycloak:

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

  # Optional hardening:
  proxy_hide_header X-Powered-By;

  location ^~ /realms/ {
    proxy_pass      http://keycloak/realms/;
    proxy_redirect  default;
  }

  location ^~ /resources/ {
    proxy_pass      http://keycloak/resources/;
    proxy_redirect  default;
  }

  location ^~ /.well-known/ {
    proxy_pass      http://keycloak/.well-known/;
    proxy_redirect  default;
  }
}
```

### Using the Command Line

1. Create a new application **in the same Project**:
   ```bash
   scalingo create my-nginx --project-id <project_id>
   ```

2. Follow [our documentation][deploy-nginx] to deploy nginx.

3. Create an environment variable to store the `kc` process type's [private
   domain name]:
   ```bash
   scalingo --app my-nginx env-set KEYCLOAK_PRIVATE_DOMAIN=kc.<private_network_fqdn>
   ```
   With `<private_network_fqdn>` being the [private domain name] of the
   application hosting the Keycloak cluster.

4. Create a `servers.conf.erb` file for nginx, using [the sample suggested
   above](#nginx-config), **or your own**.

5. Deploy:
   ```bash
   git push scalingo master
   ```

### Using the Terraform Provider

1. Create a new git repository dedicated to nginx.

2. In this repository, create a `servers.conf.erb` file for nginx, using [the
   sample suggested above](#nginx-config), **or your own**.

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

5. Link the app to your repository:
   ```tf
   resource "scalingo_scm_repo_link" "my-nginx-repo" {
     auth_integration_uuid = data.scalingo_scm_integration.github.id
     app                   = scalingo_app.my-nginx.id
     source                = "https://github.com/<username>/my-nginx"
     branch                = "master"
   }
   ```

6. (optional) Instruct the platform to run the `web` process type in a single L
   container:
   ```tf
   resource "scalingo_container_type" "web" {
     app    = scalingo_app.my-nginx.id
     name   = "web"
     size   = "L"
     amount = 1
   }
   ```

7. Run `terraform plan` and check if the result looks good

8. If so, run `terraform apply`

9. Once Terraform is done, your nginx instance is ready to be deployed:
   1. Head to your [dashboard]
   2. Click on your nginx application
   3. Click on the Deploy tab
   4. Click on Manual deployment in the left menu
   5. Click the Trigger deployment button
   6. After a few seconds, your nginx reverse proxy instance is finally up and
      running, making your Keycloak cluster reachable!


## Exposing the Admin

Keycloak's `/admin` endpoint provides access to the administration console and
management APIs used to configure and operate a Keycloak cluster. Through this
endpoint, administrators can manage realms, users, groups, roles, identity
providers, clients, and authentication flows.

{% warning %}
Because it exposes highly privileged operations, the `/admin` interface should
be carefully secured using strong authentication, network restrictions, HTTPS,
and proper role-based access controls. **In production environments, limiting
or disabling external exposure of the admin endpoint is considered a security
best practice.**
{% endwarning %}

### Using the Command Line or the Terraform Provider

1. Add a `limit_req_zone` directive to set up rate limiting at the top of the
   `servers.conf.erb` file:
   ```erb
   # Rate limiting for /admin:
   limit_req_zone $binary_remote_addr zone=keycloak_admin:10m rate=5r/m;
   ```

2. Add two new `location` in the `servers.conf.erb` file:
   ```erb
   location = /admin {
     return 301 /admin/;
   }

   location ^~ /admin/ {
     # IP allow list:
     allow 192.0.2.10;
     allow 198.51.100.0/24;
     deny all;

     # Rate limiting:
     limit_req zone=keycloak_admin burst=10 nodelay;

     proxy_pass       http://keycloak/admin/;
     proxy_redirect   default;
   }
   ```

2. Trigger a new deployment


## Exposing Health and Metrics

Keycloak allows to track instances status, health, and performances, thanks to
[several health checks][kc-health] and [metrics][kc-metrics] endpoints.

**When enabled**, these endpoints are exposed on the management port, which
defaults to TCP `9000`. **By default, they are not available**, and they must
be explicitely enabled.

{% warning %}
When enabled, and because they expose sensitive data and information, the
`/health` and `/metrics` endpoints should be carefully secured using strong
authentication, network restrictions, HTTPS, and proper role-based access
controls. **In production environments, limiting or disabling external exposure
of these endpoints is considered a security best practice.**
{% endwarning %}

{: #health-metrics-first-steps}
1. Add a new `upstream` dedicated to management in the `servers.conf.erb` file:
   ```erb
   upstream mgmt {
     server <%= ENV["KEYCLOAK_PRIVATE_DOMAIN"] %>:<%= ENV["KC_HTTP_MANAGEMENT_PORT"] or 9000 %>;
   }
   ```

2. Add two new `limit_req_zone` directives for health and metrics:
   ```erb
   limit_req_zone $binary_remote_addr zone=keycloak_health:10m  rate=60r/m;
   limit_req_zone $binary_remote_addr zone=keycloak_metrics:10m rate=30r/m;
   ```

3. Add two new `location` in the `servers.conf.erb` file:
   ```erb
   <% if ENV["KC_HEALTH_ENABLED"] %>
   location ^~ /health/ {
     # IP allow list:
     allow 192.0.2.20;
     allow 198.51.100.0/24;
     deny all;

     limit_req zone=keycloak_health burst=20 nodelay;

     proxy_pass       http://mgmt/health/;
     proxy_redirect   default;
   }
   <% end %>

   <% if ENV["KC_METRICS_ENABLED"] %>
   location = /metrics {
     # IP allow list:
     allow 192.0.2.20;
     allow 198.51.100.0/24;
     deny all;

     # Rate limiting:
     limit_req zone=keycloak_metrics burst=10 nodelay;

     proxy_pass       http://mgmt/metrics;
     proxy_redirect   default;
   }
   ```

### Using the Command Line

Make sure you have followed [the first steps](#health-metrics-first-steps)

{:start="4"}
4. Enable the health and/or metrics endpoints:
   ```bash
   scalingo --app my-keycloak env-set KC_HEALTH_ENABLED=true
   scalingo --app my-keycloak env-set KC_METRICS_ENABLED=true
   ```

5. (optional) Choose a port for the management interface:
   ```bash
   scalingo --app my-keycloak env-set KC_HTTP_MANAGEMENT_PORT=9000
   ```

6. Trigger a new deployment

### Using the Terraform Provider

Make sure you have followed [the first steps](#health-metrics-first-steps)

{:start="4"}
4. Update the `scalingo_app` resource block of the Keycloak app to include the
   appropriate environment variables:
   ```tf
   resource "scalingo_app" "my-keycloak" {
     name           = "my-keycloak"
     project_id     = scalingo_project.keycloak_project.id
     stack_id       = "scalingo-24"

     environment = {
       # [...]
       KC_HEALTH_ENABLED  = true,
       KC_METRICS_ENABLED = true,
       # Optional:
       KC_HTTP_MANAGEMENT_PORT = 9000
     }
   }
   ```

5. Trigger a new deployment


## Managing Logs

By default, Keycloak runs with the `INFO` log level. This provides general
operational information such as Keycloak lifecycle events, authentication
flows, and warnings, without being overly verbose.

Logging can be configured either globally or per component. The log level can
be changed using environment variables. For example, to set the general log
level to `DEBUG`, set `KC_LOG_LEVEL` to `DEBUG`.

It is also possible to enable logging for specific components only, allowing
for troubleshooting specific issues without flooding the logs. To do so, use an
environment variable named after the component. For example, to specify a
different log level for the component `org.hibernate`, you could set
`KC_LOG_LEVEL_ORG_HIBERNATE` to `DEBUG`.

Logs are written to standard output by default, making them fully compatible
with every logging features Scalingo provides.

For further guidance related to Keycloak logging, please refer to [the official
documentation][kc-logging].


## Managing Vulnerabilities

Keycloak official vulnerabilities and security issues are documented
[here][kc-vuln] by the editor.


## Updating

While updating Keycloak is generally safe, we still advise to take extra care,
especially before updating a production instance:

- Review the [official changelog][kc-changelog] that is published with each
  release. Breaking and notable changes should catch your attention.
- Ensure your [SPIs](#service-provider-interfaces) and themes are compatible
  with the new version.
- Keep a recent backup of your production database aside. The update process
  sometimes involves database updates, which can unfortunately fail. Having a
  backup allows to rollback to a working version in case of failures.
- Test the exact update path on a testing instance.

### Using the Command Line

1. Update the version to the desired number:
   ```bash
   scalingo --app my-keycloak env-set KEYCLOAK_VERSION=<new_version>
   ```

2. In your Keycloak repository, create a new empty commit:
   ```bash
   git commit -m "Deploy version <new_version>" --allow-empty
   ```

3. Trigger a new deployment

### Using the Terraform Provider

1. Update the `scalingo_app` resource block of the Keycloak app to include the
   `KEYCLOAK_VERSION` environment variables:
   ```tf
   resource "scalingo_app" "my-keycloak" {
     name           = "my-keycloak"
     project_id     = scalingo_project.keycloak_project.id
     stack_id       = "scalingo-24"

     environment = {
       # [...]
       KEYCLOAK_VERSION = "<new_version>"
     }
   }
   ```

2. Trigger a new deployment


## Customizing

### Service Provider Interfaces

Keycloak is designed to be extensible. It provides multiple Service Provider
Interfaces (SPIs), each responsible for providing a specific capability to the
server.

To add SPIs to your Keycloak cluster:

1. Create a directory named `providers` at the root of your project
2. Put the `.jar` files in this directory (don't forget to also add them to
   your git repository):
   ```
   my-keycloak
   ├── Procfile
   ├── providers
   │   └── spi.jar
   └── system.properties
   ```
3. Configure each SPI using the available environment variables (please refer
   to the SPI documentation for available variables)
4. Trigger a new deployment

### Themes

Keycloak also supports custom themes, which allow to personalize the look and
feel of end-user facing pages. This allows to further integrate Keycloak with
your applications or company.

To add themes to your Keycloak cluster:

1. Create a directory named `providers` at the root of your project
2. Put the `.jar` files in this directory (don't forget to also add them to
   your git repository):
   ```
   my-keycloak
   ├── Procfile
   ├── providers
   │   └── theme.jar
   └── system.properties
   ```
3. Configure each theme using the available environment variables (please refer
   to the theme documentation for available variables)
4. Trigger a new deployment

### Environment

Keycloak supports [many environment variables][kc-config].

Moreover, the buildpack makes use of the following environment variables. They
can be leveraged to customize your deployment:

- `KEYCLOAK_VERSION`\\
  Allows to specify the version of Keycloak to deploy.\\
  Defaults to not being set, which falls back on the [default
  version][keycloak-default-version] set in the buildpack.

- `KEYCLOAK_PRIVATE_DOMAIN_NAME`\\
  Private domain name of the Keycloak process type. Allows the reverse proxy to
  know where the requests must be forwarded.\\
  Default to not being set.


*[SSO]: Single Sign-On
*[SLA]: Service Level Agreement
*[SPI]: Service Provider Interface

[OAuth 2.0]: https://oauth.net/2/
[OpenID Connect]: https://openid.net
[SAML]: https://en.wikipedia.org/wiki/Security_Assertion_Markup_Language
[kc-reco]: https://www.keycloak.org/high-availability/single-cluster/concepts-memory-and-cpu-sizing
[kc-config]: https://www.keycloak.org/server/all-config?f=config
[kc-admin]: https://www.keycloak.org/docs/latest/server_admin/index.html
[kc-production]: https://www.keycloak.org/server/configuration-production
[kc-health]: https://www.keycloak.org/observability/health
[kc-metrics]: https://www.keycloak.org/observability/configuration-metrics
[kc-logging]: https://www.keycloak.org/server/logging
[kc-vuln]: https://github.com/keycloak/keycloak/security
[kc-changelog]: https://www.keycloak.org/docs/latest/release_notes/index.html

[keycloak-scalingo]: https://github.com/Scalingo/keycloak-scalingo
[keycloak-default-version]: https://github.com/Scalingo/keycloak-buildpack/blob/master/VERSIONS#L3

[dashboard]: https://dashboard.scalingo.com/

[db-business-class]: {% post_url databases/about/2000-01-01-service-classes %}#business
[db-postgresql]: {% post_url databases/postgresql/about/2000-01-01-overview %}
[private-networking]: {% post_url platform/networking/private/2000-01-01-overview %}
[private domain name]: {% post_url platform/networking.private/2000-01-01-concepts %}#private-domain-names
[private-networking-addressing]: {% post_url platform/networking/private/2000-01-01-concepts %}#addressing
[deploy-nginx]: {% post_url platform/deployment/buildpacks/2000-01-01-nginx %}
[procfile]: {% post_url platform/app/2000-01-01-procfile %}
[project]: {% post_url platform/projects/2000-01-01-overview %}
