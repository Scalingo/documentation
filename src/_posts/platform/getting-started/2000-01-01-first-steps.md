---
title: First Steps On Scalingo
nav: First Steps
modified_at: 2023-12-22 00:00:00
tags: follow-the-light ssh
index: 1
---

## Deployment Requirements

### Git

Deploying an application on Scalingo requires you to have Git installed.

* Linux: Use your package manager to install it. (example: `apt-get install git`)
* macOS: If you've installed XCode, Git has been automatically installed. Otherwise,
  install it from [Git official website](https://git-scm.com/download/mac)
* Windows: Install if from [Git official website](https://git-scm.com/download/windows)

### SSH Key Setup

To identify that you are allowed to push to your application, you need to setup SSH
authentication.

* [Guide for Linux]({% post_url platform/getting-started/2000-01-01-setup-ssh-linux %})
* [Guide for MacOS]({% post_url platform/getting-started/2000-01-01-setup-ssh-macos %})
* [Guide for Windows]({% post_url platform/getting-started/2000-01-01-setup-ssh-windows %})

For any operating system, you need to copy the content of the public key to your account.

With our dashboard:

[https://dashboard.scalingo.com/account/keys](https://dashboard.scalingo.com/account/keys)

With our command line client:

```bash
scalingo keys-add [name of the key] [path to the key]

# Example:

scalingo keys-add Laptop ~/.ssh/id_ed25519.pub
```

## Some Tutorials to Start With

<ul class="list-unstyled">
  {% for post in site.tags["getting-started-tutorial"] %}
  <li><a href="{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

{% note %}
  We support a lot of technologies, ask for your tutorial!
  <a href="mailto:support@scalingo.com">support@scalingo.com</a>
{% endnote %}
