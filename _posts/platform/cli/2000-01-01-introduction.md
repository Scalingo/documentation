---
title: Introduction
modified_at: 2021-10-26 00:00:00
tags: cli interface app
index: 2
---

## Prerequisites

If you created an account on the Scalingo web dashboard by using GitHub authentication, login with
the CLI requires you to take one of these actions:

* Add a password to your account on the [profile](https://my.scalingo.com/profile) page.
* Add a SSH key to your account on the [dedicated](https://my.scalingo.com/keys) page.
* Add a token to your account on the [profile](https://my.scalingo.com/profile) page. Then use it to
  login with `scalingo login --api-token <token>`

### List of Ports Needed To Be Opened

To access all the features of our CLI, some ports must be accessible from the
machine where you want to use the CLI.

If you have a firewall, you need to open these ports for these addresses
so that some features of the CLI can work properly.

To use `git push`, `git pull` and `db-tunnel` features, open this port:

| Region Name     | Address                               | Port | Protocol | 
| --------------- | ------------------------------------- | ---- | -------- |
| osc-fr1         | ssh.osc-fr1.scalingo.com              | 22   | TCP      |
| osc-secnum-fr1  | ssh.osc-secnum-fr1.scalingo.com       | 22   | TCP      |
{: .table }

To use databases command such as `pgsql-console`, open this port:

| Region Name     | Address                               | Port | Protocol | 
| --------------- | ------------------------------------- | ---- | -------- |
| osc-fr1         | one-off.osc-fr1.scalingo.com          | 5000 | TCP      |
| osc-secnum-fr1  | one-off.osc-secnum-fr1.scalingo.com   | 5000 | TCP      |
{: .table }

## Tips

For all subcommands:

* You can use the environment variable `SCALINGO_APP` instead of using the
  `--app` flag
* You can use the flag `--region` or the environment variable `SCALINGO_REGION`
    to let the CLI knows which region to use.
* If your current directory is the base directory of your project and that your
  Git repository has a remote named `scalingo`, you don't need to specify `--app
  <name>`. It will be detected automatically.
* If you want to specify a different remote name, you can do it by using
  `--remote` or `-r` flag followed by the name.
* If you connect to the internet through a proxy, define the standard
  environment variables `HTTP_PROXY` and `HTTPS_PROXY` with your proxy hostname
  and port (e.g.  `http://my-proxy.example.com:1234`).

## Configuration

Update the default region used by the CLI:

```bash
scalingo config --region osc-fr1
```

## Application Detection

We try to detect automatically the name of your application according to:

* `SCALINGO_APP` environment variable
* `-a|--app`     flag of the command line to specify an application name
* `-r|--remote`  flag of the command line to specify a remote Git
* `scalingo` remote of your Git repository
