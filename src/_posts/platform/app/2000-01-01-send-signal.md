---
title: Send a Signal to a Container
nav: Send Signal
modified_at: 2023-01-12 00:00:00
tags: app signal
---

## Introduction

Signals are standardized messages sent to a running program to trigger specific behavior.

On the Scalingo platform, sending signals is a useful way to trigger events while being the owner or collaborator of an application. This can be particularly useful for debugging purposes.

{% note %}
  The platform only handles `SIGUSR1` and `SIGUSR2`.
{% endnote %}

## General purpose of the feature

At Scalingo we often use signals handler to:

- Dump heap allocations
- Dump all stack traces
- Print the number of Goroutines
- Print the memory consumption
- etc…

## How to send a signal to an application ?

To send a signal to an application, multiple possibilities are available:

- The CLI provides a `send-signal` command.

```sh
$ scalingo -a my-app ps
+-------+---------+-------------+------+---------------------+
| NAME  | STATUS  |   COMMAND   | SIZE |     CREATED AT      |
+-------+---------+-------------+------+---------------------+
| web-1 | running | sample-test | M    | 2023/01/05 09:24:33 |
| web-2 | running | sample-test | M    | 2023/01/05 09:24:33 |
+-------+---------+-------------+------+---------------------+

$ scalingo -a my-app send-signal --signal SIGUSR1 web-1
-----> Sent signal 'SIGUSR1' to 'web-1' container.
```

- An API endpoint is available to send a signal. More information about the endpoint [here](https://developers.scalingo.com/apps#send-signal-to-a-container).

## Who catches the signal ?
{% warning %}
  When transmitted to the container, the signal is transmitted to the first process that started your application, also called the entry point.  
  Commonly, this entry point can be defined in the [Procfile](https://doc.scalingo.com/platform/getting-started/heroku-compatibility#procfile), so be careful on which process will catch the signal first.
{% endwarning %}

For example, on a Node.js application, the default command run by Scalingo is `npm start`, it runs a predefined command specified in the "start" property of a package's "scripts" object (usually named package.json).  
If we send a signal to our application, the first process that will catch the signal is `npm start` which does not forward the signal to the desired process.  
You can find a Node.js sample using this new feature and solving this common issue via the `Procfile` [here](https://github.com/Scalingo/sample-node-express).