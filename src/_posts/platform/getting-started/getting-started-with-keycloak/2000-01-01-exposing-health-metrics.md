---
index: 4
title: Exposing Keycloak Health and Metrics
modified_at: 2026-02-02 12:00:00
---


## Exposing Health Endpoints

Keycloak has built-in support for [several health
checks][keycloak-healthchecks], available at these endpoints:
- `/health/started`
- `/health/live`
- `/health/ready`
- `/health`

**When enabled**, these endpoints are exposed on the management port, which
defaults to TCP `9000`. **By default, they are not available**, and they must
be explicitely enabled.

Since `web` containers are only allowed to listen to one port, the only way we
have to expose these endpoints consists in:

- Running Keycloak in a Private Network, where the management interface can be
  bound to any port, including the default `9000`.
- Proxying the requests to Keycloak.

This setup is described in [Deploying Keycloak Behind a Reverse
Proxy][deploy-behind-reverse-proxy].

{% note %}
Exposing health is oftenly considered a security risk.\\
Please consider completing the configuration samples given below with security
measures such as IP allow-list or authenticated access.
{% endnote %}

### Using the Command Line

1. Make sure to follow the instructions to [deploy Keycloak behind a reverse
   proxy][deploy-behind-reverse-proxy-cli].

2. Enable the health endpoints:
   ```bash
   scalingo --app my-keycloak env-set KC_HEALTH_ENABLED=true
   ```

3. (optional) Choose a port for the management endpoints, which include the
   health endpoints:
   ```bash
   scalingo --app my-keycloak env-set KC_HTTP_MANAGEMENT_PORT=9000
   ```

4. Add a new `upstream` in the `servers.conf.erb` file:
   ```erb
   upstream mgmt {
     server <%= ENV["KEYCLOAK_PRIVATE_DOMAIN"] %>:<%= ENV["KC_HTTP_MANAGEMENT_PORT"] or 9000 %>;
   }
   ```

5. Add a new `location` in the `servers.conf.erb` file:
   ```erb
   <% if ENV["KC_HEALTH_ENABLED"] %>
   location /health {
     proxy_pass       http://mgmt;
     proxy_redirect   default;
   }
   <% end %>
   ```

6. Deploy to Scalingo.

### Using the Terraform Provider

1. Make sure to follow the instructions to [deploy Keycloak behind a reverse
   proxy][deploy-behind-reverse-proxy-tf]

2. Update the `scalingo_app` resource block of the Keycloak app to include a
   new environment variable:
   ```tf
   resource "scalingo_app" "my-keycloak" {
     name           = "my-keycloak"
     project_id     = scalingo_project.keycloak_project.id
     stack_id       = "scalingo-24"

     environment = {
       KC_PROXY_HEADERS  = "xforwarded",
       KC_HTTP_ENABLED   = true,
       KC_HTTP_PORT      = 80,
       KC_HOSTNAME       = "<hostname>",
       KC_HEALTH_ENABLED = true,
       KC_CACHE_EMBEDDED_NETWORK_BIND_ADDRESS = "match-address:10.240.\*",
       KC_BOOTSTRAP_ADMIN_USERNAME = "<admin_username>",
       KC_BOOTSTRAP_ADMIN_PASSWORD = "<admin_password>"
     }
   }
   ```

3. (optional) Update the `scalingo_app` resource block of the Keycloak app to
   set the management interface port:
   ```tf
   resource "scalingo_app" "my-keycloak" {
     name           = "my-keycloak"
     project_id     = scalingo_project.keycloak_project.id
     stack_id       = "scalingo-24"

     environment = {
       KC_PROXY_HEADERS  = "xforwarded",
       KC_HTTP_ENABLED   = true,
       KC_HTTP_PORT      = 80,
       KC_HOSTNAME       = "<hostname>",
       KC_HEALTH_ENABLED = true,
       KC_CACHE_EMBEDDED_NETWORK_BIND_ADDRESS = "match-address:10.240.\*",
       KC_BOOTSTRAP_ADMIN_USERNAME = "<admin_username>",
       KC_BOOTSTRAP_ADMIN_PASSWORD = "<admin_password>",
       KC_HTTP_MANAGEMENT_PORT = 9000
     }
   }
   ```

4. Add a new `upstream` in the `servers.conf.erb` file:
   ```erb
   upstream mgmt {
     server <%= ENV["KEYCLOAK_PRIVATE_DOMAIN"] %>:<%= ENV["KC_HTTP_MANAGEMENT_PORT"] or 9000 %>;
   }
   ```

5. Add a new `location` in the `servers.conf.erb` file:
   ```erb
   <% if ENV["KC_HEALTH_ENABLED"] %>
   location /health {
     proxy_pass       http://mgmt;
     proxy_redirect   default;
   }
   <% end %>
   ```

6. Deploy to Scalingo.


## Exposing Metrics

Keycloak has built-in support for [a metrics endpoint][keycloak-metrics],
available at `/metrics`.

**When enabled**, this endpoint is exposed on the management port, which
defaults to TCP `9000`. **By default, it is not available**, and it must
be explicitely enabled.

Since `web` containers are only allowed to listen to one port, the only way we
have to expose these endpoints consists in:

- Running Keycloak in a Private Network, where the management interface can be
  bound to any port, including the default `9000`.
- Proxying the requests to Keycloak.

This setup is described in [Deploying Keycloak Behind a Reverse
Proxy][deploy-behind-reverse-proxy].

{% note %}
Exposing metrics is oftenly considered a security risk.\\
Please consider completing the configuration samples given below with security
measures such as IP allow-list or authenticated access.
{% endnote %}

### Using the Command Line

1. Make sure to follow the instructions to [deploy Keycloak behind a reverse
   proxy][deploy-behind-reverse-proxy-cli].

2. Enable the metrics endpoint:
   ```bash
   scalingo --app my-keycloak env-set KC_METRICS_ENABLED=true
   ```

3. (optional) Choose a port for the management endpoints, which include the
   metrics endpoint:
   ```bash
   scalingo --app my-keycloak env-set KC_HTTP_MANAGEMENT_PORT=9000
   ```

4. Add a new `upstream` in the `servers.conf.erb` file:
   ```erb
   upstream mgmt {
     server <%= ENV["KEYCLOAK_PRIVATE_DOMAIN"] %>:<%= ENV["KC_HTTP_MANAGEMENT_PORT"] or 9000 %>;
   }
   ```

5. Add a new `location` in the `servers.conf.erb` file:
   ```erb
   <% if ENV["KC_METRICS_ENABLED"] %>
   location /metrics {
     proxy_pass       http://mgmt;
     proxy_redirect   default;
   }
   <% end %>
   ```

6. Deploy to Scalingo.

### Using the Terraform Provider

1. Make sure to follow the instructions to [deploy Keycloak behind a reverse
   proxy][deploy-behind-reverse-proxy-tf]

2. Update the `scalingo_app` resource block of the Keycloak app to include a
   new environment variable:
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
       KC_METRICS_ENABLED = true,
       KC_CACHE_EMBEDDED_NETWORK_BIND_ADDRESS = "match-address:10.240.\*",
       KC_BOOTSTRAP_ADMIN_USERNAME = "<admin_username>",
       KC_BOOTSTRAP_ADMIN_PASSWORD = "<admin_password>"
     }
   }
   ```

3. (optional) Update the `scalingo_app` resource block of the Keycloak app to
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
       KC_METRICS_ENABLED = true,
       KC_CACHE_EMBEDDED_NETWORK_BIND_ADDRESS = "match-address:10.240.\*",
       KC_BOOTSTRAP_ADMIN_USERNAME = "<admin_username>",
       KC_BOOTSTRAP_ADMIN_PASSWORD = "<admin_password>",
       KC_HTTP_MANAGEMENT_PORT = 9000
     }
   }
   ```

4. Add a new `upstream` in the `servers.conf.erb` file:
   ```erb
   upstream mgmt {
     server <%= ENV["KEYCLOAK_PRIVATE_DOMAIN"] %>:<%= ENV["KC_HTTP_MANAGEMENT_PORT"] or 9000 %>;
   }
   ```

5. Add a new `location` in the `servers.conf.erb` file:
   ```erb
   <% if ENV["KC_METRICS_ENABLED"] %>
   location /metrics {
     proxy_pass       http://mgmt;
     proxy_redirect   default;
   }
   <% end %>
   ```

6. Deploy to Scalingo.


[keycloak-healthchecks]: https://www.keycloak.org/observability/health
[keycloak-metrics]: https://www.keycloak.org/observability/configuration-metrics

[deploy-behind-reverse-proxy]: {% post_url platform/getting-started/getting-started-with-keycloak/2000-01-01-deploying-behind-a-reverse-proxy %}
[deploy-behind-reverse-proxy-cli]: {% post_url platform/getting-started/getting-started-with-keycloak/2000-01-01-deploying-behind-a-reverse-proxy %}#using-the-command-line
[deploy-behind-reverse-proxy-tf]: {% post_url platform/getting-started/getting-started-with-keycloak/2000-01-01-deploying-behind-a-reverse-proxy %}#using-the-terraform-provider

