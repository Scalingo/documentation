---
title: Configuring Login Providers in Keycloak
logo: keycloak
category: security
kind: demo
permalink: /tutorials/keycloak-authentication
modified_at: 2026-10-21
---
[Keycloak][keycloak-homepage] is an open-source identity and access management
solution. It lets applications authenticate users with credentials managed by
Keycloak or through external identity providers.

In this tutorial, **your application** is the application that sends people to
Keycloak to sign in. A **user** is one of those people.

## Planning your Configuration

- Keycloak must already be deployed on Scalingo. You can use our
  [Deploying Keycloak tutorial][keycloak-deployment] to deploy it.
- Your application must support OpenID Connect. In this tutorial, we
  use `https://my-app.osc-fr1.scalingo.io` as the application URL.
- Email verification and password recovery require an SMTP service.
- Google login requires a Google Cloud project. We create its production
  OAuth client below.
- Two factor authentication requires an authenticator application that
  supports time based one time passwords (TOTP).

## Configuring Keycloak

### Creating the Realm

A [realm][kc-realms] contains its own users, authentication settings, and
identity providers. The `app-auth` realm keeps the settings for this
application separate from the other realms.

1. Open the Keycloak Admin Console at `https://auth.example.com/admin/` and
   sign in with your administrator account.

2. Open the realm selector at the top left and click **Create realm**.

3. Enter `app-auth` in **Realm name** and keep **Enabled** set to **On**.

4. Click **Create**. Keycloak selects the new realm automatically.


### Creating the Application Client

A client identifies your application to Keycloak and defines where Keycloak
may redirect users after sign-in. One client serves all three login methods
because the application always connects to Keycloak.

We use the browser-based authorization code flow so the application receives
tokens without handling user passwords.

1. In the Keycloak Admin Console, open the realm selector at the top left and
   select `app-auth`. Then open **Clients** → **Create client**.

2. Set **Client type** to **OpenID Connect** and **Client ID** to
   `scalingo-app`. Click **Next**.

3. Enable **Standard flow** and disable **Direct access grants**.

4. Set **Client authentication** to **On** for a backend application, or
   **Off** for a browser only application. Click **Next**.

5. In **Login settings**, enter:

   | Setting                            | Value                                                                                 |
   | ---------------------------------- | ------------------------------------------------------------------------------------- |
   | Root URL                           | `https://my-app.osc-fr1.scalingo.io`                                                  |
   | Home URL                           | `https://my-app.osc-fr1.scalingo.io`                                                  |
   | Valid redirect URIs                | Your exact HTTPS callback, such as `https://my-app.osc-fr1.scalingo.io/auth/callback` |
   | Web origins (browser applications) | `https://my-app.osc-fr1.scalingo.io`                                                  |

   Use the callback route required by your OIDC library. Registering its exact
   URI prevents Keycloak from sending the sign-in response to an unintended
   address. Click **Save**.

6. For a backend application, copy the **Client secret** from **Credentials**.
   For a browser application, open **Settings** → **Capability config**, set
   **PKCE method** to **S256**, and save.


### Connecting your Application

Your application uses OpenID Connect to communicate with Keycloak. Keycloak
checks passwords or brokers sign-in through Google or Pro Santé Connect for example, then
returns the result to your application. The settings below identify the realm,
client, and callback used for this exchange.

1. Open your application's OIDC configuration.

2. Enter the following settings:

   | Setting                     | Value                                              |
   | --------------------------- | -------------------------------------------------- |
   | Issuer                      | `https://auth.example.com/realms/app-auth`         |
   | Client ID                   | `scalingo-app`                                     |
   | Client secret               | Your client secret, for backend applications only  |
   | Redirect URI                | The callback registered in **Valid redirect URIs** |
   | Scopes                      | `openid profile email`                             |
   | Flow                        | Authorization code                                 |
   | PKCE (browser applications) | `S256`                                             |

3. Save the configuration and deploy your application.

See the [Keycloak integration documentation][kc-app-integration] for your
framework's settings. Your application can now redirect users to Keycloak
to sign in. Keycloak returns an authorization code to the registered callback,
which your OIDC library exchanges for tokens.


## Configuring Email and Password Login with 2FA

### Email and Password Login

Keycloak manages the passwords for this login method. Email verification
confirms that users control the address used for password recovery; SMTP
delivers both verification and reset emails.

1. Open **Realm settings** → **Login** and configure:
   - Login with email: **On**
   - Duplicate emails: **Off**
   - Email as username: **Off**
   - Verify email: **On**
   - Forgot password: **On**

   Users can sign in with either their username or email address, and each
   email address belongs to one account.

2. Open **Realm settings** → **Email**. Enter your SMTP settings and save.

3. Open **Authentication** → **Policies** → **Password policy**. Add your
   application's password requirements and save. The policy applies to the
   initial password and later password changes.

4. Open **Users** → **Add user** to create a Keycloak account for someone who
   will sign in to your application. Enter their details:
   - Username: the user's username
   - Email: the user's email address
   - Email verified: **Off**
   - Required user actions: **Verify Email**

   Complete any other required profile fields and save the user.

5. Open **Credentials**. Set a password that meets the realm's policy, enable
   **Temporary**, and save.

At the first login, the user verifies their email and replaces the temporary
password.

### Enabling Two-Factor Authentication

TOTP adds a code from an authenticator application to the password check.
Keycloak's default browser flow asks for this code only when the user already
has an OTP credential. We copy the flow to require OTP after password sign-in
and prompt users without an OTP credential to enroll.

1. Open **Authentication** → **Policies** → **OTP policy**. Set the type to
   **Time based**, the number of digits to **6**, and the OTP token period to
   **30 seconds**, then save. Six digits provide one million possible values,
   while the 30-second period reduces the time an exposed code can be used.

2. In **Authentication** → **Required actions**, ensure **Configure OTP** is
   enabled and **Set as default action** is off.

3. Open **Authentication** → **Flows**. Duplicate the `browser` flow as
   `browser-email-otp`.

4. Expand the copied flow's **forms** sub-flow. Keep **Username Password
   Form** set to **Required**. Configure its **Conditional 2FA** sub-flow:

   | Execution                                  | Requirement  |
   | ------------------------------------------ | ------------ |
   | Conditional 2FA sub-flow                   | **Required** |
   | Condition - user configured                | **Disabled** |
   | Condition - credential (if present)        | **Disabled** |
   | OTP Form                                   | **Required** |
   | Other second factor executions, if present | **Disabled** |

5. Keep **Cookie**, **Identity Provider Redirector**, and the **forms**
   sub-flow set to **Alternative** so existing sessions and external provider
   logins can continue to use their own paths.

6. Open **Action** → **Bind flow**. Select **Browser flow** and save.

### Preserving OTP During Password Recovery

1. In **Authentication** → **Flows**, duplicate `reset credentials` as
   `reset-password-only`.

2. Disable **Reset - Conditional OTP** to preserve OTP during password resets.

3. Open **Action** → **Bind flow**. Select **Reset credentials flow** and save.

4. Open the **Send Reset Email** settings. Set **Alias** to
   `force-login-after-reset` and **Force login after reset** to **true**. Save.

Users must now sign in with their password and OTP after a password
reset.

## Connecting Google

When a user selects Google on the Keycloak login page, Keycloak redirects
them to Google, then creates or links an account in the `app-auth` Keycloak
realm after authentication. Your application still uses Keycloak as its OIDC
provider. The redirect URI below is where Google sends its response to
Keycloak, so the same URI must be registered in Google Cloud.

### Using the Keycloak and Google Consoles

1. In Keycloak, open **Identity providers** → **Add provider** → **Google**.
   Use the alias `google` and copy the displayed **Redirect URI**:
   ```text
   https://auth.example.com/realms/app-auth/broker/google/endpoint
   ```

2. In the [Google Cloud console][google-console], open **Google Auth Platform**
   → **Branding**. Enter your app name, contact details, home page, and privacy
   policy.

3. Complete [Google's production requirements][google-production], including
   domain ownership and any required verification.

4. Open **Audience**. Select **External**, then **Publish app**. Check that the
   status is **In production**.

5. Open **Clients** → **Create client**. Select **Web application**.

6. Paste the exact **Redirect URI** copied from Keycloak into **Authorized
   redirect URIs**. Click **Create** and copy the client ID and secret.

7. Return to the Google provider in Keycloak. Enter the client ID and secret,
   then click **Add**.

8. Set **Default scopes** to `openid profile email` and **First login flow**
   to `first broker login`. Keep **Trust Email** off and save. The scopes
   provide identity and email details, and the first login flow creates or
   links the Keycloak account.

9. Open your application in a private browser window. Start login and select
   **Google**.

After Keycloak completes its first-login checks, it returns the user to the
application. With **Verify email** enabled, Keycloak asks users to verify an
address that is not yet marked as verified.

## Connecting Pro Sante Connect

To let healthcare professionals sign in to your application with Pro Santé
Connect, request a production connection from the
[Agence du Numérique en Santé (ANS)][psc-access]. Follow the
[ANS Keycloak connector guide][psc-keycloak-guide] to connect Keycloak to
Pro Santé Connect. 

For production requirements and configuration details, see the
[ANS technical documentation][psc-technical] and the
[Keycloak and Pro Santé Connect webinar][psc-keycloak-webinar].


*[2FA]: Two-Factor Authentication
*[ANS]: Agence du Numérique en Santé
*[OIDC]: OpenID Connect
*[OTP]: One-Time Password
*[PKCE]: Proof Key for Code Exchange
*[SMTP]: Simple Mail Transfer Protocol
*[TOTP]: Time-based One-Time Password

[keycloak-homepage]: https://www.keycloak.org/
[keycloak-deployment]: {% link _tutorials/keycloak/index.md %}
[kc-realms]: https://www.keycloak.org/docs/latest/server_admin/index.html#proc-creating-a-realm_server_administration_guide
[kc-app-integration]: https://www.keycloak.org/securing-apps/overview
[google-console]: https://console.cloud.google.com/
[google-production]: https://developers.google.com/identity/protocols/oauth2/production-readiness/policy-compliance
[psc-access]: https://esante.gouv.fr/ens/offre/pro-sante-connect
[psc-technical]: https://esante.gouv.fr/ens/offre/pro-sante-connect/documentation-technique
[psc-keycloak-guide]: https://github.com/ansforge/keycloak-prosanteconnect#installation
[psc-keycloak-webinar]: https://esante.gouv.fr/webinaires/lutilisation-pro-sante-connect
