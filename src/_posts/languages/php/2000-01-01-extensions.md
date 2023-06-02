---
title: Managing PHP Extensions
nav: Managing PHP Extensions
modified_at: 2023-06-02 16:00:00
tags: php
index: 3
---

Applications might require native PHP extensions which are usually written in
C. Consequently, they need to be compiled as shared libraries (`.so` files) to
be used by PHP.

Some of them are pre-installed and shipped by default with the deployed version
of PHP. Others are dynamically installed if specified in the project's
`composer.json` file.

## Pre-Installed Extensions

The following extensions are **available and enabled** by default with the
installed version of PHP. You don't need to add them in your `composer.json`
file (but you can).

* Databases: [`mysql`](https://www.php.net/manual/en/book.mysql.php),
[`mysqli`](https://www.php.net/manual/en/book.mysqli.php),
[`pgsql`](https://www.php.net/manual/en/book.pgsql.php),
[`pdo-mysql`](https://www.php.net/manual/en/ref.pdo-mysql.php),
[`pdo-pgsql`](https://www.php.net/manual/en/ref.pdo-pgsql.php),
* Compression: [`bz2`](https://www.php.net/manual/en/book.bzip2.php),
[`zlib`](https://www.php.net/manual/en/book.zlib.php),
[`zip`](https://www.php.net/manual/en/book.zip.php)
* Web services: [`soap`](https://www.php.net/manual/en/book.soap.php)
* XML manipulation: [`xmlreader`](https://www.php.net/manual/en/mbstring.installation.php)
* String encoding: [`mbstring`](https://www.php.net/manual/en/mbstring.installation.php)
* Process control: [`pcntl`](https://www.php.net/manual/en/book.pcntl.php)
* Socket management: [`sockets`](https://www.php.net/manual/en/book.sockets.php)
* Math functions: [`bcmath`](https://www.php.net/manual/book.bc.php)
* Images manipulation: [`gd`](https://www.php.net/manual/book.image.php)
* Intl (Internationalization): [`intl`](https://www.php.net/manual/book.intl.php)

## Working With PECL Extensions

All [PECL extensions](https://pecl.php.net/) are available. If the extension
you need is not in the above list of pre-installed extensions, it will be
compiled during the *build* phase of your deployment.

To enable a native PHP extension, add it in the `require` block of your
`composer.json`, like so (notice the `ext-` prefix):

```json
{
  "require": {
    "ext-mongodb": "*",
    "ext-imagick": "*",
    ...
  }
}
```

Once done, don't forget to generate the `composer.lock` file and to commit it
to your codebase.

{% note %}
- Some PECL extensions are very old, probably even unmaintained and will only
  work with an old version of PHP (e.g. `mongo`, `sodium`, `ds` or `lua`). We
  strongly advise you to pick your extension(s) carefully.
- If the compilation of the extension succeeds, the compiled extension (the
  `.so` file) is kept in cache for future deployments.
{% endnote %}

### Working With PECL Extensions That Have Dependencies

While some PECL extensions compile and install just fine out of the box, some
others have precise requirements. In most cases, these requirements consist in
libraries and libraries headers, which are generally available and distributed
as OS packages.

The documentation of the extension should normally specify the name(s) (and
sometimes the versions) of these required package(s).

To install these packages in your container, and when possible, we **strongly**
recommend to use the
[APT buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-apt %})
along with the
[multi-buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-multi %}).

### Specifying Compilation Flags

Some extensions also require specific compilation flags to be set. To specify
these flags, [create a new environment variable]({% post_url platform/app/2000-01-01-environment %})
named after the extension and prefixed with
`PHP_PECL_EXTENSION_CONFIGURE_ARGS_` (see [Full Example](#full-example), below).
Then, put the compilation flags you want to use in this variable.

Each extension requiring specific compilation flags must have its own
environment variable.

### Full Example

In this example, we are going to install the PECL extension called `yaml`. This
is a good example as it requires the`libyaml` and `libyaml-dev` packages to be
installed, and it also needs some specific compilation flags.

First, let's tell the platform we need this extension. To do so, we will have
to create a file called `composer.json` at the root of our project, like this:

```json
{
  "require": {
    "ext-yaml": "*"
  }
}
```

Don't forget to generate the `composer.lock` file, using Composer:

```bash
composer install
```

As recommended, we will use the multi-buildpack to tell the platform to:

1. first, call the apt-buildpack to install the required packages;
2. and then, use the php-buildpack to install PHP, Composer and the required
   extensions.

Let's create a file called `.buildpacks` at the root of the project with the
following content:

```
https://github.com/Scalingo/apt-buildpack
https://github.com/Scalingo/php-buildpack
```

`libyaml` is already available in our containers so we don't have to worry
about it. But we still have to install `libyaml-dev`. To do so, create another
file, called `Aptfile`, at the root of the project:

```
libyaml-dev
```

We then need to create a dedicated environment variable, called
`PHP_PECL_EXTENSION_CONFIGURE_ARGS_yaml` and set its value to
`--with-yaml=$BUILD_DIR/.apt/usr`. This instructs the platform to compile the
extension with this flag, which tells the compile script where to find the
`libyaml` headers.

The last step consists in committing your work and pushing it to Scalingo.
