---
title: Troubleshooting git push and SSH common issues
modified_at: 2016-09-20 00:00:00
category: getting-started
tags: follow-the-light ssh linux git troubleshoot problem connect git push
---

## Prerequisite

At this point we consider you have correctly setup your environment as detailed here:

* [Linux]({% post_url ssh/2015-04-03-setup-ssh-linux %})
* [Mac OS]({% post_url ssh/2015-04-04-setup-ssh-macos %})
* [Windows]({% post_url ssh/2015-04-04-setup-ssh-windows %})

## GIT authentication error: `Please make sure you have the correct access rights`

If when pushing to the platform, you get the following error

```bash
$ git push scalingo master
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

It means you are **not authenticated** or you do not have the right to push on this
app.

### Solving the problem

Please redo the tutorial from operating system, you have not configured your system
correctly.

## GIT push error: `error: src refspec master does not match any`

```bash
$ git push scalingo master
error: src refspec master does not match any.
error: failed to push some refs to 'git@scalingo.com:appname.git'
```

When we tell you to run `git push scalingo master`, we consider you are already
using GIT for your project. This error mean that there is a git environment but
no *commit* (git name for 'version') has been done.

### Solving the problem

You need to make a first commit of your project:

```bash
$ git add .
$ git commit -m "initial commit"
$ git push scalingo master
```

## Invalid SSH key error when adding it to account

The platform is expecting SSH keys to be in the OpenSSH format. This is the default
format when a SSH keypair is generated on *Linux* or *MacOS*, however on Windows, if
you've generated your key with `PuTTy`, there are chances the format is wrong.

### Solving the problem

There are two methods to solve this issue:

1. Windows only - PuTTy Key generator tool

Using PuTTY Key generator tool also named `PuTTyGen`, you can import
your SSH key and convert it to the OpenSSH format.

2. All platforms: Using ssh-keygen tool

By using the following command:

```
ssh-keygen -l -f public_key_file
```

It will automatically convert it to OpenSSH format.

Example, your key looks like:

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

This key will be accepted by the platform.

