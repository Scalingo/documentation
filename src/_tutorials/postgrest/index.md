---
title: Deploying PostgREST with Keycloak
logo: postgresql
category: integration
products:
  - Scalingo for PostgreSQL®
kind: demo
permalink: /tutorials/postgrest
modified_at: 2026-09-17 00:00:00
last_reviewed_at: 2026-09-17
---

[PostgREST][postgrest-homepage] turns a PostgreSQL® database directly into a REST API and can run as
a standalone service. In this tutorial, we deploy PostgREST on Scalingo using the
[PostgREST buildpack][postgrest-buildpack], connect it to PostgreSQL® database, and use Keycloak to authenticate our users. The application we use as demo is a small TODOs API.

## Planning your Deployment

Before starting this tutorial, make sure you have the following tools and services available:

- Git
- [Scalingo CLI][scalingo-cli]
- curl
- jq
- An existing Keycloak deployment


If you do not already have Keycloak running on Scalingo, follow our
[Deploying Keycloak tutorial][keycloak-tutorial] first. This tutorial focuses
on deploying PostgREST and configuring Keycloak to authenticate requests to it.

{% warning %}
For simplicity, this tutorial requests access tokens using the Resource Owner
Password Credentials flow, called **[Direct Access Grants][Direct Access Grants]** in Keycloak.
{% endwarning %}


The request flow used throughout this tutorial is:

1. PostgREST exposes the PostgreSQL® database through an HTTP API.
2. Keycloak authenticates users and issues [JWT][jwt-homepage]
   (JSON Web Tokens).
3. PostgREST verifies the JWT signature and extracts its claims.
4. PostgreSQL® [Row-Level Security][postgres-rls] (RLS) uses these claims to
   decide which rows each user can access.


## Deploying PostgREST on Scalingo

PostgREST is distributed as a standalone binary. The
[PostgREST buildpack][postgrest-buildpack] downloads that binary and configures `/app/bin/postgrest` as the default `web`
process.


### Creating the Application

Create an empty Git repository:

```bash
mkdir my-postgrest
cd my-postgrest
git init
```

Create the application:

```bash
scalingo create my-postgrest
```

### Adding PostgreSQL

Provision a PostgreSQL addon, a Starter plan is sufficient for this tutorial. For production, choose a
plan that matches your availability and performance
requirements.

```bash
scalingo --app my-postgrest addons-add postgresql postgresql-starter-512
```
Scalingo exposes the database connection URI through `SCALINGO_POSTGRESQL_URL`, The value has this shape:

```text
postgresql://USERNAME:PASSWORD@DB_HOST:DB_PORT/DATABASE?sslmode=prefer
```

Keep the `USERNAME` value. We will use it later on this tutorial.

### Configuring the Buildpack

Configure the PostgREST buildpack:

```bash
scalingo --app my-postgrest env-set \
  BUILDPACK_URL="https://github.com/Scalingo/postgrest-buildpack" \
  POSTGREST_VERSION="16.4"
```

This command permit to install the version `16.4` of PostgREST

### Configuring PostgREST

Configure the PostgreSQL connection, the exposed schema and the Scalingo port:

```bash
scalingo --app my-postgrest env-set \
  PGRST_DB_URI='$SCALINGO_POSTGRESQL_URL' \
  PGRST_DB_SCHEMAS="api" \
  PGRST_SERVER_PORT='$PORT'
```

`PGRST_DB_URI` points directly to the connection URI created by the PostgreSQL
addon and `PGRST_SERVER_PORT` must use Scalingo assigned `PORT`.

## Creating the API in PostgreSQL

PostgREST builds its REST API from the PostgreSQL schema, so the database is the
API definition. Open a PostgreSQL console:

```bash
scalingo --app my-postgrest pgsql-console
```

### Creation of Schema and Helpers

Create a schema that PostgREST will expose and a private schema for internal helpers:

```sql
CREATE SCHEMA api;
CREATE SCHEMA private;
```

Create a helper that reads the Keycloak user ID from the JWT claims given by PostgREST:

```sql
CREATE FUNCTION private.jwt_sub()
RETURNS text
LANGUAGE sql
STABLE
AS $$
  SELECT current_setting('request.jwt.claims', true)::jsonb ->> 'sub';
$$;
```

Create the `todos` table in the `api` schema:

```sql
CREATE TABLE api.todos (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  owner_id text NOT NULL DEFAULT private.jwt_sub(),
  task text NOT NULL,
  done boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);
```

The `owner_id` column stores the Keycloak `sub` claim. Clients do not need to
send this value when they create a todo.

### Enabling Row-Level Security

Enable and force RLS on the database:

```sql
ALTER TABLE api.todos ENABLE ROW LEVEL SECURITY;
ALTER TABLE api.todos FORCE ROW LEVEL SECURITY;
```

`FORCE ROW LEVEL SECURITY` is important in this tutorial because the database
role used by PostgREST also owns the table. A table owner can otherwise bypass
RLS. Create one policy for each operation and exit the PostgreSQL console:

```sql
CREATE POLICY todos_select_own
ON api.todos
FOR SELECT
USING (owner_id = private.jwt_sub());

CREATE POLICY todos_insert_own
ON api.todos
FOR INSERT
WITH CHECK (owner_id = private.jwt_sub());

CREATE POLICY todos_update_own
ON api.todos
FOR UPDATE
USING (owner_id = private.jwt_sub())
WITH CHECK (owner_id = private.jwt_sub());

CREATE POLICY todos_delete_own
ON api.todos
FOR DELETE
USING (owner_id = private.jwt_sub());
```

These policies permit users to access and modify only the rows they own. At this point, the PostgreSQL side of the API is ready.  Now we need to configure Keycloak.


## Configuring Keycloak as the Identity Provider

PostgREST does not manage user accounts. You need an identity
provider to issue the JWTs, in this tutorial we use Keycloak and PostgREST validates Keycloak's
signature, reads selected claims from the token and passes the verified claims
to PostgreSQL for authorization.

### Creating the Realm and Client

First connect to your admin console of the Keycloak deployment and create a realm named:

```text
postgrest-demo
```

Keep the realm selected, then create an OpenID Connect client with:

- Client ID: `postgrest-api`
- Client authentication: **On**
- Standard flow: **On**
- Direct access grants: **On**

Save the client and open **Credentials**. Copy the client secret and keep it
locally:

```bash
 export KEYCLOAK_CLIENT_SECRET="PASTE_THE_SECRET"
```

By creating the realm and the client, we allow the application to authenticate users and validate tokens issued by Keycloak using the client credentials.

### Adding the PostgreSQL Role to the JWT

By default, PostgREST reads the `role` claim from authenticated JWTs and uses it as the PostgreSQL role for each request. For this role, we will use the PostgreSQL user created by the Scalingo PostgreSQL add-on. Open the dedicated client scope for `postgrest-api`, then select:

**Add mapper** -> **By configuration** -> **Hardcoded claim**

Configure:

- Name: `postgrest-role`
- Token Claim Name: `role`
- Claim value: your `POSTGREST_DB_USER`
- Claim JSON Type: `String`
- Add to access token: **On**
- Add to ID token: **Off**
- Add to userinfo: **Off**

This configuration adds a fixed role claim to every access token issued for the client, allowing PostgREST to connect to PostgreSQL using the Scalingo database role while  relying on user unique sub claim to enforce RLS.

### Adding an Audience

The audience claim identifies the intended recipient of the access token. By checking this, PostgREST can ensure that it only accepts tokens that were issued for the `postgrest-api` client that we have created. In the same dedicated client scope, select:

**Add mapper** -> **By configuration** -> **Audience**

Configure:

- Name: `postgrest-audience`
- Included Client Audience: `postgrest-api`
- Add to access token: **On**

The access token should then contain:

```json
{
  "aud": "postgrest-api"
}
```

### Create a user

Now, we will create a user named `alice`. Since the tutorial requests tokens directly with `curl`, configure this user
so that no browser interaction is required:

- Complete the required profile fields.
- Set **Email verified** to **On**.
- Keep **Required user actions** empty.
- Set a password with **Temporary** set to **Off**.

Store the password locally:

```bash
 export ALICE_PASSWORD="ALICE_TEST_PASSWORD"
```

## Configuring PostgREST to Trust Keycloak

Set the public URL of the Keycloak endpoint that exposes the realm:

```bash
 export KEYCLOAK_URL="https://my-postgrest.<region>.scalingo.io"
 export KEYCLOAK_REALM="postgrest-demo"
```

Keycloak publishes its public signing keys as a JSON Web Key Set (JWKS):

```bash
KEYCLOAK_JWKS="$(
  curl --fail --silent --show-error \
    "$KEYCLOAK_URL/realms/$KEYCLOAK_REALM/protocol/openid-connect/certs" \
  | jq --compact-output .
)"
```

Configure PostgREST to verify Keycloak JWT signatures and validate the API
audience:

```bash
scalingo --app "$POSTGREST_APP" env-set \
  PGRST_JWT_SECRET="$KEYCLOAK_JWKS" \
  PGRST_JWT_AUD="postgrest-api"
```

{% note %}
Keycloak can rotate signing keys. When a new signing key is activated, refresh
`PGRST_JWT_SECRET` with the current JWKS.
{% endnote %}

## Deploying the API

Everything required by PostgREST is now stored in the Scalingo application
environment and PostgreSQL database.

Now deploy the API:

```bash
git commit --allow-empty --message "Deploy PostgREST"
git push scalingo main
```

During the build, the PostgREST buildpack downloads the configured PostgREST
binary and registers it as the `web` process.

Set the public URL of the deployed application (we will use it after):

```bash
 export POSTGREST_URL="https://<postgrest-public-domain>"
```

## Testing the Keycloak and PostgREST Integration

Define a helper that requests a Keycloak access token:

```bash
get_token() {
  local username="$1"
  local password="$2"

  curl --fail --silent --show-error --request POST \
    "$KEYCLOAK_URL/realms/$KEYCLOAK_REALM/protocol/openid-connect/token" \
    --header "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "grant_type=password" \
    --data-urlencode "client_id=postgrest-api" \
    --data-urlencode "client_secret=$KEYCLOAK_CLIENT_SECRET" \
    --data-urlencode "username=$username" \
    --data-urlencode "password=$password" \
  | jq --raw-output '.access_token'
}
```

Request one token for Alice:

```bash
 export ALICE_TOKEN="$(get_token alice "$ALICE_PASSWORD")"
echo $ALICE_TOKEN
```

A token for Alice should contain claims similar to:

```json
{
  "sub": "e393ad9b-598e-45a7-b853-a1e888ca680f",
  "preferred_username": "alice",
  "role": "my_postgrest_1234",
  "aud": "postgrest-api"
}
```

The exact `sub` value is generated by Keycloak and differs for every user.

### Creating and Viewing Alice's Todo

First, create a todo using Alice's access token. Alice does not need to provide `owner_id` explicitly:

```bash
curl --fail --silent --show-error --request POST \
  "$POSTGREST_URL/todos" \
  --header "Authorization: Bearer $ALICE_TOKEN" \
  --header "Content-Type: application/json" \
  --header "Prefer: return=representation" \
  --data '{"task":"Deploy PostgREST on Scalingo"}' \
| jq
```

PostgreSQL automatically fills `owner_id` from Alice's verified JWT `sub` claim.

Then, read the todos using the same token:

```bash
curl --fail --silent --show-error \
  "$POSTGREST_URL/todos?select=id,owner_id,task,done" \
  --header "Authorization: Bearer $ALICE_TOKEN" \
| jq
```

Alice should only receive her own rows. The HTTP endpoint is the same for every user, but PostgreSQL returns different data because the RLS policy compares each row's `owner_id` with the authenticated user's verified JWT `sub` claim.

You now have a PostgREST API running directly on Scalingo, by using
PostgreSQL® and Keycloak and by using Row-Level Security
and JWT to isolate each user's data.

[keycloak-tutorial]: https://doc.scalingo.com/tutorials/keycloak
[scalingo-cli]: https://doc.scalingo.com/tools/cli/start
[postgrest-buildpack]: https://github.com/Amyti/postgrest-buildpack 
[postgrest-homepage]: https://docs.postgrest.org
[jwt-homepage]: https://www.jwt.io/
[postgres-rls]: https://www.postgresql.org/docs/current/ddl-rowsecurity.html
[Direct Access Grants]: https://www.keycloak.org/docs/latest/server_admin/index.html#_oidc-auth-flows-direct
