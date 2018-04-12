---
title: Installing a Gem on Scalingo from a Private Git Repository
nav: Gem from a private Git repo
modified_at: 2017-02-08 17:39:00
tags: ruby gem private git
---

You may want to use a gem in your app which is private and stored in a custom
Git repository. Note that if this repository is on GitHub, you should follow
[the page specific to it]({% post_url
languages/ruby/2000-01-01-private-gem-from-github-on-scalingo %}). Otherwise,
if you're using GitLab, Bitbucket or your own server, you're at the right
place.

The recommended method to achieve this operation is to use the [SSH Private
Key Buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-ssh-key %}).
This page explains how to use this buildpack.

## Set the private SSH key in the app environment

The buildpack expects a private key stored in an environment variable named `SSH_KEY`
in base64. It also need the location of the gems you'll be installing using the `SSH_HOSTS`
variable.

```
scalingo env-set "SSH_KEY=$(cat private_key | base64 -w 0)"
scalingo env-set "SSH_HOSTS=git@gitlab.com"
```

Obviously, this key should have the permission to clone your private gem
repository.

## Gemfile: use the SSH URL

The gems you want to checkout should be defined in your `Gemfile` with the following syntax:

```
gem "name-of-gem", git: "git@private-server.com:namespace/private-gem.git"
```

## Configure the buildpack

To use the private key buildpack, your application should be using the multi buildpack,
allowing to chain multiple buildpacks.

```
$ scalingo env-set BUILDPACK_URL=https://github.com/Scalingo/multi-buildpack.git
```

Chain the private key buildpack, and the ruby buildpack:

```
$ cat << EOF > .buildpacks
https://github.com/Scalingo/ssh-private-key-buildpack.git
https://github.com/Scalingo/ruby-buildpack.git
EOF
```

Commit the files and that's it. At the next deployment your private gem will be downloaded
as expected.
