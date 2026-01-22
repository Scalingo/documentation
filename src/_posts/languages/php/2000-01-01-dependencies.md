---
title: Managing Dependencies
nav: Managing Dependencies
modified_at: 2026-01-22 12:00:00
tags: php
index: 3
---

[Composer](https://getcomposer.org) is the official dependency manager for PHP.
It allows to manage (download, install, upgrade, configure, and remove) the
libraries a project depends on.

If you want the platform to use Composer to manage your dependencies, make sure
to include both the `composer.json` and the `composer.lock` files in your
codebase.

## Declaring Dependencies

The dependencies required by your application must be declared in a file named
`composer.json`, stored at the root of your codebase. The format is described
in the [Composer documentation](https://getcomposer.org/doc/01-basic-usage.md).

Once your dependencies have been defined and declared, their versions must be
frozen to ensure a precise version of the application will always be deployed
with the same compatible set of Composer packages. This allows for better
reproducibility and consistency across environments. These versions are written
in a file named `composer.lock`, also stored at the root of your project.

Use Composer itself on your local computer (or in your CI/CD pipeline) to
generate the `composer.lock` file:

```bash
$ composer install
```

To upgrade a dependency, run the following command (in the example below, we
ask Composer to upgrade `slim`):

```bash
$ composer update slim/slim
```

In some circumstances, it can be convenient to add either the
`--ignore-platform-req=` or the `--ignore-platform-reqs` flag to the above
commands.

After each command, the `composer.lock` file is automatically updated. Don't
forget to commit the modifications!

{% note %}
    Both the `composer.json` and `composer.lock` files are **required** for the
    platform to handle your dependencies.
{% endnote %}

### Managing Private Dependencies

If you want to install a private dependency, you need to define the
`COMPOSER_AUTH` environment variable, as specified in
[the Composer documentation](https://getcomposer.org/doc/03-cli.md#composer-auth).

For a private dependency hosted on GitHub, the `COMPOSER_AUTH` environment
variable should contain:

```json
{
  "github-oauth": {
    "github.com": "MY-TOKEN"
  }
}
```

`MY-TOKEN` must be replaced with a valid access token (OAuth token) for your
GitHub account.

Such a token can be generated [from your GitHub account](https://github.com/settings/tokens).
For more details about GitHub access tokens, please refer to [their
comprehensive documentation](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens).

## Specifying the Composer Version

You can select the Composer version to install by specifying it in your
`composer.json`:

```json
{
  "extra": {
    "paas": {
      "engines": {
        "composer": "2.x"
      }
    }
  }
}
```

Scalingo currently supports the following versions of Composer:

| Composer    | `scalingo-20` (EOL) | `scalingo-22`  | `scalingo-24`  |
| ----------: | ------------------: | -------------: | -------------: |
| `2.9`       | unsupported         | up to `2.9.4`  | up to `2.9.4`  |
| `2.2` (LTS) | up to `2.2.25`      | up to `2.2.26` | up to `2.2.26` |


## Working with Composer Environments

By default, Scalingo considers that your application runs in *production* mode.
This means that `composer install` automatically runs with the `--no-dev` flag.
As a result, won't install the development dependencies of your application, if
any.

Set the `COMPOSER_DEV` environment variable to `true` if you would like to run your application with these
development dependencies installed (e.g. to debug your app).

In addition to the `--[no-]dev` flag, the platform always runs
`composer install` with the `--prefer-dist` and `--optimize-autoloader` flags.
