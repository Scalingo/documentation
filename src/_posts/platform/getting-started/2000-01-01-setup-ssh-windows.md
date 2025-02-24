---
title: Setup SSH on Windows
modified_at: 2025-02-14 00:00:00
tags: follow-the-light ssh windows git
index: 5
---

Setup SSH is required to be able to push your code using `git`, to configure
everything correctly, you need to install the terminal `git-bash`

### Download and Install git-bash

You can download git-bash
[here](https://github.com/git-for-windows/git/releases)
and install it by selecting `git-bash` during the installation process.

### Create a new SSH key pair

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

### Add the public SSH key to Scalingo

To get the content of the public SSH key, you need to run the following command
in git-bash:

```bash
$ cat $HOME/.ssh/id_ed25519.pub
```

The file content should start with `ssh-ed25519`

Once you have the public key, go to Scalingo Dashboard [SSH key section](https://dashboard.scalingo.com/account/keys) and
create a new key with the content of the public key.

### Check everything is working

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

If it doesn't, something has been done wrong. 
Ensure your key is loaded in the SSH agent by running:
```bash
$ ssh-add.exe -l
```
If the key is not here, follow the next section to add it to your agent.
Otherwise, please recheck the different step of this guide.

## Add an existing key to your SSH agent

If you already have an SSH key but cannot authenticate, you may need to add it to your SSH agent.

Follow these steps in an admin elevated PowerShell terminal to ensure the SSH agent is running : 
```powershell
Get-Service ssh-agent | Set-Service -StartupType Manual
Start-Service ssh-agent
```

In a terminal windows add your key to the SSH agent:
```bash
ssh-add.exe $HOME/.ssh/id_ed25519
```

In the same terminal verify that the key is loaded : 
```bash
ssh-add -l
```
If your key is correctly listed, you're ready to authenticate.