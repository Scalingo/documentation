---
title: Deploy to Scalingo from Bitbucket
nav: Deploy from Bitbucket
modified_at: 2022-04-26 00:00:00
tags: ci deployment build bitbucket
index: 25
---

To setup **Continuous Deployment** from Bitbucket to Scalingo, please follow the
following steps. You can read more about Deployment Pipelines on the [Bitbucket
documentation](https://confluence.atlassian.com/bitbucket/how-to-write-a-pipe-for-bitbucket-pipelines-966051288.html).

### Setup a Deployment Pipeline

#### On Bitbucket

1. First add an SSH key to Bitbucket Pipelines. This keys will authenticate the
   user who deploys on Scalingo.
   [Documentation](https://confluence.atlassian.com/bitbucket/use-ssh-keys-in-bitbucket-pipelines-847452940.html).
2. Add a file named `bitbucket-pipelines.yml` at the root of your project
   containing:

```yml
pipelines:
  default:
    - step:
        name: Deploy to Scalingo
        deployment: production
        script:
          - echo "Deploying to production environment"
          - git push git@ssh.osc-fr1.scalingo.com:my-app.git HEAD
clone:
  depth: full
```

Note that the remote URL depends on the region of your application. You can get
it using our CLI with:

```bash
scalingo --app my-app git-show
```

3. Commit this new file and push it to Bitbucket.

#### On Scalingo

To deploy to Scalingo from Bitbucket, you'll have to add the public key
generated for Bitbucket Pipelines to the [SSH Keys
page](https://dashboard.scalingo.com/account/keys) on the Scalingo Dashboard.

{% note %}
You can create a dedicated user only for deployment from Bitbucket. You would
need to create a new user on Scalingo and add the SSH key to this account. One
of the pro is that if you name the user `scalingo-bitbucket-pipelines`, you
would see where the deployment event comes from in your Activity tab.

