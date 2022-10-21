---
title: Setup SSH on Linux
modified_at: 2022-01-06 00:00:00
tags: follow-the-light ssh linux git
index: 3
---

## Check if you already have an available SSH key

```bash
ls ~/.ssh
```

If the files `id_ed25519` and `id_ed25519.pub` are in the `~/.ssh` folder, you don't
need to follow this guide, you already have your SSH key.

## Create a new SSH key pair

```bash
ssh-keygen -t ed25519
```

Follow the instructions to generate a new SSH key pair. You will be asked to encrypt
your private key with a password. This step is optional but for further security you may
want to set one.

By default, both private and public keys will be located in your `$HOME/.ssh` directory.

### Add the public SSH key to Scalingo

To get the content of the public SSH key, you need to run the following command:

```bash
$ cat ~/.ssh/id_ed25519.pub
```

The file content should start with `ssh-ed25519`

Once you have the public key, go to Scalingo Dashboard [SSH key section](https://dashboard.scalingo.com/account/keys) and
create a new key with the content of the public key.

### Check everything is working

In a terminal, run the following command (depending on [the region](https://doc.scalingo.com/platform/internals/regions) you need to access):

```bash
$ ssh -T git@ssh.osc-fr1.scalingo.com
```

or

```bash
$ ssh -T git@ssh.osc-secnum-fr1.scalingo.com
```

It should display the following output:

```
You've successfully authenticated on Scalingo, but there is no shell access
```

If it doesn't, something has been done wrong. Please recheck the different step
of this guide.
