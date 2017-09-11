---
title: Installing a Gem on Scalingo from a Private Git Repository
modified_at: 2017-02-08 17:39:00
categories: languages ruby
tags: ruby gem private git
---

You may want to use a gem in your app which is private and stored in a custom Git repository. Note that if this
repository is on GitHub, you should follow [the page specific to it]({% post_url languages/ruby/2000-01-01-private-gem-from-github-on-scalingo %}).
Otherwise, if you're using Gitlab, Bitbucket or your own server, you're at the right place.

## Create a Git wrapper

In the `bin` directory of your project create a file named `git-ssh` with the following content:

```
#!/bin/bash

if [ ! -e "$HOME/.pkey" ] ; then
  echo "$(echo $PKEY | base64 -d)" > "$HOME/.pkey"
  chmod 400 "$HOME/.pkey"
fi

ssh -i "$HOME/.pkey" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $1 $2
```

Make it executable by running `chmod` on it:

```
chmod +x bin/git-ssh
```

This script should be used as a SSH wrapper by Git, to do so you must define
the `GIT_SSH` environment variable which is automatically used by the
executable `git`.

```
scalingo env-set GIT_SSH=git-ssh
```

## Set the private SSH key in the app environment

The script expect a private key stored in an environment variable named `PKEY` in base64.

```
scalingo env-set "PKEY=$(cat private_key | base64 -w 0)"
```

Obviously, this key should have the permission to clone your private gem repository.

## Gemfile: use the SSH URL

The gems you want to checkout should be defined in your `Gemfile` with the following syntax:

```
gem "name-of-gem", git: "git@private-server.com:namespace/private-gem.git"
```

## Conclusion

That's it everything is ready to pull out your private gems during the deployment of your application.

1. The `bundler` gem will call the `git` executable to get the gems
2. The `git` binary is the reading the environment variable `GIT_SSH` to use a custom SSH wrapper
3. The wrapper dynamically prepare the private key to authenticate to ssh connection
