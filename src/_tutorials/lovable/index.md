---
title: Deploying Lovable Projects on Scalingo
logo: lovable
category: migration-to-scalingo
permalink: /tutorials/lovable
modified_at: 2026-03-27
---

[Lovable][lovable-website] is an AI app builder that helps you create web applications from natural language prompts. It generates frontend code
based on the [Vite][vite-website] framework.


## Planning your Deployment

- Sizing your application vastly depends on your use-case and the amount of traffic it needs to handle. We usually recommend to start with an M container, and [adjust][scaling] later depending on the metrics of your application.

- If your project uses a database (e.g. Supabase), you may want to also migrate it to Scalingo. We usually advise to opt at least for a [PostgreSQL® Starter or Business 512 addon][pg-databases] for this purpose, and [change for a bigger plan][pg-changing-plan] later if need be.

## Migrating your Application

{% note %}
Before continuing, make sure your Lovable project is synced with GitHub. To do this, follow this [tutorial][lovable-export-github].
{% endnote %}

1. On your workstation, clone your GitHub repository:
   ```bash
   git clone <url_of_your_repo>
   ```

2. Create the application on Scalingo:
   ```bash
   scalingo create my-app
   ```

3. Create a `Procfile` at the root of your project with the following content:
   ```bash
   web: npx serve --single dist --listen $PORT
  ```
   This instructs the platform to serve the static files from the `dist` directory on the port provided by the `PORT` environment variable.

4. Scalingo installs packages from `devDependencies` during the build phase, then prunes them before starting the application. This means that only packages listed under `dependencies` are still available at runtime. For details, see the [Node.js runtime dependencies documentation][nodejs-devdependencies-doc].

   In our case, this is important because the application relies on Vite at runtime. If Vite is only declared under `devDependencies`, the build succeeds, but the application fails to boot once deployed because Scalingo no longer finds it.
   
   To fix this, let's move the required packages to `dependencies`:

   1. Open your `package.json` file, and move the following packages from the `devDependencies` section to the `dependencies` one:

      * `@vitejs/plugin-react-swc`
      * `lovable-tagger`
      * `autoprefixer`
      * `postcss`
      * `tailwindcss`

   2. Update the `package-lock.json` file:
      ```bash
      npm install
      ```

5. By default, Vite only responds to requests coming from hosts defined in its `server.allowedHosts` option, which defaults to `localhost`. To allow Vite to accept requests coming from your Scalingo domain, edit this option in your `vite.config.ts` file, so that it looks like this:
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

6. Commit and push the files you just updated:
   ```bash
   git add vite.config.ts package-lock.json package.json Procfile
   git commit -m "Migrate to scalingo"
   git push
   ```

7. Deploy to Scalingo:
   ```bash
   git push scalingo
   ```

## Migrating your Supabase Database to Scalingo

If your Lovable project uses Supabase, you may also want to migrate your database to Scalingo.

### Dumping your Lovable Database

To download a backup from the Supabase dashboard:

1. Open your Supabase project.
2. Go to **Database** in the left sidebar.
3. Navigate to the **Backups** section.
4. Download the latest available backup file.

You can also use the Supabase CLI to create the database dump. To do so, please follow [Supabase's instructions][backup-supabase].

### Importing your Database to Scalingo

Once the backup is downloaded, import it into your Scalingo PostgreSQL database by following the [Scalingo PostgreSQL documentation][scalingo-pg-import-doc].

## Updating your Application

If you update your project from Lovable later, the changes will be sync with your GitHub repository, make sure the following files still contain the changes described in this tutorial:

- `Procfile`
- `package.json`
- `package-lock.json`
- `vite.config.ts`

If necessary, reapply the changes, then commit and push them:
```bash
git add vite.config.ts package-lock.json package.json Procfile
git commit -m "Update Lovable project for Scalingo"
git push
```

And deploy on Scalingo:
```bash
git push scalingo
```

[lovable-website]: https://lovable.dev
[lovable-export-github]: https://docs.lovable.dev/integrations/github
[backup-supabase]: https://supabase.com/docs/guides/platform/backups
[vite-website]: https://vite.dev/
[pg-databases]: https://www.scalingo.com/databases/postgresql
[nodejs-devdependencies-doc]: {% post_url languages/nodejs/2000-01-01-start %}#devdependencies-installation
[scalingo-pg-import-doc]: {% post_url databases/postgresql/dedicated-resources/guides/2000-01-01-restoring %}
[cli-doc]: {% post_url tools/cli/2000-01-01-start %}
[scaling]: {% post_url platform/app/scaling/2000-01-01-scaling %}
[pg-changing-plan]: {% post_url databases/postgresql/shared-resources/guides/2000-01-01-changing-plan %}
