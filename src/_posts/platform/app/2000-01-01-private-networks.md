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
