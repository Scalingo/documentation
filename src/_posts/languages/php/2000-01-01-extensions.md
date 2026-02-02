---
title: Managing PHP Extensions
nav: Managing PHP Extensions
modified_at: 2026-01-15 12:00:00
tags: php
index: 4
---

Applications might require native PHP extensions which are usually written in
C. Consequently, they need to be compiled as shared libraries (`.so` files) to
be used by PHP.

Some of them are pre-installed and shipped by default with the deployed version
of PHP. Others are dynamically installed if specified in the project's
`composer.json` file.


## Working With PHP Built-in Extensions

### Available PHP Built-in Extensions

The following table lists the PHP built-in extensions we bundle with PHP and
that are **available** on Scalingo.

- Some are enabled by default and can't be disabled. You don't have to add them
  to your `composer.json` file to enable them (but you can).\
  They are marked as **Enabled** in the following table.
- Some others are disabled by default and [can be enabled](#enabling-a-php-built-in-extension).\
  They are marked as **Optional** in the following table.
- Unavailable extensions are marked with a blank cell.

| Extension          | PHP 8.1  | PHP 8.2  | PHP 8.3  | PHP 8.4  | PHP 8.5  |
| ------------------ | -------- | -------- | -------- | -------- | -------- |
| `ext-bcmath`       | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-bz2`          | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-calendar`     | Optional | Optional | Optional | Optional | Optional |
| `ext-ctype`        | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-curl`         | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-date`         | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-dom`          | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-exif`         | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-fileinfo`     | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-filter`       | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-ftp`          | Optional | Optional | Optional | Optional | Optional |
| `ext-gd`           | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-gettext`      | Optional | Optional | Optional | Optional | Optional |
| `ext-gmp`          | Optional | Optional | Optional | Optional | Optional |
| `ext-hash`         | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-iconv`        | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-imap`         | Optional | Optional | Optional |          |          |
| `ext-intl`         | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-json`         | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-libxml`       | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-mbstring`     | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-mysqli`       | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-mysqlnd`      | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-openssl`      | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-pcntl`        | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-pcre`         | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-pdo`          | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-pdo_mysql`    | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-pdo_pgsql`    | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-pdo_sqlite`   | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-pgsql`        | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-phar`         | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-posix`        | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-random`       |          | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-readline`     | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-reflection`   | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-session`      | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-shmop`        | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-simplexml`    | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-soap`         | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-sockets`      | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-sodium`       | Optional | Optional | Optional | Optional | Optional |
| `ext-spl`          | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-sqlite3`      | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-tidy`         | Optional | Optional | Optional | Optional | Optional |
| `ext-tokenizer`    | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-xml`          | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-xmlreader`    | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-xmlwriter`    | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-xsl`          | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-zend-opcache` | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-zip`          | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-zlib`         | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |

### Enabling a PHP Built-in Extension

To enable an optional PHP built-in extension, add its name to the `require`
block of your `composer.json` file, like so:

```json
{
  "require": {
    "ext-pdo_pgsql": "*",
    "ext-gettext": "*",
    ...
  }
}
```

### Adding a PHP Built-in Extension

To add a PHP built-in extension that is not available, please get in touch
with our support team.


## Working With PECL Extensions

{% note %}
Some PECL extensions are very old, probably even unmaintained and will only
work with an old version of PHP (e.g. `mongo`, `sodium`, `ds`, `lua` or
`imap`). We strongly advise you to pick your extension(s) carefully.
{% endnote %}

### Available PECL Extensions

The following table lists the PECL extensions that we pre-compile and make
**available** on Scalingo.

- Some are enabled by default and can't be disabled. You don't have to add them
  to your `composer.json` file to enable them (but you can).\
  They are marked as **Enabled** in the following table.
- Some others are disabled by default and [can be enabled](#enabling-a-pecl-extension).\
  They are marked as **Optional** in the following table.
- Unavailable extensions are marked with a blank cell.

{% note %}
To use a PECL extension that is not listed in the table of available PECL
extensions, please read [Adding a PECL Extension](#adding-a-pecl-extension).
{% endnote %}

| Extension       | PHP 8.1  | PHP 8.2  | PHP 8.3  | PHP 8.4  | PHP 8.5  |
| --------------- | -------- | -------- | -------- | -------- | -------- |
| `ext-amqp`      | Optional | Optional | Optional | Optional |          |
| `ext-apcu`      | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-apfd`      | Optional | Optional | Optional | Optional | Optional |
| `ext-event`     | Optional | Optional | Optional | Optional | Optional |
| `ext-igbinary`  | Optional | Optional | Optional | Optional |          |
| `ext-imagick`   | Optional | Optional | Optional | Optional | Optional |
| `ext-memcached` | Optional | Optional | Optional | Optional | Optional |
| `ext-mongodb`   | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |
| `ext-oci8`      |          | Optional | Optional | Optional | Optional |
| `ext-redis`     | Enabled  | Enabled  | Enabled  | Enabled  | Enabled  |

#### Available Versions

The following table lists the supported versions of available PECL extensions:

| Extension       | PHP 8.1  | PHP 8.2  | PHP 8.3  | PHP 8.4  | PHP 8.5  |
| --------------- | -------: | -------: | -------: | -------: | -------: |
| `ext-amqp`      | `2.1.2`  | `2.1.2`  | `2.1.2`  | `2.1.2`  |          |
| `ext-apcu`      | `5.1.27` | `5.1.28` | `5.1.28` | `5.1.28` | `5.1.28` |
| `ext-apfd`      | `1.0.3`  | `1.0.3`  | `1.0.3`  | `1.0.3`  | `1.0.3`  |
| `ext-event`     | `3.0.8`  | `3.0.8`  | `3.0.8`  | `3.0.8`  | `3.0.8`  |
| `ext-igbinary`  | `3.2.16` | `3.2.16` | `3.2.16` | `3.2.16` |          |
| `ext-imagick`   | `3.8.1`  | `3.8.1`  | `3.8.1`  | `3.8.1`  | `3.8.1`  |
| `ext-memcached` | `3.4.0`  | `3.4.0`  | `3.4.0`  | `3.4.0`  | `3.4.0`  |
| `ext-mongodb`   | `1.21.0` | `1.21.0` | `1.21.0` | `1.21.0` | `1.21.0` |
| `ext-oci8`      |          | `3.4.0`  | `3.4.0`  | `3.4.0`  | `3.4.0`  |
| `ext-redis`     | `6.3.0`  | `6.3.0`  | `6.3.0`  | `6.3.0`  | `6.3.0`  |

### Enabling an Available PECL Extension

To enable an available PECL extension, add its name to the `require` block of
your `composer.json` file, like so (**notice the `ext-` prefix!**):

```json
{
  "require": {
    "ext-apcu": "*",
    "ext-igbinary": "*",
    ...
  }
}
```

### Adding a PECL Extension

If the PECL extension you need is not listed in the table of available PECL
extensions, you may want to instruct the platform to compile it and install it
during the *build* phase of your deployment.

To do so, add its name in the `require` block of your `composer.json`, like so
(**notice the `ext-` prefix!**):

```json
{
  "require": {
    "ext-my_pecl_extension": "*",
    ...
  }
}
```

{% note %}
- While our experience shows it works well in a lot of cases, we can't
  guarantee it will. Please get in touch with our support team if you need
  help.
- If the compilation of the extension succeeds, the compiled extension (the
  `.so` file) is kept in cache for future deployments.
{% endnote %}

#### Adding a PECL Extension That Has Dependencies

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

#### Adding a PECL Extension With Specific Compilation Flags

Some extensions also require specific compilation flags to be set. To specify
these flags, [create a new environment variable]({% post_url platform/app/2000-01-01-environment %})
named after the extension and prefixed with
`PHP_PECL_EXTENSION_CONFIGURE_ARGS_` (see [Full Example](#full-example), below).
Then, put the compilation flags you want to use in this variable.

Each extension requiring specific compilation flags must have its own
environment variable.

#### Full Example

In this example, we are going to install the PECL extension named `yaml`. This
is a good example as it requires the`libyaml` and `libyaml-dev` packages to be
installed, and it also needs some specific compilation flags.

First, let's tell the platform we need this extension. To do so, we will have
to create a file named `composer.json` at the root of our project, like this:

```json
{
  "require": {
    "ext-yaml": "*"
  }
}
```

As recommended, we will use the multi-buildpack to tell the platform to:

1. first, call the APT buildpack to install the required packages;
2. and then, use the PHP buildpack to install PHP, Composer and the required
   extensions.

Let's create a file named `.buildpacks` at the root of the project with the
following content:

```
https://github.com/Scalingo/apt-buildpack
https://github.com/Scalingo/php-buildpack
```

`libyaml` is already available in our containers so we don't have to worry
about it. But we still have to install `libyaml-dev`. To do so, create another
file, named `Aptfile`, at the root of the project:

```
libyaml-dev
```

We then need to create a dedicated environment variable, named
`PHP_PECL_EXTENSION_CONFIGURE_ARGS_yaml` and set its value to
`--with-yaml=$BUILD_DIR/.apt/usr`. This instructs the platform to compile the
extension with this flag, which tells the compile script where to find the
`libyaml` headers.

The last step consists in committing your work and pushing it to Scalingo.


## Working With Third-Party Extensions

### Available Third-Party Extensions

The following table lists the third-party extensions that are **available** on
Scalingo, along with the versions available.

- They are all disabled by default and [can be enabled](#enabling-an-available-third-party-extension).

| Extension | PHP 8.1     | PHP 8.2     | PHP 8.3     | PHP 8.4     | PHP 8.5     |
| --------- | ----------: | ----------: | ----------: | ----------: | ----------: |
| Datadog   | `1.6.2`     | `1.6.2`     | `1.6.2`     | `1.6.2`     | `1.6.2`     |
| New Relic | `11.5.0.18` | `11.5.0.18` | `11.5.0.18` | `11.5.0.18` | `12.2.0.27` |
| Scout APM | `1.10.0`    | `1.10.0`    | `1.10.0`    | `1.10.0`    | `1.10.0`    |

### Enabling an Available Third-Party Extension

To enable an available third-party extension, please refer to the corresponding
instructions:

- For [Datadog]({% post_url languages/php/2000-01-01-start %}#extrapaasdatadog)
- For [New Relic]({% post_url languages/php/2000-01-01-start %}#extrapaasnew-relic)
- For [Scout APM]({% post_url languages/php/2000-01-01-start %}#extrapaasscout)

### Adding a Third-Party Extension

To add a third-party extension that is not available, please get in touch with
our support team.
