---
title: Manage Native Modules and System Dependencies
nav: Native Modules
modified_at: 2026-08-06 00:00:00
tags: nodejs native-modules dependencies
index: 10
---

Some Node.js packages contain native code or depend on operating-system libraries. Examples include database drivers, image-processing libraries, cryptography packages, browser automation tools, and packages built with `node-gyp`.

The installed artifact must match:

- the Node.js version and application binary interface (ABI);
- the Scalingo Linux stack;
- the container CPU architecture;
- required compiler and system libraries.

## Scalingo stack compatibility

A Scalingo stack is the Ubuntu base image used while compiling dependencies and while running the resulting application.

Each listed stack uses an Ubuntu long-term support (LTS) release.

| Stack | Base operating system | Status | Lifecycle |
| --- | --- | --- | --- |
| `scalingo-22` | Ubuntu 22.04 LTS | Deprecated | Discontinued on 1 June 2027 |
| `scalingo-24` | Ubuntu 24.04 LTS | Supported | Supported through May 2029 |
| `scalingo-26` | Ubuntu 26.04 LTS | Supported and latest | Supported through May 2031 |

The stack name does not select Node.js. For example, Node.js 24 can run on each of these stacks when it is available in the buildpack inventory.

The stack can change the versions of `glibc`, OpenSSL, compiler runtimes, image libraries, browser dependencies, and other shared libraries. A native package that works on one stack can therefore require a newer package release, a fresh compilation, or an additional operating-system package on another.

Inspect the current stack:

```bash
scalingo --app my-app apps-info
```

Inspect a stack image locally when reproducing an operating-system-level problem:

```bash
docker pull scalingo/scalingo-26:latest
docker run --rm -it scalingo/scalingo-26:latest bash
```

{% warning %}
Do not copy compiled modules between `scalingo-22`, `scalingo-24`, and `scalingo-26`. Redeploy and reinstall dependencies after a stack change.
{% endwarning %}

Before migration, test the application on the target stack and verify every dependency that compiles code, downloads a platform binary, launches a browser, or links to a shared library.

## Prefer maintained prebuilt binaries

Many native packages publish prebuilt binaries for common Node.js and Linux combinations. During installation, the package can download a matching binary instead of compiling from source.

Prefer packages that:

- publish binaries for supported Node.js LTS lines;
- verify downloaded artifacts;
- document supported operating systems and architectures;
- release updates promptly when Node.js changes its ABI;
- fall back to source compilation with clear errors.

A package upgrade can be required after changing Node.js major versions, even when the JavaScript API has not changed.

## Do not commit `node_modules`

Never use a locally generated `node_modules` directory as the deployment artifact.

```text
node_modules/
```

A native module compiled on macOS, Windows, another Linux distribution, or another CPU architecture can fail to load on Scalingo.

The npm compatibility path attempts `npm rebuild` when committed modules are detected, then installs missing dependencies. This does not guarantee that every committed artifact becomes valid, and it does not make committed modules a supported best practice.

Commit `package.json` and the package-manager lockfile instead.

## Source compilation during dependency installation

npm, Yarn, and pnpm run package lifecycle scripts during dependency installation. A package can use those scripts to invoke `node-gyp`, CMake, Rust, or another build system.

The availability of compiler tools, Python, and headers depends on the active Scalingo stack and build environment.

{% warning %}
Do not publish a fixed list of guaranteed compilers or Python versions until Engineering confirms it for every supported stack. When a package requires a specific toolchain, test it on each supported stack and document the requirement with the sample application.
{% endwarning %}

## Add operating-system packages

When a dependency requires an additional shared library or executable, add the [Advanced Package Tool (APT) Buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-apt %}) before the Node.js buildpack in a multi-buildpack configuration.

A typical application contains an `Aptfile` at the repository root:

```text
<required-system-package>
<another-system-package>
```

The exact package names depend on the Scalingo stack. Verify them against the stack’s package repository rather than copying names from another provider or Linux release.

After changing system dependencies:

1. clear or disable the deployment cache for one build;
2. rebuild native dependencies;
3. run the application’s startup and smoke tests;
4. verify that required shared libraries exist in the runtime image.

## Diagnose a native compilation failure

Look for the first compiler or package-manager error above the final buildpack summary. Common causes include:

- no prebuilt binary exists for the selected Node.js version;
- the package does not support the current CPU architecture or operating system;
- a required header or development library is missing;
- Python or a compiler is not available in the expected version;
- the package version is too old for the Node.js ABI;
- the build runs out of memory or disk space;
- an install script is blocked by package-manager policy.

A useful diagnostic sequence is:

```bash
rm -rf node_modules
npm ci
# or: yarn install --immutable
# or: pnpm install --frozen-lockfile
```

Then compare the local Node.js version with `engines.node` and the version printed in the Scalingo build log.

## Rebuild after a Node.js upgrade

When moving to another Node.js major:

1. update `engines.node`;
2. remove local `node_modules`;
3. reinstall dependencies;
4. update packages that do not support the new Node.js version;
5. commit the refreshed lockfile when it changes;
6. deploy with a clean cache if an old native artifact appears to be reused;
7. test every code path that loads the native module.

An error such as `NODE_MODULE_VERSION` mismatch usually means a binary was built for another Node.js ABI.

## Use Puppeteer or another headless browser

Browser automation packages often require a browser binary and several operating-system libraries. Treat them as a system-dependency deployment, not as a Node.js framework feature.

Recommended approach:

1. choose whether the project downloads its own compatible browser or uses a stack-installed browser;
2. add required system packages through the APT Buildpack;
3. configure the executable path through an environment variable or package configuration;
4. test startup, page rendering, fonts, Transport Layer Security (TLS), and sandbox behavior on the target stack;
5. monitor image size and memory.

Example application code:

```js
const browser = await puppeteer.launch({
  executablePath: process.env.PUPPETEER_EXECUTABLE_PATH,
  headless: true,
});
```

Avoid copying an old list of distribution packages into this page. Browser dependencies change frequently and differ by stack.

### Sandbox configuration

Some container recipes use `--no-sandbox` or `--disable-setuid-sandbox`. These flags reduce browser isolation.

{% warning %}
Document sandbox-disabling flags only when Scalingo Security and Engineering have validated the threat model and there is no supported sandboxed configuration. Do not present them as harmless defaults.
{% endwarning %}

## Packages with runtime shared libraries

A module can compile successfully but fail at runtime when a shared library is absent from the final image.

Typical symptoms include:

```text
error while loading shared libraries
```

or:

```text
Cannot open shared object file
```

Confirm that the system package is installed by a buildpack whose files remain available at runtime, not only in a transient build step.

## TypeScript and JavaScript build tools

TypeScript, Vite, webpack, esbuild, the Speedy Web Compiler (SWC), and similar tools are not native extensions by definition, but some of their packages can include native binaries.

Keep build-only tools in `devDependencies`. The buildpack installs them before the build script and prunes them afterward. A compiler needed by the runtime start command belongs in `dependencies`, or preferably the application should start from compiled output.

```json
{
  "scripts": {
    "build": "tsc -p tsconfig.build.json",
    "start": "node dist/server.js"
  },
  "devDependencies": {
    "typescript": "<project-version>"
  }
}
```

## Cache considerations

Native artifacts can become invalid when the Node.js version, package-manager behavior, stack, or system libraries change.

The buildpack invalidates its normal cache for several version and stack changes, but custom caches can preserve files that the buildpack cannot reason about. Do not place compiled native outputs in `cacheDirectories` unless the project validates their compatibility.

Temporarily disable cache during diagnosis:

```bash
scalingo --app my-app env-set NODE_MODULES_CACHE=false
```

## Information to include in a support request

Provide:

- application and region;
- Scalingo stack;
- requested and resolved Node.js versions;
- package manager and version;
- package name and version;
- the first relevant compiler or loader error;
- whether the failure occurs during build or runtime;
- the application’s APT or multi-buildpack configuration;
- whether a clean-cache build changes the result.

Remove registry tokens, private repository credentials, and other secrets from logs before sharing them.

## Related documentation

- [Select a Node.js Version]({% post_url languages/nodejs/2000-01-01-selecting-a-version %})
- [Customize Node.js Builds]({% post_url languages/nodejs/2000-01-01-customizing %})
- [APT Buildpack]({% post_url platform/deployment/buildpacks/2000-01-01-apt %})
- [Multi Buildpacks]({% post_url platform/deployment/buildpacks/2000-01-01-multi %})
- [Troubleshoot Node.js Deployments]({% post_url languages/nodejs/2000-01-01-troubleshooting %})
