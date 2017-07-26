---
title: Setup SSH on Linux
modified_at: 2015-04-03 00:00:00
category: getting-started
tags: follow-the-light ssh linux git
index: 2
---

## Check if you already have an available SSH key

```bash
ls ~/.ssh
```

if the files `id_rsa` and `id_rsa.pub` you don't need to follow this guide,
you already have your SSH key.

## Create a new SSH key pair

```bash
ssh-keygen
```

Follow the instructions to generate a new SSH key pair. You will be asked to encrypt
you private key with a password. This step is optional but for further security you may
want to set one.

By default both private an d public keys will be located in your `$HOME/.ssh` directory.
