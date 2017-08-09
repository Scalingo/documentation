---
title: Setup Git on Windows
modified_at: 2017-08-09 11:00:00
category: getting-started
tags: git windows
---

Git is a version control system really useful for tracking changes in computer files and coordinating work on those files among multiple people. 

## Installation on Windows

To install Git on Windows you have to download an exe file that you will find [here](https://git-for-windows.github.io/). To begin the download directly you can click [here](http://git-scm.com/download/win).

You will find an useful SSH, see our page [Setup SSH on Windows]({% post_url ssh/2015-04-04-setup-ssh-windows %}), and the standard graphic interface.

## Git Setup

To setup Git you will use the tool `git config`, there are more informations on the site [https://git-scm.com/](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup).

### Config your Identity

At the first time you have to config your user name and your user email.

```bash
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
```

The `--global` option will config your Git durably. If for one project you want to config another user name or email you have to run the same command without `--global`.

### Config your Editor

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
