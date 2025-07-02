---
title: Collaborator Permissions Matrix
modified_at: 2025-06-30 00:00:00
tags: user role permission collaborator matrix
index: 4
---

This matrix details the permissions available to Collaborators and Limited Collaborators on Scalingo.
The Owner role is not listed, as it holds full and unrestricted access to all application resources.

## Application Lifecycle

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| Restart App | ✅ Yes | ❌ No |
| Stop App | ✅ Yes | ❌ No |
| Change container size | ✅ Yes | ❌ No |
| Scale containers | ✅ Yes | ❌ No |
| Access the Autoscaler | ✅ Yes | ❌ No |
| Update Operator data access | ✅ Yes | ✅ Yes |
| Manage Log drain settings | ✅ Yes | ❌ No |
| Create a Child App | ✅ Yes | ❌ No |


## Monitoring and Logs

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| View Activity | ✅ Yes | ✅ Yes |
| View Activity details | ✅ Yes | ⚠️ Yes (env-vars values are hidden) |
| View logs | ✅ Yes | ✅ Yes |
| Download log achives | ✅ Yes | ❌ No |
| View metrics | ✅ Yes | ✅ Yes |


## App Configuration & Access Control

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| Manage Apps | ✅ Yes | ❌ No |
| Invite a collaborator on an app | ✅ Yes | ❌ No |
| Revoke a collaborator on an app | ✅ Yes | ❌ No |
| Change the role of a collaborator | ✅ Yes | ❌ No |


## Deployment

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| Configure the SCM | ✅ Yes | ❌ No |
| Automatic deployments management | ✅ Yes | ❌ No |
| Redeploy any branch | ✅ Yes | ❌ No |
| Redeploy main bran | ✅ Yes | ✅ Yes |
| See deployments history | ✅ Yes | ✅ Yes |
| See deployments logs | ✅ Yes | ⚠️ Yes, but not for deployments older than 7 days |
| Empty the deployment cache | ✅ Yes | ✅ Yes |


## One-off Containers & Scheduled Jobs

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| List one-offs | ✅ Yes | ✅ Yes |
| Create One-off | ✅ Yes | ❌ No |
| Access One-off | ✅ Yes | ❌ No |
| List CRON tasks | ✅ Yes | ✅ Yes |


## Environment Variables

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| Manage environment variables | ✅ Yes | ❌ No |
| View environment variable names | ✅ Yes | ✅ Yes |
| View environment variable secrets | ✅ Yes | ❌ No |


## Review Apps

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| Configure Review Apps | ✅ Yes | ❌ No |
| List Review Apps | ✅ Yes | ✅ Yes |
| Create Review Apps | ✅ Yes | ✅ Yes (only via SCM Tool if allowed) |
| Close Review Apps | ✅ Yes | ✅ Yes |
| Redeploy a Review App | ✅ Yes | ✅ Yes |


## Add-ons

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| Provision an add-on | ✅ Yes | ❌ No |
| View an add-on | ✅ Yes | ❌ No |
| Change an add-on plan | ✅ Yes | ❌ No |
| Remove an add-on | ✅ Yes | ❌ No |


## Databases

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| Access databases | ✅ Yes | ❌ No |
| Create a manual backup | ✅ Yes | ❌ No |
| Manage scheduled backups | ✅ Yes | ❌ No |
| Restore / Download backups | ✅ Yes | ❌ No |
| Restore a PITR | ✅ Yes | ❌ No |
| View connection details | ✅ Yes | ❌ No |
| View database logs | ✅ Yes | ❌ No |
| View database metrics | ✅ Yes | ❌ No |
| Manage Internet accessibility | ✅ Yes | ❌ No |
| Manage database configuration | ✅ Yes | ❌ No |
| Manage database users | ✅ Yes | ❌ No |
| Manage maintenance windows | ✅ Yes | ❌ No |
| Perform major upgrades | ✅ Yes | ❌ No |
| Perform minor upgrades | ✅ Yes | ❌ No |
