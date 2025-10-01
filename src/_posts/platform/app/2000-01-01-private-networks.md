---
title: Private Networks
modified_at: 2025-09-25 00:00:00
tags: app private networks vxlan encryption wireguard
index: 100
---

{% warning %}
This feature is currently beta preview only available for some customers. If you are interested in taking part to the beta, please contact the Scalingo support.
{% endwarning %}

With Private Networks, Scalingo offers the ability to group applications inside a private network. It protects these applications so that they are not reachable by a resource from outside the private network. It also adds encryption for the communications between the applications inside the private network.

Inside a private network, all the containers can communicate with TCP or UDP on any ports.

## How Do I Protect My Application With a Private Network?

Here is the process to take part to the private network beta:
- Contact our support team to show your interest in the beta
- Read and accept the Beta special terms agreement.
- Create an [empty project](https://doc.scalingo.com/platform/projects/overview) and notify the support about its name.
- 🚀 After the support enabled private network on your project, you can migrate applications into the project or create new ones inside it. All these applications are protected inside a private network.

{% note %}
Note that HDS applications do NOT have access to the feature.
{% endnote %}

## Domain Names

In order to reference the containers in private networks, domain names are created to ease the interaction between them. A domain name may be composed of the <span class="domain-name-ct">container type</span>, the <span class="domain-name-ap">application ID</span>, the <span  class="domain-name-pn">private network ID</span> and a common <span class="domain-name-nid">internal network identifier</span> (<code class="domain-name-nid">private-network.internal</code>).

Here are some examples with an
application <code class="domain-name-ap">ap-a71da13f-7c70-4c00-a644-eee8558d8053</code> and a
private network <code class="domain-name-pn">pn-ad0fd6a1-d05e-40ea-bf63-c4f8a75a9d8c</code>:

* <code><span class="domain-name-ap">ap-a71da13f-7c70-4c00-a644-eee8558d8053</span>.<span class="domain-name-pn">pn-ad0fd6a1-d05e-40ea-bf63-c4f8a75a9d8c</span>.<span class="domain-name-nid">private-network.internal.</span></code>:

  DNS A records to the `web` containers. `web` containers are the default ones one contacts when using the application domain name.

* <code><span class="domain-name-ct">web</span>.<span class="domain-name-ap">ap-a71da13f-7c70-4c00-a644-eee8558d8053</span>.<span class="domain-name-pn">pn-ad0fd6a1-d05e-40ea-bf63-c4f8a75a9d8c</span>.<span class="domain-name-nid">private-network.internal.</span></code>:

  DNS A records to the `web` containers.

* <code>1.<span class="domain-name-ct">web</span>.<span class="domain-name-ap">ap-a71da13f-7c70-4c00-a644-eee8558d8053</span>.<span class="domain-name-pn">pn-ad0fd6a1-d05e-40ea-bf63-c4f8a75a9d8c</span>.<span class="domain-name-nid">private-network.internal.</span></code>:

  DNS A record to the first `web` container.

* <code><span class="domain-name-ct">worker</span>.<span class="domain-name-ap">ap-a71da13f-7c70-4c00-a644-eee8558d8053</span>.<span class="domain-name-pn">pn-ad0fd6a1-d05e-40ea-bf63-c4f8a75a9d8c</span>.<span class="domain-name-nid">private-network.internal.</span></code>:

  DNS A records to the `worker` containers.

* <code>1.<span class="domain-name-ct">worker</span>.<span class="domain-name-ap">ap-a71da13f-7c70-4c00-a644-eee8558d8053</span>.<span class="domain-name-pn">pn-ad0fd6a1-d05e-40ea-bf63-c4f8a75a9d8c</span>.<span class="domain-name-nid">private-network.internal.</span></code>:

  DNS A record to the first `worker` container.

These domain names can be infered by knowing the application ID, the private network ID and the application formation or you can list them using [Scalingo CLI]({% post_url tools/cli/2000-01-01-start %}):

```
scalingo --app my-app private-networks-domain-names
```

## Known Limitations

## Typical Use Cases

### A Web Application Firewall To Protect the Web Containers

A typical use case would be to deploy a backend application that is protected behind a Web Application Firewall (WAF). You may want to completely hide the backend application so that it's unreachable from outside the private network. That way, the traffic must go through the WAF before reaching your backend application.

In this section we explain the different steps to achieve this kind of architecture with private network.

1. You first need to create the backend application inside the project with private network enabled.
2. This application will be web-less. You must first scale down the `web` containers by following [these steps]({% post_url platform/app/2000-01-01-web-less-app %}).
3. Then deploy an application which listens on the TCP port you want (e.g. 3000). The [`Procfile`]({% post_url platform/app/2000-01-01-procfile %}) must name its process with a different name than `web` (e.g. `my-app-backend`).

At this point, you have a backend application that you cannot query with the public domain name provided by Scalingo (e.g. `my-app.osc-fr1.scalingo.io`).

We will now deploy the Web Application Firewall in charge of filtering and forwarding the requests to the backend application. This application is a [Nginx with ModSecurity]({% post_url platform/getting-started/2000-01-01-getting-started-with-modsecurity %}). Your `nginx.conf` configuration file would look like:

```nginx
location / {
  proxy_pass http://my-app-backend.ap-uuid.pn-uuid.private-network.internal:3000;
  proxy_redirect default;
}
```

With `my-app-backend.ap-uuid.pn-uuid.private-network.internal` the domain name of your backend containers.

After deploying the application, one can query the Nginx with the public domain name and access the backend application.
