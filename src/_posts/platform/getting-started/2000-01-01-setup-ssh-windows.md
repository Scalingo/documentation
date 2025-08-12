---
title: Setup SSH on Windows
modified_at: 2023-12-22 00:00:00
tags: follow-the-light ssh windows git
index: 5
---

Setup SSH is required to be able to push your code using `git`, to configure
everything correctly, you need to install the terminal `git-bash`

### 1. Download and Install git-bash

You can download git-bash
[here](https://github.com/git-for-windows/git/releases)
and install it by selecting `git-bash` during the installation process.

### 2. Create a new SSH key pair

Git authentication is based on SSH, so you need to be able to authenticate with
this technology, here is the guide how to do it. The following commands have
to be written and executed in a 'git-bash' terminal, installed in the previous
section.

```bash
$ cd $HOME
$ mkdir .ssh
$ cd .ssh
$ ssh-keygen.exe -t ed25519
```

Follow the instructions to generate a new SSH key pair. You will be asked to
encrypt your private key with a password. This step is optional but for further
security you may want to set one.

### 3. Add the public SSH key to Scalingo

To get the content of the public SSH key, you need to run the following command
in git-bash:

```bash
$ cat $HOME/.ssh/id_ed25519.pub
```

The file content should start with `ssh-ed25519`

Once you have the public key, go to Scalingo Dashboard [SSH key section](https://dashboard.scalingo.com/account/keys) and
create a new key with the content of the public key.

### 4. Check everything is working

Still in a git-bash terminal run the following command:

```bash
$ ssh.exe -T git@ssh.osc-fr1.scalingo.com
```
or
```bash
$ ssh.exe -T git@ssh.osc-secnum-fr1.scalingo.com
```

It should display the following output:

```
You've successfully authenticated on Scalingo, but there is no shell access
```

If it doesn't, something has been done wrong, please recheck the different step
of this guide.
