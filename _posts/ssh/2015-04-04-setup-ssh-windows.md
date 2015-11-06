---
title: Setup SSH on Windows
modified_at: 2015-11-06 10:17:00
category: getting-started
tags: follow-the-light ssh windows git
index: 2
---

To setup SSH on Windows, you will need to generate an ssh key pair using git-bash + `ssh-keygen.exe` and then add it to Scalingo using either [git-bash](https://git-for-windows.github.io/) and [Scalingo CLI](http://cli.scalingo.com/) or [Scalingo Dashboard](https://my.scalingo.com/).

## Install git-bash

You can download git-bash [here](https://github.com/git-for-windows/git/releases/tag/v2.6.2.windows.1) and install it by selecting `git-bash` during the installation process.

## Install Scalingo command-line tool

You can install Scalingo CLI by following [these instructions]({% post_url /cli/2015-09-18-command-line-tool %}).

## Create a new SSH key pair

Then you need to create an ssh key pair in the correct directory.

[git-bash]
{% highlight bash %}
$ cd $HOME
$ mkdir .ssh
$ cd .ssh
$ ssh-keygen.exe -t rsa
{% endhighlight %}

Follow the instructions to generate a new SSH key pair. You will be asked to encrypt
you private key with a password. This step is optional but for further security you may
want to set one.

By default both private and public keys will be located in your current directory, i.e: `$HOME/.ssh`.

## Add ssh key to Scalingo

If you are using [Scalingo CLI](http://cli.scalingo.com/), you can do it by using `scalingo keys-add` command ([See scalingo keys]({% post_url /cli/2015-09-18-command-line-tool %}#setup-your-account-ssh-keys))

{% highlight bash %}
$ scalingo keys-add <key_name> $HOME/.ssh/id_rsa.pub
{% endhighlight %}

And if you are using [Scalingo Dashboard](https://my.scalingo.com):

Just go to [https://my.scalingo.com/apps/keys](https://my.scalingo.com/apps/keys) and create a new key with the content of `id_rsa.pub`.