---
title: Setup SSH on macOS
modified_at: 2025-02-14 00:00:00
tags: follow-the-light ssh macos git
index: 4
---

## Check if you already have an available SSH key

```bash
ls $HOME/.ssh
```

If the files `id_ed25519` and `id_ed25519.pub` are in the `~/.ssh` folder, you don't
need to follow this guide, you already have your SSH key.

However, if you have an SSH key but encounter authentication issues, you may need to add it to your SSH agent.
See the section [Add an existing key to your SSH agent](#add-an-existing-key-to-your-ssh-agent) below.

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

### Managing Multiple SSH Keys

For users with multiple SSH keys, ensure SSH selects the correct key for Scalingo connections by editing your `~/.ssh/config` file (depending on [the region]({% post_url platform/internals/2000-01-01-regions %}) you need to access):

```bash
Host ssh.osc-fr1.scalingo.com
  IdentityFile ~/.ssh/custom_scalingo_key
  IdentitiesOnly yes
```

or

```bash
Host ssh.osc-secnum-fr1.scalingo.com
  IdentityFile ~/.ssh/custom_scalingo_key
  IdentitiesOnly yes
```

Replace `~/.ssh/custom_scalingo_key` with the path to your Scalingo SSH key. No need to reload the SSH configuration, changes are instantaneous.

### Check everything is working

In a terminal, run the following command (depending on [the region]({% post_url platform/internals/2000-01-01-regions %}):

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


If it doesn't, something has been done wrong. 
Ensure your key is loaded in the SSH agent by running:
```bash
$ ssh-add -l
```
If the key is not here, follow the next section to add it to your agent.
Otherwise, please recheck the different step of this guide.

## Add an existing key to your SSH agent

If you already have an SSH key but cannot authenticate, you may need to add it to your SSH agent.
Ensure the SSH agent is running : 
```bash
eval "$(ssh-agent -s)"
```

Configure your SSH key for automatic loading by creating or updating the ~/.ssh/config file and add the below lines :
```bash
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

Add your key to the agent and store it in the macOS keychain:
```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

Verify that the key is loaded:
```bash
ssh-add -l
```
If your key is correctly listed, you're ready to authenticate.