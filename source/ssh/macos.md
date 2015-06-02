---
title: Setup SSH on Mac OS
category: getting-started
date: 04/04/2015
tags: tutorial, follow-the-light, ssh, macos, git
---

# Setup SSH on Mac OS

## Check if you already have an available SSH key

```
ls $HOME/.ssh
```

if the files `id_rsa` and `id_rsa.pub` you don't need to follow this guide,
you already have your SSH key.

## Create a new SSH key pair

```
ssh-keygen
```

Follow the instructions to generate a new SSH key pair. You will be asked to encrypt
you private key with a password. This step is optional but for further security you may
want to set one.

By default both private an d public keys will be located in your `$HOME/.ssh` directory.
