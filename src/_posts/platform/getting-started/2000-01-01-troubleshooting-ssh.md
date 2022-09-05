---
title: Troubleshooting Git push and SSH common issues
nav: Troubleshoot Git and SSH
modified_at: 2022-09-02 00:00:00
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
error: failed to push some refs to 'git@ssh.osc-fr1.scalingo.com:APP_NAME.git'
```

When we tell you to run `git push scalingo master`, we consider you are already
using Git for your project. This error means that there is a Git environment but
no *commit* (Git name for 'version') has been done on the `master` branch.

### Solving the problem

You need to make a first commit on the `master` or `main` branch of your project:

```bash
git add .
git commit -m "initial commit"
git push scalingo master
# OR
git push scalingo main
```

If the branch named `master` or `main` does not exist you need to create one:
```bash
git checkout -B master
# OR
git checkout -B main
```

If you are using another branch name than `master` or `main` branches you can
use one of the following commands to push your branch:
```bash
git push scalingo mybranch:master
# OR
git push scalingo mybranch:main
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

```bash
ssh-keygen -l -f public_key_file
```

For example, if your key looks like:

```plaintext
---- BEGIN SSH2 PUBLIC KEY ----
Comment: "Name of the key"
AAAAB3NzaC1yc2EAAAABJQAAAgEAvHiFU0R8sWBT1dsKMW7HsEHta5adFei0J1AR
qtGbaALDJnKzK0Ihf9YxlIt1kHGtN6pXOiIj8DClb8YcLeVRIoe63BE0GXtFebdO
[...]
```

After converting to SSH format, it should look like:

```plaintext
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

```bash
#!/usr/bin/bash

exec ssh -i $HOME/.ssh/path-to-alternative-key $@
```

Then, to push with this second key:

```bash
GIT_SSH=$HOME/.ssh/scalingo-personal.sh git push scalingo master
```

Then Git will correctly used authenticate using the second alternative key
authenticating the second account.

* It is your only account

Please reach the support which will investigate the reason why your key is
considered already used.

## git push error: `Permission denied (public key)`

A `Permission denied (public key)` error means that the server rejected your connection.
There could be several reasons why, and the most common examples are explained below.

### Check that you are connecting to the right server

Typing is hard, we all know it. Pay attention to what you type.
You won't be able to connect to `ssh.osc-fr1.scalungo.com` or `ssh.scalingo.com`.

In some cases, a corporate network may cause issues resolving the DNS record as well.

You can also check that the key is being used by trying to connect to Scalingo SSH server.

Example with `osc-fr1` region:
```bash
$ ssh -vT git@ssh.osc-fr1.scalingo.com
OpenSSH_8.2p1 Ubuntu-4ubuntu0.4, OpenSSL 1.1.1f  31 Mar 2020
debug1: Reading configuration data /home/USERNAME/.ssh/config
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: Connecting to ssh.osc-fr1.scalingo.com [171.33.103.138] port 22.
debug1: Connection established.
```

### Check that you are connecting with a key

You can also check that the key is being used by trying to connect to Scalingo servers.

In that example, we did not have any keys for SSH to use:
```bash
$ ssh -vT git@ssh.osc-fr1.scalingo.com
...
debug1: identity file /home/USERNAME/.ssh/id_rsa type -1
debug1: identity file /home/USERNAME/.ssh/id_rsa-cert type -1
...
debug1: Authentications that can continue: publickey
debug1: Next authentication method: publickey
debug1: Trying private key: /home/USERNAME/.ssh/id_rsa
debug1: No more authentication methods to try.
Permission denied (publickey).
```

The "-1" at the end of the `identity file` lines means SSH couldn't find a file to use.

Later on, the `Trying private key` lines also indicate that no file was found.

If a file existed, those lines would be "1" and `Offering public key`, respectively:
```bash
$ ssh -vT git@ssh.osc-fr1.scalingo.com
...
debug1: identity file /home/USERNAME/.ssh/id_rsa type 1
...
debug1: Authentications that can continue: publickey
debug1: Next authentication method: publickey
debug1: Offering RSA public key: /home/USERNAME/.ssh/id_rsa
```

### Always use the `git` user

All connections, including those for remote URLs, must be made as the `git` user.

If you try to connect with your Scalingo username, it will fail:
```bash
$ ssh -T SCALINGO_USERNAME@ssh.osc-fr1.scalingo.com
SCALINGO_USERNAME@ssh.osc-fr1.scalingo.com: Permission denied (publickey).
```

### Make sure you have a key that is being used

Verify that you have a private key generated and loaded into the SSH agent:
```bash
$ ssh-add -l -E sha256
2048 SHA256:274ffWxgaxq/tSINAykStUL7XWyRNcRTlcST1Ei7gBQ /home/USERNAME/.ssh/id_rsa (RSA)
```

The `ssh-add` command should print out a long string of numbers and letters.
If it does not print anything, you will probably need to generate a new SSH key
and upload it on Scalingo.

### Verify the public key is attached to your Scalingo account

You must provide your public key to Scalingo to establish a secure connection,
authenticate you and check if you have access to the application.

Get the fingerprint of your SSH key.

- If you're using OpenSSH 6.7 or older:

```bash
$ ssh-add -l
2048 a0:dd:42:3c:5a:9d:e4:2a:21:52:4e:78:07:6e:c8:4d /home/USERNAME/.ssh/id_rsa (RSA)
```

- If you're using OpenSSH 6.8 or newer:

```bash
$ ssh-add -l -E md5
2048 MD5:a0:dd:42:3c:5a:9d:e4:2a:21:52:4e:78:07:6e:c8:4d /home/USERNAME/.ssh/id_rsa (RSA)
```

Go to the [Dashboard > User settings > SSH Keys]({% post_url platform/account/2000-01-01-manage %}#ssh-keys)
page and check if the fingerprint is the same as the output of the previous command.


### RSA SHA-1 algorithm deprecated on recent version of OpenSSH

If you see this error: `no mutual signature algorithm` from the debug
log of a `git push` you're using OpenSSH 8.2 or newer.

The `RSA SHA-1` hash algorithm is being quickly deprecated from SSH clients
like OpenSSH because of various security vulnerabilities, with many of these
technologies now outright denying the use of this algorithm.

#### Workaround

In order to re-enable `ssh-rsa` support, you need to add the following lines
into the SSH configuration file `~/.ssh/config`:
```plaintext
Host ssh.osc-fr1.scalingo.com
  PubkeyAcceptedKeyTypes +ssh-rsa
```

#### Resolution

To fully resolve this issue, Scalingo recommends you to generate a new SSH key
using a supported and more secure algorithm such as `ECDSA` and `ED25519`.

See our `Create a new SSH key pair` documentation pages here:
- For [Linux]({% post_url platform/getting-started/2000-01-01-setup-ssh-linux %}#create-a-new-ssh-key-pair)
- For [Mac OS]({% post_url platform/getting-started/2000-01-01-setup-ssh-macos %}#create-a-new-ssh-key-pair)
- For [Windows]({% post_url platform/getting-started/2000-01-01-setup-ssh-windows %}#2-create-a-new-ssh-key-pair)
