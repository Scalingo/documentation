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

[PostgREST][postgrest-homepage] is an open-source web server that automatically turns a PostgreSQL® database into a RESTful API. It allows developers to expose database tables, views, and functions directly through HTTP endpoints. PostgREST also supports filtering, pagination, relationships, and JSON responses out of the box. This makes it a lightweight and efficient option for building data-driven APIs with minimal application-layer code.

In this demo, we use PostgREST to expose a simple `todos` application, the same approach can be applied to other use cases.

## Planning your Deployment

- PostgREST obviously requires a PostgreSQL® database. For this demo we suggest to start with a a [PostgreSQL® Starter or Business 512 addon][pg]. 
- PostgREST has a very small base RAM footprint. It can operate comfortably with 100 to 400 MB of RAM, depending on concurrency, payload sizes, and JSON transformations. Consequently, we suggest to start with an M container for this demo.
- To handle requests, PostgREST separates authentication from authorization:
  - It **authenticates** the incoming HTTP request, typically by verifying a [JSON Web Token][jwt-homepage]. These tokens are usually generated and provided by an Identity Provider. If you already have one, please check its documentation to plug it to PostgREST. If not, an option that might be worth considering is Keycloak, for which we have a [tutorial][keycloak-tutorial].
  - It **authorizes** the resulting database operations, using roles, grants, views, functions, and Row-Level Security ([RLS]). We will setup all these hereafter.
- To keep this demo simple, we will focus on the Resource Owner Password Credentials (ROPC) grant type described in [RFC 6749][rfc6749]. With Keycloak, this flow is called [Direct Access Grants]. This flow mainly consists in converting user-provided credentials to a JWT.

## Understanding How Authorization Works in PostgREST

1. PostgREST exposes the PostgreSQL® database through an HTTP API.
2. Keycloak (or any Identity Service) authenticates the user and issues a corresponding JWT.
3. PostgREST verifies the JWT and extracts claims from it.
4. PostgREST impersonates a PostgreSQL® role using one of the extracted claim.
5. PostgreSQL® RLS distinguishes the individual user and retrieves the corresponding data.

## Deploying

### Using the Command Line

1. On your workstation, create an empty Git repository:
   ```shell
   mkdir my-postgrest
   cd my-postgrest
   git init
   ```

2. Create the application on Scalingo:
   ```shell
   scalingo create my-postgrest
   ```

3. Provision a Scalingo for PostgreSQL® Starter 512 add-on:
   ```shell
   scalingo --app my-postgrest addons-add postgresql postgresql-starter-512
   ```

4. Instruct the platform to use a specific buildpack to deploy PostgREST:
   ```shell
   scalingo --app my-postgrest env-set BUILDPACK_URL=https://github.com/Scalingo/postgrest-buildpack
   ```

5. Specify the version of PostgREST you want to deploy:
   ```shell
   scalingo --app my-postgrest env-set POSTGREST_VERSION=<version>
   ```

6. Set up the PostgreSQL® connection:
   ```shell
   scalingo --app my-postgrest env-set \
     PGRST_DB_URI=\$SCALINGO_POSTGRESQL_URL \
     PGRST_DB_SCHEMAS=api \
     PGRST_SERVER_PORT=\$PORT
   ```

### Setting Up the Database

1. Open a PostgreSQL® console:
   ```shell
   scalingo --app my-postgrest pg-console
   ```

2. From the PostgreSQL® console, create a schema that PostgREST will expose and another one that will stay private for internal helpers:
   ```sql
   CREATE SCHEMA api;
   CREATE SCHEMA private;
   ```

3. Create a helper that reads the user ID from the JWT claims:
   ```sql
   CREATE FUNCTION private.jwt_sub()
   RETURNS text
   LANGUAGE sql
   STABLE
   AS $$
     SELECT current_setting('request.jwt.claims', true)::jsonb ->> 'sub';
   $$;
   ```

4. Create the `todos` table in the `api` schema:
   ```sql
   CREATE TABLE api.todos (
     id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
     owner_id text NOT NULL DEFAULT private.jwt_sub(),
     task text NOT NULL,
     done boolean NOT NULL DEFAULT false,
     created_at timestamptz NOT NULL DEFAULT now()
   );
   ```

   The `owner_id` column stores the JWT `sub` claim. Clients do not need to send this value when they create a todo item.

5. Enable and force RLS on the `todos` table:
   ```sql
   ALTER TABLE api.todos ENABLE ROW LEVEL SECURITY;
   ALTER TABLE api.todos FORCE ROW LEVEL SECURITY;
   ```

   `FORCE ROW LEVEL SECURITY` is important in this tutorial because the database role used by PostgREST also owns the table. A table owner can otherwise bypass RLS.

6. Create a dedicated policy for each CRUD operation:
   ```sql
   CREATE POLICY todos_select_own
   ON api.todos
   FOR SELECT
   USING (owner_id = private.jwt_sub());
   ```
   ```sql
   CREATE POLICY todos_insert_own
   ON api.todos
   FOR INSERT
   WITH CHECK (owner_id = private.jwt_sub());
   ```
   ```sql
   CREATE POLICY todos_update_own
   ON api.todos
   FOR UPDATE
   USING (owner_id = private.jwt_sub())
   WITH CHECK (owner_id = private.jwt_sub());
   ```
   ```sql
   CREATE POLICY todos_delete_own
   ON api.todos
   FOR DELETE
   USING (owner_id = private.jwt_sub());
   ```

### Setting Up Keycloak

1. Connect to the admin console of your Keycloak instance
2. Create a new realm named `postgrest-demo`
3. In the newly-created realm, create an OpenID Connect client with the following configuration:
   - Client ID: `postgrest-api`
   - Client authentication: **On**
   - Standard flow: **On**
   - Direct access grants: **On**
4. Open **Credentials**
5. Copy the client secret
6. Store it locally:
   ```bash
   export KEYCLOAK_CLIENT_SECRET="PASTE_THE_SECRET"
   ```

   By creating the realm and the client, we allow the application to authenticate users and validate tokens issued by Keycloak using the client credentials.

7. Add the PostgreSQL® role to the JWT:

   1. Open the dedicated client scope for `postgrest-api`
   2. Select **Add mapper** → **By configuration** → **Hardcoded claim**
   3. Configure the mapper with:
      - Name: `postgrest-role`
      - Token Claim Name: `role`
      - Claim value: your `POSTGREST_DB_USER`
      - Claim JSON Type: `String`
      - Add to access token: **On**
      - Add to ID token: **Off**
      - Add to userinfo: **Off**

      This configuration adds a fixed `role` claim to every access token issued for the client, allowing PostgREST to connect to PostgreSQL® using the Scalingo database role while relying on the user's unique `sub` claim to enforce RLS.

8. Add an audience to the access token:

   1. In the same dedicated client scope, select **Add mapper** → **By configuration** → **Audience**
   2. Configure the mapper with:
      - Name: `postgrest-audience`
      - Included Client Audience: `postgrest-api`
      - Add to access token: **On**
   3. Verify that the access token contains:
      ```json
      {
        "aud": "postgrest-api"
      }
      ```

      The audience ensures that PostgREST only accepts tokens issued for the `postgrest-api` client.

9. Create a user named `alice`:

   1. Create a new user named `alice`
   2. Complete the required profile fields
   3. Configure the user with:
      - Email verified: **On**
      - Required user actions: leave empty
   4. Set a password with:
      - Temporary: **Off**

      This ensures the user can request tokens directly with `curl` without requiring browser interaction or additional setup steps.

10. Store Alice's password locally:
   ```bash
   export ALICE_PASSWORD="ALICE_TEST_PASSWORD"
   ```

11. Set the public URL of the Keycloak endpoint that exposes the realm:
   ```bash
   export KEYCLOAK_URL="https://my-postgrest.<region>.scalingo.io"
   export KEYCLOAK_REALM="postgrest-demo"
   ```

12. Retrieve the JSON Web Key Set published by Keycloak:
   ```bash
   KEYCLOAK_JWKS="$(
     curl --fail --silent --show-error \
       "$KEYCLOAK_URL/realms/$KEYCLOAK_REALM/protocol/openid-connect/certs" \
     | jq --compact-output .
   )"
   ```

13. Configure PostgREST to verify Keycloak JWT signatures and validate the API audience:
   ```bash
   scalingo --app "$POSTGREST_APP" env-set \
     PGRST_JWT_SECRET="$KEYCLOAK_JWKS" \
     PGRST_JWT_AUD="postgrest-api"
   ```

{% note %}
Keycloak signing keys can be rotated. This happens when a new realm signing key is created and becomes the active key, for example by adding a key provider with a higher priority. In this case make sure to update `PGRST_JWT_SECRET` with the new JWKS.
{% endnote %}

### Deploying PostgREST

Everything required by PostgREST is now configured.

1. Deploy the API:
   ```bash
   git commit --allow-empty --message "Deploy PostgREST"
   git push scalingo main
   ```

## Testing

1. Set the public URL of the deployed application:
   ```bash
   export POSTGREST_URL="https://<postgrest-public-domain>"
   ```

2. In your terminal/console/shell, define a helper function that retrieves an access token from Keycloak:
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

2. Use the helper to retrieve an access token for user Alice:
   ```bash
   export ALICE_TOKEN="$(get_token alice "$ALICE_PASSWORD")"
   echo "$ALICE_TOKEN"
   ```

3. Verify that Alice's token contains claims similar to:
   ```json
   {
     "sub": "e393ad9b-598e-45a7-b853-a1e888ca680f",
     "preferred_username": "alice",
     "role": "$POSTGREST_DB_USER",
     "aud": "postgrest-api"
   }
   ```

   The exact `sub` value is generated by Keycloak and differs for every user.

4. Create a todo using Alice's access token. Alice does not need to provide `owner_id` explicitly:
   ```bash
   curl --fail --silent --show-error --request POST \
     "$POSTGREST_URL/todos" \
     --header "Authorization: Bearer $ALICE_TOKEN" \
     --header "Content-Type: application/json" \
     --header "Prefer: return=representation" \
     --data '{"task":"Deploy PostgREST on Scalingo"}' \
   | jq
   ```

   PostgreSQL® automatically fills `owner_id` from Alice's verified JWT `sub` claim.

5. List the todos using the same token:
   ```bash
   curl --fail --silent --show-error \
     "$POSTGREST_URL/todos?select=id,owner_id,task,done" \
     --header "Authorization: Bearer $ALICE_TOKEN" \
   | jq
   ```

   Alice should only receive her own rows. The HTTP endpoint is the same for every user, but PostgreSQL® returns different data thanks to the RLS policy that compares each row's `owner_id` with the authenticated user's verified JWT `sub` claim.

You now have a PostgREST API running directly on Scalingo, by using
PostgreSQL® and Keycloak and by using Row-Level Security
and JWT to isolate each user's data.

*[JWKS]: JSON Web Key Set
*[JWT]: JSON Web Token
*[RLS]: Row-Level Security
*[ROPC]: Resource Owner Password Credentials
*[CRUD]: Create Read Update Delete

[postgrest-homepage]: https://docs.postgrest.org
[rfc6749]: https://www.rfc-editor.org/info/rfc6749/#section-4.3
[postgrest-buildpack]: https://github.com/Amyti/postgrest-buildpack
[jwt-homepage]: https://www.jwt.io/
[RLS]: https://www.postgresql.org/docs/current/ddl-rowsecurity.html
[Direct Access Grants]: https://www.keycloak.org/docs/latest/server_admin/index.html#_oidc-auth-flows-direct
[pg]: {% link _posts/database/postgresql/about/2000-01-01-overview.md %}
[keycloak-tutorial]: {% link _tutorials/keycloak/index.md %}
