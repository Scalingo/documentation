---
title: Integrate the open-source Parse server with your iOS app
modified_at: 2016-02-11 00:00:00
category: integration
tags: integration parse ios
---

## Introduction

Parse is shutting down the 28th January 2017, and all their users have to
migrate their backend to some place else. Hopefully the Parse team open-sourced
their server which ease a lot this process. This article will details how to

## Deploying Parse open-source server

Deploying the server is as simple as clicking here:

[![One click
deploy](https://cdn.scalingo.com/deploy/button.svg)](https://my.scalingo.com/deploy?source=https://github.com/ParsePlatform/parse-server-example)

Follow the instructions, fill the `MASTER_KEY` and `APP_ID` variables and the server
(https://github.com/ParsePlatform/parse-server-example)[https://github.com/ParsePlatform/parse-server-example]
will be deployed on Scalingo in a minute and you can start working with it directly.

## Integrate the deployed server to your iOS app

### Get the credentials

Once your server has been deployed, it is reachable at the URL:
`https://<appname>.scalingo.io`. The credentials for your server have been
defined before the deployment, if you need to recover them, they can be found
on your [dashboard](https://my.scalingo.com) in the 'Environment' tab, or with
our command line tool:

```bash
scalingo --app <appname> env
```

Look at the variables:

- `MASTER_KEY`
- `APP_ID`

They represents the credentials to you Parse server instance.

### Configure iOS SDK

The following snippet shows you how to configure your parse integration:

```objective-c
[ParseinitializeWithConfiguration:[ParseClientConfigurationconfigurationWithBlock:^(id<ParseMutableClientConfiguration> _Nonnull configuration) {
  configuration.applicationId = @"<APP_ID>";
  configuration.server= @"https://<appname>.scalingo.io/parse";
  configuration.clientKey = @"";
}]];
```

Note that the `clientKey` has to be kept empty when using your own server. That's
it, your app will be able to communicate with your own Parse service.
