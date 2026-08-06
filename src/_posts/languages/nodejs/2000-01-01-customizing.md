---
title: Customize Node.js Builds
nav: Customize Builds
modified_at: 2026-08-06 00:00:00
tags: nodejs build
index: 5
---

Configure the Node.js buildpack through `package.json`, package-manager files, and Scalingo environment variables. Start with [Default Node.js Build and Runtime Behavior]({% post_url languages/nodejs/2000-01-01-default-behavior %}), then change only the behavior the application needs.

## Configuration sources

| Source | Typical use |
| --- | --- |
| `package.json` | Runtime and package-manager versions, scripts, custom cache paths |
| Lockfile | Package-manager selection and reproducible dependency graph |
| `.npmrc` | npm and pnpm registry, authentication, proxy, and install configuration |
| `.yarnrc.yml` | Yarn Berry configuration, linker mode, registry settings, optional vendored Yarn path |
| Scalingo environment variables | Buildpack switches, credentials, application configuration |
| Scalingo stack | Ubuntu base image and system-library compatibility |
| `Procfile` | Explicit runtime process types and commands |

Do not store credentials directly in committed configuration. Reference an environment variable instead.

## Choose or migrate the Scalingo stack

The stack is an application-level platform setting rather than a Node.js buildpack environment variable.

Each listed stack uses an Ubuntu long-term support (LTS) release.

| Stack | Base operating system | Status | Lifecycle |
| --- | --- | --- | --- |
| `scalingo-22` | Ubuntu 22.04 LTS | Deprecated | Discontinued on 1 June 2027 |
| `scalingo-24` | Ubuntu 24.04 LTS | Supported | Supported through May 2029 |
| `scalingo-26` | Ubuntu 26.04 LTS | Supported and latest | Supported through May 2031 |

Inspect the current value:

```bash
scalingo --app my-app apps-info
```

Move an application to `scalingo-26` and redeploy:

```bash
scalingo --app my-app stacks-set scalingo-26
git commit --allow-empty --message="Migrate to scalingo-26"
git push scalingo main
```

{% warning %}
A stack migration changes the Ubuntu base image. Test native modules, browser binaries, image-processing libraries, database clients, and any APT-installed packages in staging or a Review App before production.
{% endwarning %}

The buildpack's normal cache signature includes the stack and is invalidated by a stack change. Review custom `cacheDirectories` separately because they can retain generated artifacts outside the default cache policy.

## Build scripts and hook order

The buildpack recognizes three Scalingo-specific scripts and the standard `build` script.

| Script | When it runs | Typical use |
| --- | --- | --- |
| `scalingo-prebuild` | Before dependency installation | Generate package-manager configuration or verify required build inputs |
| `build` | After dependency installation | Compile TypeScript, bundle assets, or run a framework production build |
| `scalingo-postbuild` | In place of `build` when present | Use a Scalingo-specific production build command |
| `scalingo-cleanup` | After caching and production pruning | Remove build-only files from the runtime image |

Example:

```json
{
  "scripts": {
    "scalingo-prebuild": "node scripts/check-build-env.js",
    "build": "tsc -p tsconfig.build.json",
    "scalingo-cleanup": "node scripts/cleanup.js",
    "start": "node dist/server.js"
  }
}
```

{% warning %}
When both `build` and `scalingo-postbuild` exist, the buildpack runs only `scalingo-postbuild`.
{% endwarning %}

Package-manager lifecycle scripts such as `preinstall`, `install`, `postinstall`, and `prepare` can also run during dependency installation. Keep those scripts portable because they also run in local and continuous integration (CI) installations.

## Pass flags to the standard build script

`NODE_BUILD_FLAGS` is forwarded to the standard `build` script.

```bash
scalingo --app my-app env-set NODE_BUILD_FLAGS="--mode production"
```

With:

```json
{
  "scripts": {
    "build": "vite build"
  }
}
```

The resulting command is package-manager-specific but includes the configured flags. `NODE_BUILD_FLAGS` is not forwarded to `scalingo-prebuild`, `scalingo-postbuild`, or `scalingo-cleanup`.

For complex arguments, prefer an explicit `scalingo-postbuild` command in `package.json`; it is easier to review and test.

## Control dependency pruning

The buildpack installs development dependencies during the build by default, then removes them from a production runtime.

Use the package-manager-specific controls only when necessary:

| Package manager | Install-time control | Skip-pruning control |
| --- | --- | --- |
| npm | `NPM_CONFIG_PRODUCTION` | No dedicated verified skip-pruning variable in the audited path |
| Yarn Classic | `YARN_PRODUCTION` | See the Yarn page |
| Yarn Berry | Do not use `YARN_PRODUCTION` | `YARN2_SKIP_PRUNING=true` |
| pnpm | Installs with development dependencies by default | `PNPM_SKIP_PRUNING=true` |

A package used by the start command belongs in `dependencies`. Skipping pruning should not be the normal way to repair an incorrect dependency classification.

## Configure the build cache

Caching is enabled by default:

```text
NODE_MODULES_CACHE=true
```

Disable it temporarily when diagnosing a cache-related build problem:

```bash
scalingo --app my-app env-set NODE_MODULES_CACHE=false
```

Re-enable it after diagnosis:

```bash
scalingo --app my-app env-set NODE_MODULES_CACHE=true
```

The default cached content depends on the package manager. To cache additional relative paths, add `cacheDirectories` to `package.json`:

```json
{
  "cacheDirectories": [
    ".next/cache",
    "packages/frontend/.cache"
  ]
}
```

The legacy key `cache_directories` is also recognized. Prefer `cacheDirectories` for new applications.

{% warning %}
Custom cache directories replace the normal directory list. Cache only reproducible build artifacts. Do not cache secrets, user uploads, or state required for correctness.
{% endwarning %}

pnpm-managed `node_modules` paths are not restored as custom cache paths; the buildpack includes the pnpm store separately.

## Increase build log detail

Set `NODE_VERBOSE=true` to print a top-level dependency summary near the end of a successful build.

```bash
scalingo --app my-app env-set NODE_VERBOSE=true
```

npm log verbosity is controlled with `NPM_CONFIG_LOGLEVEL`:

```bash
scalingo --app my-app env-set NPM_CONFIG_LOGLEVEL=info
```

Remove or lower verbose settings after troubleshooting to keep build logs readable.

## Configure Node.js memory options

When `NODE_OPTIONS` is not defined, the audited buildpack supplies:

```text
--max_old_space_size=2560
```

Set your own Node.js options when the application or build needs a different value:

```bash
scalingo --app my-app env-set NODE_OPTIONS="--max-old-space-size=1536"
```

This variable can affect both build-time Node.js commands and the runtime process. A higher old-space limit does not increase the container memory limit and does not repair a memory leak. Leave enough memory for native allocations, buffers, the package manager, and other processes in the container.

See [Manage Node.js Web Concurrency]({% post_url languages/nodejs/2000-01-01-managing-web-concurrency %}) before combining several Node.js worker processes with a large old-space limit.

## Select package-manager versions

Node.js and package-manager versions are separate settings.

### npm

```json
{
  "engines": {
    "node": "24.x",
    "npm": "11.x"
  }
}
```

### Yarn

Prefer the `packageManager` field for modern Yarn:

```json
{
  "packageManager": "yarn@4.9.2"
}
```

### pnpm

```json
{
  "packageManager": "pnpm@10.15.0"
}
```

When both `packageManager` and the corresponding `engines.yarn` or `engines.pnpm` field exist, `packageManager` takes precedence and the build emits a warning.

## Force `npm install`

With a supported npm lockfile and npm 6 or newer, the buildpack normally chooses `npm ci`. Set `USE_NPM_INSTALL=true` to force the install path:

```bash
scalingo --app my-app env-set USE_NPM_INSTALL=true
```

Use this only for an identified compatibility requirement. `npm ci` is usually preferable because it enforces the lockfile and starts from a clean dependency tree.

## Configure certificate authorities

The buildpack defaults `NODE_EXTRA_CA_CERTS` to Scalingo’s database certificate authority (CA) bundle. Override it only when the application must trust an additional CA file available in the application image:

```bash
scalingo --app my-app env-set NODE_EXTRA_CA_CERTS=/app/config/company-ca.pem
```

The file must exist at runtime. Do not replace the default without checking database Transport Layer Security (TLS) connectivity and other outbound TLS requirements.

## Advanced binary overrides

The buildpack contains advanced overrides for downloading Node.js or Yarn from custom URLs:

- `NODE_BINARY_URL`
- `YARN_BINARY_URL`

These bypass normal inventory or package resolution and can reduce reproducibility or supportability.

{% warning %}
Treat custom binary URLs as an advanced escape hatch. Pin an immutable HTTPS artifact, verify its provenance, and test checksum and stack compatibility. Confirm the support policy with Scalingo before documenting this as a standard deployment method.
{% endwarning %}

## Committed `node_modules`

Do not commit `node_modules`. The buildpack can detect prebuilt modules and may rebuild native dependencies, but locally generated packages can still be incompatible with the Scalingo stack.

`SKIP_NODE_MODULES_CHECK=true` preserves committed modules in part of the Yarn path. This is an advanced compatibility control, not a recommended dependency-delivery method.

## Configuration reference

| Variable or option | Default | Scope | Purpose |
| --- | --- | --- | --- |
| `NODEJS_ALLOW_WIDE_RANGE` | Unset | Build | Opt out of the Active-LTS cap for a wide Node.js range |
| `NODE_MODULES_CACHE` | `true` | Build | Enable or disable build caching |
| `NODE_VERBOSE` | `false` | Build | Print a dependency summary |
| `NODE_BUILD_FLAGS` | Empty | Build | Pass flags to `build` |
| `NODE_ENV` | `production` | Build and runtime | Application environment and pruning condition |
| `NODE_OPTIONS` | `--max_old_space_size=2560` when absent | Build and runtime | Node.js runtime options |
| `NODE_EXTRA_CA_CERTS` | Scalingo database CA path | Build and runtime | Additional trusted CA file |
| `USE_NPM_INSTALL` | Automatic selection | Build | Force npm install instead of npm ci |
| `USE_YARN_CACHE` | `true` for Yarn | Build | Control Yarn cache behavior |
| `PNPM_INSTALL_REPORTER` | pnpm default | Build | Select pnpm output reporter |
| `cacheDirectories` | Manager-specific defaults | Build | Replace default cached paths |

See the npm, Yarn, and pnpm pages for manager-specific variables.
