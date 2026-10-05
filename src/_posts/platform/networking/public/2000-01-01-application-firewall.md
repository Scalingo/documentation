---
title: Application Firewall
nav: Application Firewall
modified_at: 2026-10-05 00:00:00
tags: networking firewall ipv4 access
index: 40
---

***Application Firewall*** is a feature that, once configured, restricts public HTTP and HTTPS access to an application
based on allowed IPv4 CIDR ranges. Scalingo's routers check the source IP address
before forwarding a request to the application's `web` containers.

## How the Firewall Works

Each firewall rule **allows access** from an IPv4 range. A request only needs to
match one rule to be allowed.

| Configuration     | Request source IP                  | Result                                                       |
| ----------------- | ---------------------------------- | ------------------------------------------------------------ |
| No rules          | Any IP                             | The firewall is disabled and does not restrict public access |
| One or more rules | Matches at least one allowed range | The firewall allows the request                              |
| One or more rules | Matches none of the allowed ranges | The router returns HTTP `403 Forbidden`                      |

Adding the first rule restricts public access to the allowed ranges. Deleting
the last rule restores access from any source IP once the change takes effect.

### Traffic and Source IP

The same rules apply to the application's default Scalingo domain and all its
custom domains.

Only public HTTP and HTTPS traffic to `web` containers is filtered. Traffic
exposed through the [TCP addon][tcp-addon] is not filtered.

Traffic through [Private Networks][private-networks] is unaffected. Requests
using the application's public route remain subject to firewall rules, even
when they come from another Scalingo application.

The firewall checks the IP address that opens the TCP connection to the router.
It does not use HTTP headers such as `X-Forwarded-For` to decide whether access
is allowed. When requests pass through a proxy, allow the proxy's outbound
IP addresses.

{% note %}
Application Firewall filters source IP addresses. It is not a Web Application
Firewall (WAF): it does not inspect HTTP content to detect attacks such as SQL
injection, or provide anti-bot protection.
{% endnote %}

### Rule Format and Limits

- Each rule has an ID, an IPv4 range in CIDR notation, and an optional label.
- Use a range such as `203.0.113.0/24`, or `/32` for a single address, such as
  `203.0.113.42/32`. Addresses without a CIDR suffix are not accepted.
- Incoming IPv6 traffic is currently not supported.
- Each application can have up to 20 rules by default. This limit can be changed
  by Scalingo support.

## Managing Firewall Rules

Collaborators can view, add, and remove firewall rules. Limited Collaborators
can only view them.

Rule additions and deletions appear in the application's **Activity**, with
the user who performed the action, regardless of the interface used.

You can manage rules through the Dashboard, the [CLI][cli-firewall], the
[API][api], or the [Terraform Provider][terraform-provider]. To change a rule,
remove it and add a new one. To disable the firewall, delete all its rules.

{% note %}
Adding or removing a rule can take several minutes to take effect. 
The previous firewall configuration remains active until then.
{% endnote %}

### Using the Dashboard

**Firewall enabled** means at least one rule exists. **Firewall disabled** means
no rules exist. This indicator does not report whether changes have propagated
to the routers.

To add a rule:

1. From your web browser, open your [dashboard]
2. Click on the application for which you want to add a firewall rule
3. Click on the **Settings** tab
4. From the **Settings** sub-menu, select **Public Routing**
5. Locate the **Firewall rules** block
6. In the **IP Range** field, enter the IPv4 range to allow in CIDR notation,
   for example `203.0.113.42/32`
7. Optionally, enter a label in the **Label** field, for example `Office VPN`
8. Click the **Save** button

To remove a rule from the same **Firewall rules** block:

1. Locate the rule you want to remove by its IP range or label
2. Use the delete action for that rule

Deleting the last rule disables the firewall and restores public access from
any source IP once the change takes effect.

### Using the CLI

List the current rules, including their IDs and labels:

```bash
scalingo --app my-app app-firewall-rules
```

Allow access from a single IPv4 address:

```bash
scalingo --app my-app app-firewall-rule-add --cidr 203.0.113.42/32 --label office
```

Remove a rule using its ID:

```bash
scalingo --app my-app app-firewall-rule-remove '<rule-id>'
```

Replace `my-app` with your application's name and `<rule-id>` with the ID
returned by `app-firewall-rules`.

## Common Use Cases

### Restricting Access to a VPN

Allow the VPN's public outbound IPv4 addresses. Users must route their requests
to the application through that VPN. To restrict public access to the VPN,
allow only its outbound addresses: any other allowed range also grants access.

### Allowing Cloudflare Traffic

To require public incoming requests to your application to pass through Cloudflare:
  - Add one rule for each [Cloudflare proxy IPv4 range][cloudflare-ips] in your Application Firewall allowlist
  - Make sure to only allow these ranges, so that any other source is rejected
  - Keep the allowlist in sync with Cloudflare's published IP ranges

{% warning %}
Cloudflare's proxy IP ranges are shared across its customers. Allowing these
ranges does not restrict access to your Cloudflare account.
{% endwarning %}

### Allowing Other Scalingo Applications

Applications in the same project can use [private routing][private-networks],
which is unaffected by Application Firewall.

For connections through the public route, including from other projects,
allow the [egress IPv4 addresses][egress] of each source region.

{% warning %}
Scalingo's egress IP addresses are shared. Allowing them grants access to all
applications using those addresses, including other customers' applications.
It does not restrict access to a specific application, project, or account.
{% endwarning %}

### Allowing Webhooks and External Monitoring

When a webhook provider or monitoring service calls your application over the
Internet, its connection source IP must match an allowed range. Add the
service's outbound IPv4 ranges to keep receiving these requests after enabling
the firewall.

## Firewall Rules for Review Apps

[Review Apps][review-apps] copy their parent's firewall rules at creation.
Later changes to the parent's rules are not synchronized to existing Review
Apps.

The `firewall_rules` setting in `scalingo.json` can replace the inherited rules
or disable the firewall for a Review App. It is read only at creation;
subsequent deployments do not update the rules from this setting.

See [Application Firewall configuration in the manifest][manifest-firewall]
for the configuration and JSON examples.

## Identifying Blocked Requests

Blocked requests receive an HTTP `403 Forbidden` response with a standard
Scalingo error page. They are not forwarded to an application container.

Enable router logs to see blocked requests in your [application logs][logs]:

```bash
scalingo --app my-app router-logs --enable
```

A firewall rejection has both `status=403` and `container=false`. For example,
the relevant fields are:

```text
container=false status=403
```

The `container=false` field indicates that no target container was selected.
It distinguishes a firewall rejection from an HTTP 403 returned by your
application; `status=403` alone does not.

## Customizing the Access Denied Page

Set the `SCALINGO_FORBIDDEN_PAGE_URL` environment variable to the URL of your
custom error page. See [Custom Error and Maintenance Pages][custom-error-pages]
for configuration requirements and restart instructions.


*[CIDR]: Classless Inter-Domain Routing

[dashboard]: https://dashboard.scalingo.com/
[private-networks]: {% post_url platform/networking/private/2000-01-01-overview %}
[tcp-addon]: {% post_url addons/tcp-gateway/2000-01-01-start %}
[cli-firewall]: {% post_url tools/cli/2000-01-01-features %}#manage-application-ip-firewall-rules
[api]: https://developers.scalingo.com/
[terraform-provider]: {% post_url tools/2000-01-01-terraform-provider %}
[cloudflare-ips]: https://www.cloudflare.com/ips/
[egress]: {% post_url platform/networking/public/2000-01-01-egress %}
[review-apps]: {% post_url platform/app/2000-01-01-review-apps %}
[manifest-firewall]: {% post_url platform/app/2000-01-01-app-manifest %}#configuration-of-the-application-firewall
[logs]: {% post_url platform/app/2000-01-01-logs %}
[custom-error-pages]: {% post_url platform/app/2000-01-01-custom-error-page %}
