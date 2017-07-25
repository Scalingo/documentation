---
title: Scalingo VPNC IPSec Addon
modified_at: 2016-03-03 00:00:00
category: addons
tags: vpn addon custom feature
permalink: /addons/vpn/
---

## Introduction

Sometimes, your application may need to reach an infrastructure which
is not opened to the Internet and the only way to access the services
or databases in this infrastructure are to create a VPN connection and
join the private network of this infrastructure.

This addon provides a way to create VPN connections from your application
containers.

## What kind of VPN can it connect to?

Currently, you can connect to a VPN IPSec (Cisco) in mode client-to-site.  The
addon is using the tool `vpnc`, so any VPN compatible with this client will be
working correctly.

## Setup of the addon

### Provision the addon

First, you need to provision the add to your application. This can be done
through the dashboard or with our command line tool.

```bash
scalingo -a appname addons-add scalingo-vpn-ipsec vpn-ipsec-standard
```

### Setup the configuration

From the addon tab of your dashboard, click on 'Link to Dashboard' under the
VPN addon icon. You'll arrive on the dashboard of the VPN IPSec addon. It
contains a text area in which you've to write your `vpnc.conf` file.

Usually such configuration file looks like this:

```bash
IPSec gateway [server]
IPSec ID [VPN group]
IPSec secret [shared secret]
Xauth username [username]
Xauth password [password]
```

Once you've validated the configuration, the environment variable
`SCALINGO_VPNC_CONF` will be added to your application, the app will be
restarted. You'll be able to see in the logs:

```bash
2016-02-03 13:59:31.321065492 +0100 CET [web-1] -----> Starting VPN connection
2016-02-03 13:59:31.321223270 +0100 CET [web-1] -----> VPNC started in background (pid: 70)...
```

### Forbidden configuration

The configuration instruction `Script` is forbidden

## Q&A

- What happen if the connection is cut?

A connection problem will be detected immediately and we'll attempt a
reconnection instantly. If the reconnection fails because of a problem from
your infrastructure, we'll try to reconnect every 30 seconds.

- Can I setup site-to-site VPN?

No, currently site-to-site VPN is not compatible with this addon, it
is only working in client-to-site mode.

- What happens if the connection fail, will my app be unavailable?

No, it will be written in the logs that we have not been able to connect your
container to your VPN, but your application will be started correctly.  You
should check the configuration and ensure all the fields are correct.

- Where can I find an comprehensive documentation of the `vpnc.conf` file?

The [Ubuntu
manpage](http://manpages.ubuntu.com/manpages/trusty/man8/vpnc-connect.8.html)
about vpnc contains all the properties which can be set in the configuration
file.
