---
title: Deploy with GitLab
modified_at: 2023-06-07 00:00:00
tags: scm gitlab deployment
index: 6
---

{% note %}
This page explain how to deploy your application when `git push`-ing to your
GitLab repository. In order to automatically deploy your application using
GitLab CI/CD, please refer to the [GitLab CI/CD]({% post_url
platform/deployment/continuous-integration/2000-01-01-deploy-scalingo-from-gitlab
%}) page.
{% endnote %}

You can deploy your Scalingo application with a code hosted on GitLab: either
the SaaS version at [https://gitlab.com/](https://gitlab.com/) or a self-hosted
version. You will have to link it to a GitLab repository and branch.

{% note %}
To avoid remote error, you may want to configure your GitLab CI jobs with the [`GIT_STRATEGY`](https://docs.gitlab.com/ee/ci/runners/configure_runners.html#git-strategy) set to `clone`.
The deployment will be a bit slower but the option allows Scalingo to clone the repository from scratch for every job and ensure that the local working copy is always pristine.
{% endnote %}

## Link Your App to the SCM Tool

You first need to link your Scalingo account with your GitLab account. This is
achieved with the following command:

* For GitLab:

```
$ scalingo integrations-add gitlab
```

* For GitLab self-hosted:

```
$ scalingo integrations-add --url https://gitlab.example.org --token <token> gitlab-self-hosted
```

The `token` can be:

* [A `Personal access token`](https://docs.gitlab.com/user/profile/personal_access_tokens/) with the `api` and `read_user` scopes. Your account must also have [a sufficient role, maintainer or owner](https://docs.gitlab.com/ee/user/permissions.html#project-members-permissions)

* [A `Group access token`](https://docs.gitlab.com/user/group/settings/group_access_tokens/) with the `api` scope and at least the [maintainer role](https://docs.gitlab.com/ee/user/permissions.html#project-members-permissions).

As of now, [`Project access token`](https://docs.gitlab.com/user/project/settings/project_access_tokens/) are not supported.

Then, add and configure a link between your Scalingo application and the
GitLab-hosted repository with:

```
$ scalingo --app my-app integration-link-create --auto-deploy --branch master https://gitlab.example.org/my-company/my-app
```

A comprehensive list of available configuration flags is available with:

```
$ scalingo help integration-link-create
```

## Deployments

When your application is linked to the GitLab repository some deployments
options are available:

With "Auto deploy" enabled, your application will be deployed every time you
push to a selected branch of your repository. You can enable the "Auto deploy"
on your application when creating the link or later, with the following command:

```
$ scalingo --app my-app integration-link-update --auto-deploy --branch master
```

You can also trigger a manual deployment to choose a specific branch to
deploy:

```
$ scalingo --app my-app integration-link-manual-deploy master
```

You can get all information about your GitLab integration configuration with:

```
$ scalingo --app my-app integration-link
```

{% note %}
It is possible on GitLab CI to enable an option on jobs (named `allow_failure`) that allows failed jobs to still execute others jobs.
We take it into consideration when deploying your application or your review apps.<br>
If one or more of your GitLab jobs failed but have this option enabled, the deployment on Scalingo will be triggered.<br>
But if one job without the option failed, the deployment will be aborted.
{% endnote %}

## Review Apps

Review apps are special type of applications linked to a merge request. They can
be created automatically every time a merge request is opened or they can be
created manually by selecting the merge request to deploy among the currently
opened ones.

By default, review apps are automatically destroyed when the merge request is
closed. But you can specify a duration after which the review app is destroyed:

```
$ scalingo --app my-app integration-link-update --deploy-review-apps --destroy-on-close --hours-before-destroy-on-close 3
```

Manually create a review app with:

```
$ scalingo --app my-app integration-link-manual-review-app 4
```

`4` being the ID of the merge request.

For more information, you can read the more specific documentation pages [SCM
integration, Auto Deploy and Review Apps]({% post_url
platform/app/2000-01-01-scm-integration %}) and [Review Apps]({% post_url
platform/app/2000-01-01-review-apps %}).

You can get all information about your GitLab integration configuration with:

```
$ scalingo --app my-app integration-link
```

## Some suggestions

You can also create a [child app]({% post_url platform/app/2000-01-01-child-apps
%}) which is not a review app.
