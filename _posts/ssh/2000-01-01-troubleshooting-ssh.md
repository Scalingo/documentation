---
title: Troubleshooting Git push and SSH common issues
modified_at: 2016-09-20 00:00:00
category: getting-started
tags: follow-the-light ssh linux git troubleshoot problem connect git push
---

## Prerequisite

At this point we consider you have correctly setup your environment as detailed here:

* [Linux]({% post_url ssh/2015-04-03-setup-ssh-linux %})
* [Mac OS]({% post_url ssh/2015-04-04-setup-ssh-macos %})
* [Windows]({% post_url ssh/2015-04-04-setup-ssh-windows %})

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
using Git for your project. This error mean that there is a Git environment but
no *commit* (Git name for 'version') has been done.

### Solving the problem

You need to make a first commit to your project:

```bash
$ git add .
$ git commit -m "initial commit"
$ git push scalingo master
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

