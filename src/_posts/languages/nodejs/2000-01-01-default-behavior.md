---
title: Default Node.js Build and Runtime Behavior
nav: Default Behavior
modified_at: 2026-08-06 00:00:00
tags: nodejs build runtime
index: 3
---

This page describes the Node.js build and runtime lifecycle. It explains which files control the process and what remains in the runtime image.

## Required application files

A normal Node.js application needs a root `package.json` file. A lockfile is strongly recommended.

```text
my-app/
├── package.json
├── package-lock.json
└── server.js
```

The buildpack itself does not search nested directories. For monorepos, configure the deployed application root through Scalingo platform features before the Node.js buildpack runs.

## Stack used for build and runtime

The application is built for its selected Scalingo stack and the resulting runtime container uses the same Ubuntu base.

Each listed stack uses an Ubuntu long-term support (LTS) release.

| Stack | Base operating system | Status | Lifecycle |
| --- | --- | --- | --- |
| `scalingo-22` | Ubuntu 22.04 LTS | Deprecated | Discontinued on 1 June 2027 |
| `scalingo-24` | Ubuntu 24.04 LTS | Supported | Supported through May 2029 |
| `scalingo-26` | Ubuntu 26.04 LTS | Supported and latest | Supported through May 2031 |

The stack influences:

- operating-system libraries available to native dependencies;
- compiler and toolchain compatibility during source builds;
- compatibility of prebuilt native binaries;
- the build cache signature.

The buildpack cache signature includes the stack. When the application moves between `scalingo-22`, `scalingo-24`, and `scalingo-26`, the normal build cache is not restored as compatible. Custom paths listed in `cacheDirectories` still require care because they can contain generated files the buildpack cannot validate.

A stack change only applies after redeployment. Test migrations in staging or a Review App before changing a production application.

## Package-manager selection

The committed lockfile selects the active package manager.

| File | Selected package manager |
| --- | --- |
| `package-lock.json` | npm |
| `npm-shrinkwrap.json` | npm |
| `yarn.lock` | Yarn |
| `pnpm-lock.yaml` | pnpm |
| No lockfile | npm |

{% warning %}
The buildpack fails when it finds lockfiles for multiple package managers. It does not apply a hidden precedence rule. Remove unused lockfiles, commit the change, and redeploy.
{% endwarning %}

The `packageManager` field can request a Yarn or pnpm version, but the lockfile still selects which manager runs.

## Build lifecycle

The default lifecycle is:

### 1. Create the build environment

The buildpack exports configuration variables supplied by Scalingo, applies Node.js defaults, creates runtime profile files, and adds buildpack-managed binaries to `PATH`.

Important defaults include:

- `NODE_ENV=production`, unless already defined;
- `NODE_MODULES_CACHE=true`;
- `NODE_VERBOSE=false`;
- `NPM_CONFIG_LOGLEVEL=error`;
- `NODE_OPTIONS=--max_old_space_size=2560`, when `NODE_OPTIONS` is absent.

### 2. Install Node.js and package-manager binaries

The buildpack reads `engines.node`, resolves an available version, downloads it, verifies its checksum, and installs it under the application’s `.scalingo` directory.

npm is available with Node.js. Yarn or pnpm is installed when the selected lockfile requires it. See the manager-specific pages for version selection.

### 3. Restore a compatible cache

The buildpack checks a cache signature before restoring cached content. The default cached content depends on the package manager and installation mode:

- npm with `npm ci`: npm download cache;
- npm install or rebuild path: `node_modules`;
- Yarn: Yarn cache, with additional handling for Berry and zero-install projects;
- pnpm: pnpm store;
- custom paths: values from `cacheDirectories` or `cache_directories`.

A cache is an optimization, not the source of dependency truth. Frozen, immutable, or clean installation modes still validate the lockfile.

### 4. Run `scalingo-prebuild`

When present, `scalingo-prebuild` runs before dependency installation.

```json
{
  "scripts": {
    "scalingo-prebuild": "node scripts/prepare-build-environment.js"
  }
}
```

Use this hook only for work that must happen before the package manager installs dependencies.

### 5. Install dependencies

By default, development dependencies are installed so that compilers, bundlers, linters used by build scripts, and framework CLIs are available during the build.

The exact command depends on the manager:

| Manager | Typical build installation |
| --- | --- |
| npm with a supported lockfile and npm 6+ | `npm ci` |
| npm fallback | `npm install` |
| Yarn Classic | `yarn install --frozen-lockfile` with buildpack options |
| Yarn Berry | `yarn install --immutable` |
| pnpm | `pnpm install --prod=false --frozen-lockfile` |

Package-manager lifecycle scripts such as `preinstall`, `install`, `postinstall`, and `prepare` run as part of the normal package-manager command. They are not separate Scalingo hooks.

### 6. Run the application build script

The buildpack applies this precedence:

1. If `scalingo-postbuild` exists, run it.
2. Otherwise, if `build` exists, run it.
3. If both exist, only `scalingo-postbuild` runs.

```json
{
  "scripts": {
    "build": "vite build",
    "scalingo-postbuild": "vite build --mode scalingo"
  }
}
```

`NODE_BUILD_FLAGS` is appended only to the standard `build` script. It is not forwarded to the Scalingo-specific hooks.

### 7. Save the cache and prune development dependencies

After the build, the buildpack saves cache content and prepares production dependencies. The exact cache/prune ordering differs by package manager so that useful cache data is preserved.

When `NODE_ENV=production`, development dependencies are normally removed from the runtime image. Manager-specific controls can skip pruning, but a package required at application startup should normally be declared in `dependencies`, not `devDependencies`.

### 8. Run `scalingo-cleanup`

When defined, `scalingo-cleanup` runs after dependency pruning and framework-specific build work.

```json
{
  "scripts": {
    "scalingo-cleanup": "node scripts/remove-build-only-files.js"
  }
}
```

Use this hook to remove build-only artifacts that should not remain in the runtime image. Do not remove files required by the start command.

### 9. Prepare runtime metadata

The buildpack writes runtime paths and default environment values, installs its metrics integration, and emits default process metadata.

## Default process type

For a normal Node.js application, the buildpack emits:

```text
web: npm start
```

The command works with npm, Yarn, or pnpm projects because `npm start` executes the `scripts.start` entry in `package.json` without reinstalling dependencies.

```json
{
  "scripts": {
    "start": "node server.js"
  }
}
```

If a root `Procfile` defines `web`, the platform uses the explicit process declaration.

```text
web: node server.js
worker: node worker.js
```

A web process must listen on `PORT`. Binding only to a fixed local port or only to `127.0.0.1` can cause a boot timeout.

## Runtime environment

The runtime `PATH` includes:

- the buildpack-installed Node.js binary;
- the buildpack-installed Yarn binary, when present;
- `$HOME/bin`;
- the application’s `node_modules/.bin`.

This means locally installed command-line packages can be used in scripts without being installed globally.

The buildpack also sets or defaults:

- `NODE_HOME`;
- `NODE_ENV=production`;
- `NODE_EXTRA_CA_CERTS` to the Scalingo database CA bundle;
- `NODE_OPTIONS` to a 2560 MB old-space limit when the user did not define it.

## Build-time and runtime dependencies

| Dependency type | Available during build | Expected at runtime |
| --- | :---: | :---: |
| `dependencies` | Yes | Yes |
| `devDependencies` | Yes by default | No after production pruning |
| `optionalDependencies` | According to package-manager behavior | If successfully installed and not pruned |
| Native dependencies | Built or downloaded during install | Must match the Scalingo runtime stack |

If the application crashes with `module not found`, `ng: not found`, `nest: not found`, or a similar error after a successful build, check whether a runtime requirement was placed in `devDependencies`.

## Files that should not be committed

Do not commit `node_modules`. Locally compiled native modules may be incompatible with the Scalingo Linux stack, and committed dependencies make cache and installation behavior harder to predict.

```text
node_modules/
```

Commit the lockfile instead.

## Next steps

- [Customize Node.js Builds]({% post_url languages/nodejs/2000-01-01-customizing %})
- [Use npm]({% post_url languages/nodejs/2000-01-01-npm %})
- [Use Yarn]({% post_url languages/nodejs/2000-01-01-yarn %})
- [Use pnpm]({% post_url languages/nodejs/2000-01-01-pnpm %})
- [Troubleshoot Node.js Deployments]({% post_url languages/nodejs/2000-01-01-troubleshooting %})
