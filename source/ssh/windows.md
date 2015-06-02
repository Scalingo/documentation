---
title: Setup SSH on Windows
category: getting-started
date: 04/04/2015
tags: tutorial, follow-the-light, ssh, windows, git
---

# Setup SSH on Windows

## Create a new SSH key pair

```
ssh-keygen
```

Follow the instructions to generate a new SSH key pair. You will be asked to encrypt
you private key with a password. This step is optional but for further security you may
want to set one.

By default both private an d public keys will be located in your `$HOME/.ssh` directory.
