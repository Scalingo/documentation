---
title: Deploying Lovable Projects on Scalingo
logo: lovable
category: ai
permalink: /tutorials/lovable
modified_at: 2026-03-27
---

[Lovable][lovable-website] is an AI app builder that helps you create web applications from natural language prompts. It generates frontend code
based on the [Vite][vite-website] framework.


## Planning your Deployment

- In this tutorial, we deploy the frontend of
  the application on a single `web` container of size M. This is enough for a typical frontend; if
  you expect higher traffic, you can choose a bigger size of container or add new instances of your `web` container.

- To sync your project with GitHub from Lovable and keep your repository updated, follow this [tutorial][lovable-export-github].

- If your project uses a database (e.g. Supabase), you will need to provision a database on Scalingo, such as a PostgreSQL addon.

## Migrating your Application

- Clone your Lovable project locally:

  ```bash
  git clone <url_of_your_repo>
  ```

- Open the project in your preferred IDE or code editor, such as Visual Studio Code, Cursor, or any other editor you usually work with.

### Creating the Procfile

At the root of your project, create a file named `Procfile` with the following
content:

```bash
web: npx serve --single dist --listen $PORT
```

This tells Scalingo to serve the static files from the `dist` directory on the port provided by the `PORT` environment variable.

### Package.json

Scalingo installs packages from `devDependencies` during the build phase, then prunes them before starting the application. This means that only packages listed under `dependencies` are still available at runtime. For details, see the [Node.js runtime dependencies documentation][nodejs-devdependencies-doc].

In our case, this is important because the application relies on Vite at runtime. If Vite is only declared under `devDependencies`, the build succeeds, but the application fails to boot once deployed because Scalingo no longer finds it. To fix this, let's move the required packages to `dependencies`.

Now open your `package.json` file, and move the following packages from
the `devDependencies` section to the `dependencies` one:

  - `vite`
  - `@vitejs/plugin-react-swc`
  - `lovable-tagger`
  - `autoprefixer`
  - `postcss`
  - `tailwindcss`

Update the `package-lock.json` file:

```bash
npm install
```

### Allowing Requests

Vite requires you to allow hostnames, so you need to add your Scalingo hostname to the Vite server configuration. This allows Vite to accept requests coming from your Scalingo domain instead of rejecting them.

Open `vite.config.ts` and add your application hostname to `allowedHosts` in the `server` section:

```ts
server: {
  host: "::",
  port: Number(process.env.PORT) || 8080,
  allowedHosts: ["<name_of_your_app>.<region>.scalingo.io"],
  hmr: {
    overlay: false
  }
}

```

## Migrating your Supabase Database to Scalingo

If your Lovable project uses Supabase, you may also want to migrate your database to Scalingo.

### Dumping your Lovable Database

To download a backup from the Supabase dashboard:

- Open your Supabase project.
- Go to **Database** in the left sidebar.
- Navigate to the **Backups** section.
- Download the latest available backup file.

You can also use the Supabase CLI to create the database dump. To do so, please follow [Supabase's instructions][backup-supabase].

### Importing your Database to Scalingo

Once the backup is downloaded, import it into your Scalingo PostgreSQL database by following the [Scalingo PostgreSQL documentation][scalingo-pg-import-doc].

## Conclusion

Now, you have everything you need to get your Lovable app online on Scalingo.

To keep your application up-to-date, regularly update your project code and dependencies, then redeploy the application on Scalingo.


[lovable-export-github]: https://docs.lovable.dev/integrations/github
[backup-supabase]: https://supabase.com/docs/guides/platform/backups
[nodejs-devdependencies-doc]: https://doc.scalingo.com/languages/nodejs/start#devdependencies-installation
[scalingo-pg-import-doc]: https://doc.scalingo.com/databases/postgresql/dedicated-resources/guides/restoring
[cli-doc]: https://doc.scalingo.com/cli
[lovable-website]: https://lovable.dev
[vite-website]: https://vite.dev/
