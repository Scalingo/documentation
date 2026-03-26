---
title: Deploying Lovable projects on Scalingo
logo: lovable
category: ai
permalink: /tutorials/lovable
modified_at: 2025-08-12
---

Lovable is an AI app builder that helps you create modern web
applications from natural language prompts. It generates production-ready
frontend code based on the Vite framework, and you can easily export the code.


## Planning your Deployment

- In this tutorial, we deploy both the frontend of
  the application on a single `web` container of size M.

- To sync your project with GitHub, follow this [tutorial][lovable-export-github].

- You need to have Git installed on your computer.

- You need also to have the [Scalingo CLI][cli-doc] installed

## Migrate your application

First, clone your Lovable project locally:

```bash
git clone <url_of_your_repo>
```

Then open the project in your preferred IDE or code editor, such as Visual
Studio Code, Cursor, or any other editor you usually work with.

From there, update the project configuration to make it ready for
deployment on Scalingo.

### Procfile

Scalingo uses a Procfile to determine how to start your application in
production. You can read more about it in the [Procfile documentation][procfile-docs].

At the root of your project, create a file named Procfile with the following
content:

```bash
web: NODE_ENV=development npm run dev
```

This tells Scalingo to run the start script from your package.json when the
application is deployed.

### Package.json

Scalingo installs packages from devDependencies during the build phase, then
prunes them before starting the application. This means that only packages
listed under dependencies are still available at runtime.

In our case, this is important because the application relies on Vite to start.
If Vite is only declared under devDependencies, the build succeeds, but
the application fails to boot once deployed because Scalingo no longer
finds it.

#### Move Dependencies

Now open your `package.json`, and move the following packages from
devDependencies to dependencies:

  - vite
  - @vitejs/plugin-react-swc
  - lovable-tagger
  - autoprefixer
  - postcss
  - tailwindcss

These packages are required for the application to start correctly on
Scalingo. If they remain in devDependencies, they are pruned after the
build phase and are no longer available at runtime. Now you need to do 

```bash
npm i
```

to update the package-lock.json file.

#### Set the listening port

In your package.json, the dev script should initially look like this:

```bash
"dev": "vite"
```

Scalingo assigns a port to your application through the `$PORT` environment
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
    overlay: false,
  },
},

```

This allows Vite to accept requests coming from your Scalingo domain instead of
rejecting them.

## Migrate your Supabase database

If your Lovable project uses Supabase, you can also migrate your database to
Scalingo PostgreSQL.

### Dump your database

Open your Supabase project, then go to **Database** in the left sidebar. From
there, open the **Backups** section and download the latest available backup
file.

Once the backup is downloaded, you can restore it to your Scalingo PostgreSQL
database using standard PostgreSQL tools such as `pg_restore` or `psql`.

If you prefer using the Supabase CLI instead of the dashboard, you can follow
the instructions [here][backup-supabase].

### Import your database

#### Add PostgreSQL and open a tunnel

Before importing your dump, add a PostgreSQL add-on to your Scalingo
application.

In the Scalingo dashboard, open your application, go to the `Resources` tab,
click `Add an addon`, and select `PostgreSQL`. Once the add-on is
provisioned, your database is ready. 

Then, open a tunnel from your local machine with the Scalingo CLI:

```bash
scalingo --app <your-app-name> db-tunnel SCALINGO_POSTGRESQL_URL
```

Keep this terminal open while running the import command from another one.

#### Restore the dump

Once the tunnel is open, you can import your dump into your Scalingo
PostgreSQL database from another terminal.

Run the following command:

```bash
pg_restore --clean --if-exists --no-owner --no-privileges --no-comments \
  --dbname "postgresql://<user>:<password>@127.0.0.1:<port>/<database>" \
  <dump_file>
````

This command restores the contents of your dump into your Scalingo PostgreSQL
database through the tunnel.

Make sure to replace `<user>`, `<password>`, `<database>`, `<port>` and `<dump_file>` with your own values.


## Conclusion

Lovable makes it easy to generate a modern frontend application, and Scalingo
provides a simple way to deploy it.

To run a Lovable project on Scalingo, you only need a few adjustments: add a
Procfile, move the required runtime packages from devDependencies to
dependencies, make Vite listen on `$PORT`, allow your Scalingo hostname
in vite.config.ts and import your database.

Once these changes are in place, you can deploy your application on Scalingo
like any other project.

You have everything you need to get your Lovable app online on Scalingo.


[lovable-export-github]: https://docs.lovable.dev/integrations/github
[procfile-docs]: https://doc.scalingo.com/platform/app/procfile
[backup-supabase]: https://supabase.com/docs/guides/platform/backups
[cli-doc]: https://doc.scalingo.com/cli
