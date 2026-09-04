---
title: Autoscaling with Judoscale
logo: judoscale
category: integration
kind: demo
partner: Judoscale
permalink: /tutorials/judoscale
modified_at: 2026-09-04
last_reviewed_at: 2026-09-03
---

[Horizontal scaling][scaling] changes the number of containers that run a
[process type][procfile]. Scalingo includes a built-in
[autoscaler][scalingo-autoscaler] that watches platform metrics such as
requests per minute, response time, CPU, and memory.

If you need more control over your autoscaling behavior or want to use
metrics such as request queue time and background job queues,
you can use Judoscale.
[Judoscale][judoscale] is a third-party autoscaler with its own account and
billing. It is not part of the Scalingo product.

{% warning %}
Do not enable Judoscale and the Scalingo Autoscaler on the same process type.
Two autoscalers issuing scale commands for the same process type produce
unpredictable results.
{% endwarning %}


## Before You Start

- You need an application already deployed on Scalingo.
- Sign up for a free [Judoscale account][judoscale-signup].
- Judoscale authenticates to Scalingo with an [API token][api-tokens]. Tokens
  inherit the permissions of the account that created them. See the
  [security best practices][token-practices] if you want to scope access
  through a dedicated account.

Judoscale collects queue-time metrics through an adapter package in your
application. Official adapters exist for common web frameworks and job
backends, including Rails, Django, Express, FastAPI, Sidekiq, Celery, and
BullMQ. See the [supported adapters][judoscale-adapters].

If no adapter exists for your stack, you can still scale on a
[schedule][judoscale-schedules] without installing a package, or
[build a custom adapter][judoscale-custom-adapter].


## Connecting Scalingo to Judoscale

1. Sign up for Judoscale, or sign in, and choose **Scalingo** as the hosting
   platform.

2. Create an API token:
   1. Open the [API Tokens][account-tokens] page in your Scalingo account
      dashboard
   2. Create a token and give it a recognizable name, for example `Judoscale`
   3. Copy the token immediately. Scalingo displays it only once.

3. Paste the API token into Judoscale and confirm the connection.

   Judoscale uses the token to list your projects and applications, and later
   to change the number of running containers. It does not scale anything
   until you enable autoscaling for a process type.

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_judoscale_add_project.png" %}
{% include mdl_img.html %}
{:start="4"}

4. Select the [project][projects] that contains the application you want to
   autoscale.

5. Select the application to link. Judoscale lists that application's process
   types and opens the team dashboard. Autoscaling will not be enabled until
   you explicitly turn it on.

{% note %}
Scalingo organizes applications under projects. Linking a project in
Judoscale creates a Judoscale team for that project. Projects with no
applications cannot be linked. You can link additional projects later.
{% endnote %}


## Installing the Adapter Package

1. In the Judoscale team dashboard, click **Set up** on the process type you
   want to autoscale.

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_judoscale_dashboard.png" %}
{% include mdl_img.html %}
{:start="2"}

2. Follow the setup wizard: choose your language, framework, and job backend
   if you have one. The wizard shows the exact package to install.

   For example, a Rails application that uses Sidekiq adds these gems:

   ```ruby
   gem "judoscale-rails"
   gem "judoscale-sidekiq"
   ```

   For other stacks, use the package names shown in the wizard. The adapter
   reports queue-related metrics for web and worker process types. It does not
   impact how your application handles requests or jobs.

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_judoscale_setup.png" %}
{% include mdl_img.html %}
{:start="3"}

3. Set the `JUDOSCALE_URL` environment variable on the Scalingo application.
   The wizard provides the value. Add it from the **Environment** tab of your
   application dashboard, or with the CLI:

   ```bash
   scalingo --app my-app env-set JUDOSCALE_URL="https://adapter.judoscale.com/api/..."
   ```

   Treat `JUDOSCALE_URL` like an ingest key: do not commit it to git or share
   it publicly. See [environment variables][environment].

4. Commit the adapter package and deploy the application:

   ```bash
   git add .
   git commit -m "Add Judoscale adapter"
   git push scalingo main
   ```

   Then confirm the setup in the Judoscale wizard. Deployment starts new
   containers with the updated environment.

   After a successful setup, Judoscale shows queue-time charts for that
   process type. Charts will appear empty if the web process has no traffic,
   or if the worker process has no jobs waiting.

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_judoscale_graph.png" %}
{% include mdl_img.html %}

## Configuring and Enabling Autoscaling

1. If a [Scalingo Autoscaler][disable-autoscaler] is enabled for this process
   type, disable it first.

2. On the Judoscale Scaling page, set the minimum and maximum number of
   containers.

   There is no required range. A common starting point is to keep the current
   number of containers as the minimum, so enabling autoscaling does not
   immediately downscale. The maximum is the cost ceiling: under sustained high
   queue time, Judoscale upscales until it reaches that limit.

3. Review the other defaults. They are a reasonable starting point for most
   applications. You can change them after you have seen the charts under
   real load.

{% assign img_url = "https://cdn.scalingo.com/documentation/screenshot_judoscale_trigger.png" %}
{% include mdl_img.html %}
{:start="4"}

4. Save and enable autoscaling.

Repeat the adapter setup and enablement for each additional process type you
want to autoscale, such as a `worker` process.


## Scaling Workers

Judoscale can autoscale worker process types on job queue time (also called
queue latency). After the adapter is installed and `JUDOSCALE_URL` is set,
open the worker process type in Judoscale and enable autoscaling the same way.


## Differences Between Judoscale and Scalingo Autoscaler

Both autoscalers adjust the number of containers running for a process type,
but they use different metrics and provide different configuration options.

The [Scalingo Autoscaler][scalingo-autoscaler] is built into the platform and does not require an
adapter or an account with another service. It can scale using requests per
minute, response time, 5xx errors, CPU, RAM, or swap usage.

Judoscale uses request queue time for web process types and job queue time for
worker process types, measuring how long requests or jobs wait before
processing begins. Judoscale also provides controls for upscale
sensitivity and jumps, downscale delays, and scheduled container ranges. Its
charts display queue metrics and scaling activity, so you can see exactly how
your autoscaler responds to application load.

The Scalingo Autoscaler offers a simpler, platform-native setup. Judoscale is
an alternative when queue-based metrics, additional controls, or more detailed
visibility are useful for your application. Use only one autoscaler for each
process type.


## Pricing

You can use Judoscale for free with up to 20 autoscales per month. That
usually covers a trial or a staging app. For production, you will want a
paid account.

Paid plans have unlimited autoscaling. Which plan you need depends on how
many containers you want to scale. See [Judoscale pricing for
Scalingo][judoscale-pricing].


## Further Reading

- [Scaling an application][scaling]
- [Scalingo Autoscaler][scalingo-autoscaler]
- [Judoscale getting started on Scalingo][judoscale-scalingo]
- [Supported adapters][judoscale-adapters]
- [Judoscale pricing for Scalingo][judoscale-pricing]


[judoscale]: https://judoscale.com
[judoscale-signup]: https://judoscale.com/sign-up
[judoscale-scalingo]: https://judoscale.com/docs/scalingo-getting-started
[judoscale-adapters]: https://judoscale.com/docs/adapter-config
[judoscale-pricing]: https://judoscale.com/scalingo-pricing
[judoscale-schedules]: https://judoscale.com/docs/leveraging-schedules
[judoscale-custom-adapter]: https://judoscale.com/docs/custom-adapter
[account-tokens]: https://dashboard.scalingo.com/account/tokens

[scaling]: {% post_url platform/app/scaling/2000-01-01-scaling %}
[scalingo-autoscaler]: {% post_url platform/app/scaling/2000-01-01-scalingo-autoscaler %}
[disable-autoscaler]: {% post_url platform/app/scaling/2000-01-01-scalingo-autoscaler %}#disabling-an-autoscaler
[procfile]: {% post_url platform/app/2000-01-01-procfile %}
[environment]: {% post_url platform/app/2000-01-01-environment %}
[projects]: {% post_url platform/projects/2000-01-01-overview %}
[api-tokens]: {% post_url platform/user-management/scalingo-account/2000-01-01-navigating %}#api-tokens
[token-practices]: {% post_url platform/user-management/teamwork/2000-01-01-best-practices %}#scoping-api-tokens
