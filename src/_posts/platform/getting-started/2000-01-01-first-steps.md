---
title: First Steps On Scalingo
nav: First Steps
modified_at: 2026-04-30 00:00:00
tags: follow-the-light ssh
index: 1
---

## Deployment Requirements

### Git

Scalingo lets you deploy and run your code using Git. To deploy an application,
you need to have Git installed on your computer.

* [Install git on Linux](https://git-scm.com/install/linux)
* [Install git on macOS](https://git-scm.com/install/mac)
* [Install git on Windows](https://git-scm.com/install/windows)

### SSH Key Setup

To verify that you are allowed to push code to your application, Scalingo uses
SSH authentication.

* [Configure your SSH keys on Linux]({% post_url platform/getting-started/2000-01-01-setup-ssh-linux %})
* [Configure your SSH keys on macOS]({% post_url platform/getting-started/2000-01-01-setup-ssh-macos %})
* [Configure your SSH keys on Windows]({% post_url platform/getting-started/2000-01-01-setup-ssh-windows %})

Once you have your own SSH key pair, add the content of the public key to your
account.

Using our dashboard: [https://dashboard.scalingo.com/account/keys](https://dashboard.scalingo.com/account/keys)

Using our [command line client]({% post_url tools/cli/2000-01-01-start %}):

```bash
scalingo keys-add [name of the key] [path to the key]

# Example:

scalingo keys-add Laptop ~/.ssh/id_ed25519.pub
```

## Some Tutorials to Start With

Once Git and SSH are ready, follow a tutorial for your language or framework to
easily deploy your first application on Scalingo.

<ul class="list-unstyled">
  {% for post in site.tags["getting-started-tutorial"] %}
  <li><a href="{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

{% note %}
  We support a lot of technologies, ask for your tutorial!
  <a href="mailto:support@scalingo.com">support@scalingo.com</a>
{% endnote %}
