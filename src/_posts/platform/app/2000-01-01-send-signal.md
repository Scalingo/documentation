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
- …

## How to send a signal to an application?

To send a signal to an application, multiple possibilities are available:

The CLI provides a `send-signal` command.

```sh
$ scalingo --app my-app ps
+-------+---------+-------------+------+---------------------+
| NAME  | STATUS  |   COMMAND   | SIZE |     CREATED AT      |
+-------+---------+-------------+------+---------------------+
| web-1 | running | sample-test | M    | 2023/01/05 09:24:33 |
| web-2 | running | sample-test | M    | 2023/01/05 09:24:33 |
+-------+---------+-------------+------+---------------------+

$ scalingo --app my-app send-signal --signal SIGUSR1 web-1
-----> Sent signal 'SIGUSR1' to 'web-1' container.
```
An API endpoint is available to send a signal. More information about the endpoint [here](https://developers.scalingo.com/apps#send-signal-to-a-container).

## Which process catches the signal?

When transmitted to the container, the signal is forwarded to the first process that started your application, also called the entry point. This entry point can be defined in the [Procfile](https://doc.scalingo.com/platform/getting-started/heroku-compatibility#procfile).  

### Example of a Node.js Express application

The default command run by Scalingo for a Node.js application is `npm start`. It runs a command specified in the `.scripts.start` field of the `package.json`.  
When a signal is sent to the application, `npm` is the first process to catch it. `npm` does not forward the signal to the child process started with the `.scripts.start` field.  
A Node.js sample resolving this issue via the `Procfile` can be found [here](https://github.com/Scalingo/sample-node-express).