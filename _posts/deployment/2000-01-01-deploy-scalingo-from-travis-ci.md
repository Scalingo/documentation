---
title: Deploy to Scalingo from Travis CI
modified_at: 2016-01-19 00:00:00
category: deployment
tags: ci deployment build travis-ci
order: 7
---

This page describes steps to setup **Continuous Deployment** from Travis CI to Scalingo. Follow this guide to automatically deploy to Scalingo after a successful build.

## Travis CI

Deploying to Scalingo is supported by the official [dpl](https://github.com/travis-ci/dpl#scalingo) tool. You can use it as a stand alone tool and combine it with your workflow.

### Setup `.travis.yml`

The **dpl** tool is used by Travis itself for deployment after builds. To trigger a deployment after a success build on Travis you have to add the `deploy` section to your `.travis.yml`:
```yaml
deploy:
  provider: scalingo
  api_key: <your Scalingo api token>
```

The recommanded way to add your `api_key` is to encrypt it through the `travis` tool:
```bash
# Install the travis command if you don't have it yet
gem install travis

# Run the encrypt command in your project root
travis encrypt <your Scalingo api token> --add deploy.api_key
```

If you don't want to use the `api_key`, you can specify `username` and `password`.

You can read more about [Environment Variables](https://docs.travis-ci.com/user/environment-variables/) and [Encryption keys](https://docs.travis-ci.com/user/encryption-keys) on the Travis documentation.

### Scalingo API Token

Your API token is available on the Profile page of [Scalingo Dashboard](https://my.scalingo.com/profile).

### Options

Beside of `provider` and `api_key` you can customize these optional parameters:

- **app**: App is the name of your app on Scalingo, it is extracted from the remote option. 
- **on**: Specify the branch to deploy from, default is `master`. Change this if your code is not on master. You can also trigger the deploy from any branch:
```yaml
deploy:
  on:
    all_branches: true
```
- **remote**: Default remote is `scalingo`. Change this if you have a different git remote name. 
- **username** and **password**: replace the `api_key` option.
