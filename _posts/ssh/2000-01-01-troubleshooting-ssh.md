---
title: Troubleshooting git push and SSH common issues
modified_at: 2016-09-10 00:00:00
category: getting-started
tags: follow-the-light ssh linux git troubleshoot problem connect git push
---

## Prerequisite

At this point we consider you have correctly setup your environment as detailed here:

* [Linux]({% post_url 2015-04-03-setup-ssh-linux %})
* [Mac OS]({% post_url 2015-04-04-setup-ssh-macos %})
* [Windows]({% post_url 2015-04-04-setup-ssh-windows %})

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
