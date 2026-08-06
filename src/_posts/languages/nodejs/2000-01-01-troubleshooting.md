---
title: Troubleshoot Node.js Deployments
nav: Troubleshooting
modified_at: 2026-08-06 00:00:00
tags: nodejs troubleshooting
index: 12
---

Start with the first specific error in the deployment or application log. The final `Build failed` or boot-timeout message is often only a summary of an earlier problem.

Follow logs:

```bash
scalingo --app my-app logs --follow
```

For build failures, keep the complete deployment log from detection through the first classified error.

## Quick triage

| Failure stage | Typical cause | Start here |
| --- | --- | --- |
| Detection | Missing root `package.json` | [Application is not detected](#application-is-not-detected) |
| Runtime installation | Invalid or unavailable Node.js range | [Node.js version errors](#nodejs-version-errors) |
| Package-manager setup | Invalid Yarn or pnpm version | [Package-manager version errors](#package-manager-version-errors) |
| Dependency installation | Lockfile, registry, peer, native, or disk error | [Dependency installation fails](#dependency-installation-fails) |
| Build script | Compiler, framework, memory, or missing devDependency | [The build script fails](#the-build-script-fails) |
| Runtime boot | Missing start command, wrong port, crash | [The application does not boot](#the-application-does-not-boot) |
| Runtime after boot | Missing production dependency, memory, signal, or native library | [The application crashes at runtime](#the-application-crashes-at-runtime) |
| After a stack change | Native binary, system library, browser, or custom cache mismatch | [Identify the active stack](#identify-the-active-stack) |

## Identify the active stack

The stack is the Ubuntu base image, not the Node.js version.

Each listed stack uses an Ubuntu long-term support (LTS) release.

| Stack | Base operating system | Status | Lifecycle |
| --- | --- | --- | --- |
| `scalingo-22` | Ubuntu 22.04 LTS | Deprecated | Discontinued on 1 June 2027 |
| `scalingo-24` | Ubuntu 24.04 LTS | Supported | Supported through May 2029 |
| `scalingo-26` | Ubuntu 26.04 LTS | Supported and latest | Supported through May 2031 |

Record the stack before comparing local and production behavior:

```bash
scalingo --app my-app apps-info
```

If a failure began after a migration between `scalingo-22`, `scalingo-24`, and `scalingo-26`:

1. confirm the application was redeployed after the stack setting changed;
2. verify the resolved Node.js and package-manager versions in the build log;
3. rebuild native dependencies instead of reusing committed modules;
4. temporarily disable the normal Node.js cache if necessary;
5. review custom `cacheDirectories` and APT packages;
6. reproduce against the target stack image when the error concerns a shared library or system binary.

A stack migration can expose an old package that does not publish binaries for the newer Ubuntu base, a missing shared library, or a native module compiled for the previous stack.

## Application is not detected

### `package.json` is missing

The Node.js buildpack requires `package.json` at the root of the deployed source.

```bash
ls -la
git ls-files package.json
```

For a monorepo, configure a child application or deployment root. The buildpack does not search nested directories.

### `package.json` is excluded

The detection script emits a specific message when `.slugignore` or `.gitignore` excludes `package.json`. Remove the exclusion, commit the file, and redeploy.

### `package.json` cannot be parsed

Validate JSON locally:

```bash
node -e 'JSON.parse(require("node:fs").readFileSync("package.json", "utf8"))'
```

Remove comments, trailing commas, unresolved merge markers, or invalid quoting.

## Node.js version errors

### Invalid semantic-version requirement

Use a valid semver requirement:

```json
{
  "engines": {
    "node": "24.x"
  }
}
```

### No published version matches

The requirement is valid but does not match a version in the buildpack inventory. Choose a currently available release line from [Select a Node.js Version]({% post_url languages/nodejs/2000-01-01-selecting-a-version %}).

### End-of-life warning

Upgrade immediately. End-of-life Node.js releases no longer receive upstream security updates and can become build errors in a later buildpack release.

### Node.js download or checksum failure

Retry once to rule out a transient network problem. If it persists, include the requested version and download URL in a support request. Do not disable checksum validation.

## Package-manager selection errors

### Multiple lockfiles found

Only one package manager can install dependencies. Keep one of:

```text
package-lock.json
npm-shrinkwrap.json
yarn.lock
pnpm-lock.yaml
```

Remove the others, commit, and redeploy. The buildpack does not silently choose a precedence.

### `packageManager` conflicts with `engines`

For Yarn or pnpm, `packageManager` takes precedence over the corresponding `engines` field. Remove the duplicate declaration and keep one version source.

## Package-manager version errors

### Yarn version cannot be installed

Confirm that the version exists and supports the selected Node.js release. For Berry, verify `.yarnrc.yml` and any `yarnPath` file are committed.

### pnpm version cannot be installed

Confirm that `packageManager` contains an existing pnpm version and that the version supports the selected Node.js release.

Without an explicit version, the buildpack uses `pnpm@latest` and warns. Pin the version to prevent an unexpected major upgrade.

## Dependency installation fails

### npm lockfile is out of sync

```bash
npm install
npm test
git add package.json package-lock.json
git commit -m "Update npm lockfile"
```

### Yarn frozen or immutable install fails

```bash
yarn install
yarn test
git add package.json yarn.lock .yarnrc.yml .yarn
git commit -m "Update Yarn project files"
```

Commit only the `.yarn` files required by the project’s chosen Yarn workflow.

### pnpm frozen lockfile fails

```bash
pnpm install
pnpm test
git add package.json pnpm-lock.yaml
git commit -m "Update pnpm lockfile"
```

### Registry returns 401 or 403

Check:

- the token exists in Scalingo environment variables;
- the token has read access to the package or scope;
- `.npmrc` or `.yarnrc.yml` references the correct variable name;
- the registry hostname and scope match;
- the token was not revoked or expired.

Do not print the token while testing.

### Registry returns 404

A private registry can return 404 when authentication is missing. Check both package spelling/version and credentials.

### npm `ERESOLVE`

Review the peer-dependency conflict named in the log. Update incompatible packages or align their required versions. Avoid permanent force or legacy-peer-dependency flags unless the resulting graph has been tested.

### `EBADPLATFORM` or unsupported architecture

The package or its prebuilt binary does not support the Scalingo stack. Update it or see [Manage Native Modules and System Dependencies]({% post_url languages/nodejs/2000-01-01-extensions %}).

### Install script is blocked

New package-manager versions can require explicit policy for dependency lifecycle scripts. Review the exact package and configure the manager’s allowlist only after confirming the script is trusted and required.

### Build runs out of disk space

Reduce dependency and artifact size, remove unnecessary cache paths, and inspect large generated files. A log-capture or `ENOSPC` error can indicate the build filesystem filled during installation or compilation.

## The build script fails

### Build command is not found

The tool is probably absent from installed dependencies or development dependencies were disabled.

Check:

- the tool is declared in `devDependencies` or `dependencies`;
- `NPM_CONFIG_PRODUCTION=true` or `YARN_PRODUCTION=true` is not preventing installation;
- the script uses the local executable through the package manager rather than requiring a global install.

### Both `build` and `scalingo-postbuild` exist

Only `scalingo-postbuild` runs. Put the complete Scalingo build command there, or remove it to use the normal `build` script.

### `NODE_BUILD_FLAGS` has no effect

The variable is forwarded only to `build`, not to `scalingo-prebuild`, `scalingo-postbuild`, or `scalingo-cleanup`.

### Build runs out of memory

Inspect the selected container/build limits, framework memory requirements, and `NODE_OPTIONS`.

```bash
scalingo --app my-app env-set NODE_OPTIONS="--max-old-space-size=2048"
```

A higher heap limit does not increase the actual container limit. Reduce parallel build work or generated artifact size when possible.

### Native module compilation fails

Find the first compiler error, not only the final package-manager summary. Check Node.js compatibility, system libraries, compiler/Python requirements, and package versions.

## The application does not boot

### No start script

Define:

```json
{
  "scripts": {
    "start": "node server.js"
  }
}
```

The buildpack supplies `web: npm start` by default.

### Boot timeout

The web process must listen on the platform port:

```js
const port = Number.parseInt(process.env.PORT, 10);
server.listen(port, "0.0.0.0");
```

Check that:

- the process reads `PORT`;
- it binds to `0.0.0.0` rather than only `127.0.0.1`;
- startup does not wait indefinitely for a database migration or external service;
- the `Procfile` command matches the built output;
- the application does not crash before opening the port.

### A `Procfile` starts the wrong command

An explicit `Procfile` overrides the default process metadata. Compare it with `scripts.start` and the files produced by the build.

### Next.js times out

Use:

```json
{
  "scripts": {
    "start": "next start -H 0.0.0.0 -p $PORT"
  }
}
```

For standalone mode, start `.next/standalone/server.js` and copy required static/public assets. See [Deploy Next.js]({% post_url languages/nodejs/frameworks/2000-01-01-nextjs %}).

## The application crashes at runtime

### `module not found`, `ng: not found`, or `nest: not found`

A runtime requirement was probably declared in `devDependencies` and pruned after the build.

Move it to `dependencies`, reinstall, commit the lockfile, and redeploy.

Use a skip-pruning variable only when the application architecture genuinely requires build dependencies at runtime.

### Native library cannot be loaded

The package may have been compiled for another Node.js version or operating system, or a runtime shared library is missing. Do not commit `node_modules`. Reinstall for the selected Node.js version and verify system packages remain in the runtime image.

### Out-of-memory restart

Check container memory metrics and the number of Node.js processes. `NODE_OPTIONS=--max-old-space-size=...` applies per process and does not include all native memory.

Reduce worker count, reduce application memory, or choose a larger container. See [Manage Node.js Web Concurrency]({% post_url languages/nodejs/2000-01-01-managing-web-concurrency %}).

### The process does not shut down gracefully

Ensure the Node.js process receives `SIGTERM`. Avoid unnecessary Yarn or shell wrappers in the `Procfile` when signal forwarding is uncertain.

```text
web: node server.js
```

Add a termination handler and stop accepting new work before exiting.

## Cache-related problems

Symptoms can include an unexpected old artifact, a native binary mismatch, or a package-manager cache that is not restored.

Disable caching for one build:

```bash
scalingo --app my-app env-set NODE_MODULES_CACHE=false
```

After a successful clean build, re-enable it:

```bash
scalingo --app my-app env-set NODE_MODULES_CACHE=true
```

Also review custom `cacheDirectories`. A custom cache can preserve outputs the buildpack does not know how to invalidate.

Do not use cache clearing as a substitute for committing a synchronized lockfile.

## Private Git dependency fails

For public repositories, use an HTTPS URL pinned to a tag or commit. For private SSH dependencies, configure the SSH Private Key Buildpack and verify host-key configuration.

Never place a private key in `package.json`, `.npmrc`, or repository files.

## Collect information before contacting support

Include:

- the application name and region;
- the failed deployment date and approximate time;
- the Scalingo stack;
- the requested and resolved Node.js versions;
- package manager, version, and lockfile;
- the first specific error and surrounding log lines;
- whether the failure occurs during build, boot, or runtime;
- recent changes to Node.js, package manager, lockfile, buildpacks, or environment variables;
- whether a clean-cache build changes the result.

Remove tokens, private URLs containing credentials, environment values, and other secrets before sharing logs.

## Related documentation

- [Node.js on Scalingo]({% post_url languages/nodejs/2000-01-01-start %})
- [Select a Node.js Version]({% post_url languages/nodejs/2000-01-01-selecting-a-version %})
- [Default Node.js Build and Runtime Behavior]({% post_url languages/nodejs/2000-01-01-default-behavior %})
- [Customize Node.js Builds]({% post_url languages/nodejs/2000-01-01-customizing %})
- [Manage Native Modules and System Dependencies]({% post_url languages/nodejs/2000-01-01-extensions %})
