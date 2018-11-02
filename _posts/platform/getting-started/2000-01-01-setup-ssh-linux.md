---
title: Setup SSH on Linux
tags: follow-the-light ssh linux git
index: 3
---

## Check if you already have an available SSH key

```bash
ls ~/.ssh
```

If the files `id_rsa` and `id_rsa.pub` are in the `~/.ssh` folder, you don't
need to follow this guide, you already have your SSH key.

## Create a new SSH key pair

```bash
ssh-keygen
```

Follow the instructions to generate a new SSH key pair. You will be asked to encrypt
you private key with a password. This step is optional but for further security you may
want to set one.

By default both private and public keys will be located in your `$HOME/.ssh` directory.
