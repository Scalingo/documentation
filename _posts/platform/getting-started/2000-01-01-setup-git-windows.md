---
title: Setup Git on Windows
modified_at: 2017-08-09 11:00:00
tags: git windows
---

Git is a version control system really useful for tracking changes in computer files and coordinating work on those files among multiple people.

## Installation on Windows

To install Git on Windows you have to download [Git for Windows](https://git-for-windows.github.io/).

Once the installation is complete, you will need SSH as well. Take a look at [Setup SSH on Windows]({% post_url platform/getting-started/2000-01-01-setup-ssh-windows %}).

## Git Setup

To setup Git you will use the command `git config`. More informations can be found in [https://git-scm.com/](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup).

### Configure your Identity

Your identity (user name and email) must be configured:

```bash
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
```

The `--global` option will configure your Git durably. If for one project you want to configure another user name or email you have to run the same command without `--global`.

### Configure your Editor

For example if you want to change your default text editor to Nodepad++, the command is:

On a x86 system

```bash
git config --global core.editor "'C:/Program Files/Notepad++/notepad++.exe' -multiInst -nosession"
```

On a x64 system

```bash
git config --global core.editor "'C:/Program Files (x86)/Notepad++/notepad++.exe' -multiInst -nosession"
```

### Check the Settings

To check your settings the command is `git config --list`.


```bash
git config --list
```

It will return something like:

```bash
user.name=John Doe
user.email=johndoe@example.com
color.status=auto
color.branch=auto
color.interactive=auto
color.diff=auto
```
