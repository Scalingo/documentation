---
title: Troubleshooting Git push and SSH common issues
nav: Troubleshoot Git and SSH
modified_at: 2018-03-05 00:00:00
tags: follow-the-light ssh linux git troubleshoot problem connect git push
index: 2
---

## Prerequisite

At this point we consider you have correctly setup your environment as detailed here:

* [Linux]({% post_url platform/getting-started/2000-01-01-setup-ssh-linux %})
* [Mac OS]({% post_url platform/getting-started/2000-01-01-setup-ssh-macos %})
* [Windows]({% post_url platform/getting-started/2000-01-01-setup-ssh-windows %})

## Git authentication error: `Please make sure you have the correct access rights`

When pushing to the platform, if you get the following error:

```bash
$ git push scalingo master
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

It means you are **not authenticated** or you do not have the right to push on this
app.

### Solving the problem

Please redo the "Setup SSH" tutorial for your operating system. You have not configured your system
correctly.

## Git push error: `error: src refspec master does not match any`

```bash
$ git push scalingo master
error: src refspec master does not match any.
error: failed to push some refs to 'git@scalingo.com:appname.git'
```

When we tell you to run `git push scalingo master`, we consider you are already
using Git for your project. This error means that there is a Git environment but
no *commit* (Git name for 'version') has been done on the `master` branch.

### Solving the problem

You need to make a first commit on the `master` branch of your project:

```bash
$ git add .
$ git commit -m "initial commit"
$ git push scalingo master
```

If the branch named `master` does not exist (default branch may be named `main`) you need to create one:

```bash
git branch master
git checkout master
```

## Invalid SSH key error when adding it to account

The platform is expecting SSH keys to be in the OpenSSH format. This is the default
format when a SSH key pair is generated on *Linux* or *MacOS*. However on Windows, if
`PuTTY` generated your key, there are chances the format is wrong.

### Solving the problem

There are two methods to solve this issue:

1. Windows only - PuTTY Key generator tool

Using PuTTY Key generator tool also named `PuTTYGen`, you can import
your SSH key and convert it to the OpenSSH format.

2. All platforms - Using ssh-keygen tool

Using the following command, will automatically convert your key to the OpenSSH format:

```
ssh-keygen -l -f public_key_file
```

For example, if your key looks like:

```
---- BEGIN SSH2 PUBLIC KEY ----
Comment: "Name of the key"
AAAAB3NzaC1yc2EAAAABJQAAAgEAvHiFU0R8sWBT1dsKMW7HsEHta5adFei0J1AR
qtGbaALDJnKzK0Ihf9YxlIt1kHGtN6pXOiIj8DClb8YcLeVRIoe63BE0GXtFebdO
[...]
```

After converting to ssh format, it should look like:

```
ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgEAvHiFU0R8sWBT1dsKMW7[...]
```

The latter will be accepted by the platform.

## Invalid SSH key error: key is already taken

SSH key pairs are used as authentication credentials for an account. It let us
authenticate the user who is deploying an application using the `git push`
command. As it is required for account authentication, SSH keys are unique: the
same public key can't be associated with multiple accounts.

### Solving the problem

* You have multiple accounts (ie. professional/personal)

In this case, the **simplest way is the account owning the key is either owner
or collaborator** with all the applications you want to deploy.

An alternative method is to create a second key for the second account, modify
how Git is using ssh to connect to the remote server (Linux/MacOS only):

Define a wrapper script, in `$HOME/.ssh/scalingo-personal.sh` with the following content:

```
#!/usr/bin/bash

exec ssh -i $HOME/.ssh/path-to-alternative-key $@
```

Then, to push with this second key:

```
GIT_SSH=$HOME/.ssh/scalingo-personal.sh git push scalingo master
```

Then Git will correctly used authenticate using the second alternative key
authenticating the second account.

* It is your only account

Please reach the support which will investigate the reason why your key is
considered already used.
