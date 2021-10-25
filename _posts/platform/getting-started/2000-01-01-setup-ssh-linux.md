---
title: Setup SSH on Linux
modified_at: 2015-04-03 00:00:00
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

### Add the public SSH key to Scalingo

To get the content of the public SSH key, you need to run the following command :

```bash
$ cat ~/.ssh/id_rsa.pub
```

The file content should start with `ssh-rsa`

Once you have the public key, go to Scalingo Dashboard [SSH key section](https://my.scalingo.com/keys) and
create a new key with the content of the public key.

### Check everything is working

Still in a git-bash terminal run the following command:

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

If it doesn't, something has been done wrong please recheck the different step
of this guide.
