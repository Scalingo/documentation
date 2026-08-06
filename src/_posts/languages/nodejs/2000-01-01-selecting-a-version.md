---
title: Select a Node.js Version
nav: Select a Version
modified_at: 2026-08-06 00:00:00
tags: nodejs versions
index: 2
---

Declare the Node.js version for an application in the `engines.node` field of the root `package.json` file.

```json
{
  "engines": {
    "node": "24.x"
  }
}
```

When `engines.node` is absent, the buildpack resolves the current recommended long-term support (LTS) release. Declaring a version is still recommended because it makes the runtime policy visible in the repository and reduces unexpected changes when the default LTS line moves.

## Stack and Node.js version are separate

The Scalingo stack selects the Ubuntu base image. The `engines.node` field selects Node.js. Do not infer one from the other.

Each listed stack uses an Ubuntu long-term support (LTS) release.

| Stack | Base operating system | Status | Lifecycle |
| --- | --- | --- | --- |
| `scalingo-22` | Ubuntu 22.04 LTS | Deprecated | Discontinued on 1 June 2027 |
| `scalingo-24` | Ubuntu 24.04 LTS | Supported | Supported through May 2029 |
| `scalingo-26` | Ubuntu 26.04 LTS | Supported and latest | Supported through May 2031 |

At the time this draft was written, the Node.js buildpack exposed the same Node.js patch inventory on `scalingo-22`, `scalingo-24`, and `scalingo-26`:

| Node.js release line | `scalingo-22` (deprecated) | `scalingo-24` | `scalingo-26` |
| --- | ---: | ---: | ---: |
| Node.js 26 | `26.5.1` | `26.5.1` | `26.5.1` |
| Node.js 24 LTS | `24.18.1` | `24.18.1` | `24.18.1` |
| Node.js 22 LTS | `22.23.2` | `22.23.2` | `22.23.2` |

Changing the stack does not change `engines.node`, but it rebuilds the application against a different operating-system image. Retest native dependencies and system-library integrations after a stack migration.

## Recommended version format

Use a supported major-version range for most production applications:

```json
{
  "engines": {
    "node": "24.x"
  }
}
```

A major range allows a rebuild to receive patch and security updates within the selected release line.

| Requirement | Example | Update behavior | Recommended use |
| --- | --- | --- | --- |
| Major range | `24.x` | Receives newer 24.x patch releases | Recommended default |
| Compatible range | `^24.10.0` | Receives compatible versions allowed by semver | Use when the lower bound matters |
| Exact version | `24.18.1` | Remains on that exact release | Use only when a verified compatibility issue requires it |
| Wide range | `>=22` | Can cross major versions | Avoid unless the application is tested across every allowed major |

{% warning %}
An exact patch pin does not automatically move to a newer security or bug-fix release. Review and update exact pins regularly.
{% endwarning %}

## How the buildpack resolves the request

The buildpack reads `engines.node` as a semantic-version requirement and resolves it against the versions available in its inventory.

For example:

```json
{
  "engines": {
    "node": ">=24 <25"
  }
}
```

The build succeeds when at least one inventoried version matches the requirement. The most appropriate available version is installed and used both during the build and at runtime.

The build fails with a targeted message when:

- the value is not a valid semantic-version requirement;
- the value is valid but no available Node.js release matches it;
- the requested binary cannot be downloaded or its checksum cannot be verified.

## Wide ranges

Avoid a range such as `*` or `>=20` that can resolve across many future major versions. A new Node.js major can contain runtime, module ABI, or dependency-manager changes that the application has not been tested against.

The current buildpack warns about wide ranges and can limit their resolution to the Active LTS line. To opt out of that protection, set:

```bash
scalingo --app my-app env-set NODEJS_ALLOW_WIDE_RANGE=true
```

{% warning %}
Use `NODEJS_ALLOW_WIDE_RANGE=true` only when the application test suite validates every Node.js major version allowed by the range. A major-version range such as `24.x` is more predictable.
{% endwarning %}

## Available versions

The available patch versions are maintained in the buildpack inventory and change frequently. The [Node.js overview]({% post_url languages/nodejs/2000-01-01-start %}#nodejs-versions) shows the currently documented release lines.

For implementation-level verification, inspect:

- [the buildpack inventory][nodejs-buildpack-inventory];
- [the buildpack changelog][nodejs-buildpack-changelog].

Do not copy a patch-version table into several pages. Keep a single public source of truth and link to it.

## End-of-life versions

Node.js versions and Scalingo stacks have separate lifecycle policies. Node.js versions eventually stop receiving upstream security and maintenance updates. When the resolver identifies an end-of-life version, the current buildpack emits a warning that the release is unsupported and may become a build error in a future buildpack release.

Treat an end-of-life warning as an upgrade requirement, not as an informational message.

A safe upgrade workflow is:

1. Choose a supported target major line.
2. Update local development and continuous integration (CI) to that line.
3. Update `engines.node`.
4. Reinstall dependencies and refresh the lockfile with the selected package manager.
5. Test native dependencies, build tooling, and runtime behavior.
6. Deploy to a non-production application or review app.
7. Promote the change after checking startup logs, HTTP health, memory, and error rates.

Example upgrade:

```diff
 {
   "engines": {
-    "node": "22.x"
+    "node": "24.x"
   }
 }
```

## Node.js and package-manager versions are separate

`engines.node` selects Node.js. Package-manager versions are configured separately:

```json
{
  "engines": {
    "node": "24.x",
    "npm": "11.x"
  },
  "packageManager": "pnpm@10.15.0"
}
```

Use only the fields relevant to the committed lockfile. See [Use npm]({% post_url languages/nodejs/2000-01-01-npm %}), [Use Yarn]({% post_url languages/nodejs/2000-01-01-yarn %}), or [Use pnpm]({% post_url languages/nodejs/2000-01-01-pnpm %}).

## Troubleshooting version selection

### Invalid semantic-version requirement

Check that `engines.node` contains a valid semver expression rather than a label such as `lts`, `latest`, or a mistyped version.

```json
{
  "engines": {
    "node": "24.x"
  }
}
```

### No published version matches

The requested range is syntactically valid but does not match the buildpack inventory. Choose a currently available release line and redeploy.

### A native dependency fails after an upgrade

A Node.js upgrade can change the native module ABI or expose an outdated prebuilt binary. Remove locally generated `node_modules`, reinstall dependencies, update the affected package, and see [Manage Native Modules and System Dependencies]({% post_url languages/nodejs/2000-01-01-extensions %}).

### The build still uses an older version

Confirm that:

- `package.json` is at the deployed source root;
- the updated file was committed;
- the deployment log prints the expected `engines.node` request;
- the application was rebuilt rather than only restarted.

[nodejs-buildpack-changelog]: https://github.com/Scalingo/nodejs-buildpack/blob/master/CHANGELOG.md

[nodejs-buildpack-inventory]: https://github.com/Scalingo/nodejs-buildpack/tree/master/inventory
