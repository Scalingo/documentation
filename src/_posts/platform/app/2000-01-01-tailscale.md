---
layout: page
title: Configure Tailscale
modified_at: 2026-01-05 00:00:00
tags: tailscale networking vpn buildpack
---

[Tailscale](https://tailscale.com/) is a zero-config VPN that creates a secure network between your servers, computers, and cloud instances. This guide explains how to connect your application container on Scalingo to your Tailscale network.

## Prerequisites

* A Tailscale account.
* A [Tailscale Auth Key](https://tailscale.com/kb/1085/auth-keys/).

## Step 1: Multi-buildpack Configuration

To install Tailscale and your application dependencies, you need to use the [multi-buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-multi %}).

Create or update the `.buildpacks` file at the root of your repository:

```text
https://github.com/Scalingo/apt-buildpack.git
# Add any other buildpack required to build your application (e.g. scalingo/nodejs, scalingo/ruby, etc.)
```

## Step 2: Aptfile Configuration

The [APT buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-apt %}) allows you to install additional packages. Create a file named `Aptfile` at the root of your repository with the following content:

```text
wget
curl
tailscale
:repo:deb [trusted=yes] https://pkgs.tailscale.com/stable/ubuntu [dist] main
```

Replace `[dist]` with the codename of the [stack]({% post_url platform/internals/stacks/2000-01-01-stacks %}) you are using:
* `noble` for `scalingo-24` (default)
* `jammy` for `scalingo-22`
* `focal` for `scalingo-20`

## Step 3: Set TAILSCALE_AUTHKEY Environment Variable

You need to provide your Tailscale Auth Key to your application via an [environment variable]({% post_url platform/app/2000-01-01-environment %}).

1. Generate an auth key in your [Tailscale admin console](https://login.tailscale.com/admin/settings/keys).
2. Set the `TAILSCALE_AUTHKEY` environment variable on your Scalingo application:

```bash
scalingo --app my-app env-set TAILSCALE_AUTHKEY=tskey-auth-ok...
```

## Step 4: .profile Configuration

The `.profile` script is executed before your application starts ([see dedicated page]({% post_url platform/internals/2000-01-01-container-management %}#the-profile-script)). It will be used to start the Tailscale daemon and connect to your network.

Create a file named `.profile` at the root of your repository:

```bash
#!/bin/bash
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --socket /tmp/tailscaled.sock &
tailscale --socket /tmp/tailscaled.sock up --auth-key=$TAILSCALE_AUTHKEY
```

## Step 5: Deploy Your Application

Deploy your application by pushing your changes to Scalingo:

```bash
git add .buildpacks Aptfile .profile
git commit -m "Configure Tailscale"
git push scalingo master
```

During the deployment, you should see:
* The installation of Tailscale in the deployment logs.
* The connection to Tailscale in the application logs.
* Your Scalingo application appearing in your [Tailscale console](https://login.tailscale.com/admin/machines).

## Step 6: Test the Connection

You can verify the connection by running a [one-off container]({% post_url platform/app/2000-01-01-tasks %}).

1. Start a one-off container:
   ```bash
   scalingo --app my-app run bash
   ```

2. In the container, set the `ALL_PROXY` environment variable to use the local Tailscale proxy:
   ```bash
   export ALL_PROXY=socks5://localhost:1055/
   ```

3. Test the connection to another service in your Tailscale network:
   ```bash
   curl [host]:[port]/_health
   ```

{% note %}
The `ALL_PROXY` environment variable directs software that respects it (like `curl`) to use the local SOCKS5 proxy provided by Tailscale.
{% endnote %}
