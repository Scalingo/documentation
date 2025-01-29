---
title: Managing PHP Extensions
nav: Managing PHP Extensions
modified_at: 2025-01-14 12:00:00
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

The following extensions are included in PHP and are **available**.

The ones marked as *Enabled by default* are always **enabled** and can't be
disabled. You don't have to add them to your `composer.json` file (but you
can).

| Extensions     | Enabled by default |
| -------------- | ------------------ |
| `bcmath`       | Yes                |
| `bz2`          | Yes                |
| `calendar`     | No                 |
| `ctype`        | Yes                |
| `cURL`         | Yes                |
| `date`         | Yes                |
| `dom`          | Yes                |
| `exif`         | Yes                |
| `fileinfo`     | Yes                |
| `filter`       | Yes                |
| `ftp`          | No                 |
| `gd`           | Yes                |
| `gettext`      | No                 |
| `gmp`          | No                 |
| `hash`         | Yes                |
| `iconv`        | Yes                |
| `intl`         | Yes                |
| `json`         | Yes                |
| `libxml`       | Yes                |
| `mbstring`     | Yes                |
| `mysqli`       | Yes                |
| `mysqlnd`      | Yes                |
| `openssl`      | Yes                |
| `pcntl`        | Yes                |
| `pcre`         | Yes                |
| `pdo_mysql`    | Yes                |
| `pdo_pgsql`    | Yes                |
| `pdo_sqlite`   | Yes                |
| `pgsql`        | Yes                |
| `Phar`         | Yes                |
| `posix`        | Yes                |
| `random`       | Yes (req. PHP >= `8.3`) |
| `readline`     | Yes                |
| `Reflection`   | Yes                |
| `session`      | Yes                |
| `shmop`        | Yes                |
| `SimpleXML`    | Yes                |
| `soap`         | Yes                |
| `sockets`      | Yes                |
| `sodium`       | No                 |
| `SPL`          | Yes                |
| `sqlite3`      | Yes                |
| `tidy`         | No                 |
| `tokenizer`    | Yes                |
| `xml`          | Yes                |
| `xmlreader`    | Yes                |
| `xmlwriter`    | Yes                |
| `xsl`          | Yes                |
| `Zend OPcache` | Yes                |
| `zip`          | Yes                |
| `zlib`         | Yes                |

### Enabling a PHP Built-in Extension

To enable an available PHP built-in extension, add its name to the `require`
block of your `composer.json` file, like so (**notice the `ext-` prefix!**):

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

### Available PECL Extensions

The following PECL extensions are also **available**.

The ones marked as *Enabled by default* are always **enabled** and can't be
disabled. You don't have to add them to your `composer.json` file (but you
can).

| Extension   | Version  | Enabled by default | |
| ----------- | -------- | :----------------- | |
| `amqp`      | `2.1.2`  | No  | |
| `apcu`      | `5.1.24` | Yes | |
| `apfd`      | `1.0.3`  | No  | |
| `event`     | `3.0.8`  | No  | |
| `igbinary`  | `3.2.16` | No  | |
| `imagick`   | `3.7.0`  | No  | |
| `memcached` | `3.3.0`  | No  | |
| `mongodb`   | `1.20.1` | Yes | |
| `oci8`      | `3.4.0`  | No  | |
| `redis`     | `6.1.0`  | Yes | |

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

If the PECL extension you need is not in the above list of available PECL
extensions, you may want to instruct the platform to compile and install it
during the *build* phase of your deployment.

To do so, add its name in the `require` block of your `composer.json`, like so
(**notice the `ext-` prefix!**):

```json
{
  "require": {
    "ext-libsodium": "*",
    ...
  }
}
```

{% note %}
- Some PECL extensions are very old, probably even unmaintained and will only
  work with an old version of PHP (e.g. `mongo`, `sodium`, `ds` or `lua`). We
  strongly advise you to pick your extension(s) carefully.
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


## Working With Proprietary Extensions

### Available Proprietary Extensions

The following proprietary extensions are also **available**.

They are all disabled by default.

| Extension       | Version     | Enabled by default |
| --------------- | ----------- | ------------ |
| `blackfire`     | `1.86.3`    | No           |
| `datadog`       |             | No. [See instructions]({% post_url languages/php/2000-01-01-start %}#extrapaasdatadog)   |
| `newrelic`      | `11.5.0.18` | No. [See instructions]({% post_url languages/php/2000-01-01-start %}#extrapaasnew-relic) |
| `scoutapm`      | `1.10.0`    | No. [See instructions]({% post_url languages/php/2000-01-01-start %}#extrapaasscout)     |

### Enabling an Available Proprietary Extension

To enable an available proprietary extension, please refer to the corresponding
instructions given in the table above.

### Adding a Proprietary Extension

To add an extension that is not available, please get in touch with our support
team.
