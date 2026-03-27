---
title: Deploying Lovable projects on Scalingo
logo: lovable
category: ai
permalink: /tutorials/lovable
modified_at: 2026-03-27
---

[Lovable][lovable-website] is an AI app builder that helps you create web applications from natural language prompts. It generates frontend code
based on the Vite framework, and you can easily export that code.


## Planning your Deployment

- In this tutorial, we deploy both the frontend of
  the application on a single `web` container of size M.

- To sync your project with GitHub from Lovable and keep your repository updated, follow this [tutorial][lovable-export-github].

- You need to have Git installed on your computer.

- You also need to have the [Scalingo CLI][cli-doc] installed.

## Migrate your application

First, clone your Lovable project locally:

```bash
git clone <url_of_your_repo>
```

Then open the project in your preferred IDE or code editor, such as Visual
Studio Code, Cursor, or any other editor you usually work with.

The next sections explain the required configuration changes to run this Vite application on Scalingo.

### Procfile

Scalingo uses a Procfile to determine how to start your application in
production. You can read more about it in the [Procfile documentation][procfile-docs].

At the root of your project, create a file named Procfile with the following
content:

```bash
web: NODE_ENV=development npm run dev
```

This tells Scalingo to run the `dev` script from your `package.json` when the application is deployed.

### Package.json

Scalingo installs packages from `devDependencies` during the build phase, then prunes them before starting the application. This means that only packages listed under `dependencies` are still available at runtime. For details, see the [Node.js runtime dependencies documentation][nodejs-devdependencies-doc].

In our case, this is important because the application relies on Vite at runtime. If Vite is only declared under `devDependencies`, the build succeeds, but the application fails to boot once deployed because Scalingo no longer finds it. To fix this, we will move the required packages to `dependencies`.

#### Move Dependencies

Now open your `package.json`, and move the following packages from
devDependencies to dependencies:

  - `vite`
  - `@vitejs/plugin-react-swc`
  - `lovable-tagger`
  - `autoprefixer`
  - `postcss`
  - `tailwindcss`

These packages are required for the application to start correctly on
Scalingo. If they remain in `devDependencies`, they are pruned after the
build phase and are no longer available at runtime.

Then run:

```bash
npm install
```

to update the package-lock.json file.

#### Set the listening port

In your `package.json`, the `dev` script should initially look like this:

```bash
"dev": "vite"
```

Scalingo assigns a port to your application through the `PORT` environment
variable. To make sure your app listens on the correct port, update the script
to:

```bash
"dev": "vite --port $PORT"
```

This ensures Vite starts on the port provided by Scalingo and allows the
platform to route traffic correctly to your application.

### Allow requests from your app

Because the application is started with Vite on Scalingo, you need to allow
your Scalingo hostname in the Vite server configuration.

Open `vite.config.ts` and add your application hostname to `allowedHosts` in the `server` section:

```ts
server: {
  host: "::",
  port: 8080,
  allowedHosts: ["<name_of_your_app>.<region>.scalingo.io"],
  hmr: {
    overlay: false
  }
}

```

This allows Vite to accept requests coming from your Scalingo domain instead of
rejecting them.

## [Optional] Migrate your Supabase database

If your Lovable project uses Supabase, you can also migrate your database to
Scalingo PostgreSQL.

### Dump your database

If you prefer using the Supabase CLI instead of the dashboard, you can follow the instructions [here][backup-supabase].

Otherwise, open your Supabase project, then go to **Database** in the left
sidebar. From there, open the **Backups** section and download the latest
available backup file.

Once the backup is downloaded, import it into your Scalingo PostgreSQL database by following the [Scalingo PostgreSQL import/export documentation][scalingo-pg-import-doc].

### Import your database

To import your database, you can use the [Scalingo PostgreSQL import/export documentation][scalingo-pg-import-doc]


## Conclusion

Lovable makes it easy to generate a frontend application, and Scalingo
provides a simple way to deploy it.

To run a Lovable project on Scalingo, you need a few adjustments: add a
Procfile, move the required runtime packages from devDependencies to
dependencies, make Vite listen on `$PORT`, allow your Scalingo hostname
in vite.config.ts and import your database.

Once these changes are in place, you can deploy your application on Scalingo
like any other project.

You have everything you need to get your Lovable app online on Scalingo.


[lovable-export-github]: https://docs.lovable.dev/integrations/github
[procfile-docs]: https://doc.scalingo.com/platform/app/procfile
[backup-supabase]: https://supabase.com/docs/guides/platform/backups
[nodejs-devdependencies-doc]: https://doc.scalingo.com/languages/nodejs/start#devdependencies-installation
[scalingo-pg-import-doc]: https://doc.scalingo.com/databases/scalingo-postgresql/import-and-export
[cli-doc]: https://doc.scalingo.com/cli
[lovable-website]: https://lovable.dev