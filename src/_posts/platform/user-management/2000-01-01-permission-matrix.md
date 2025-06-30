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
| Change scale | ✅ Yes | ❌ No |
| Autoscaler | ✅ Yes | ❌ No |
| Operator data access | ✅ Yes | ✅ Yes |
| Log drain management | ✅ Yes | ❌ No |
| Create a Child App | ✅ Yes | ❌ No |


## Monitoring and Logs

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| View Activity | ✅ Yes | ✅ Yes |
| View Activity details | ✅ Yes | ⚠️ Yes (env-vars values are hidden) |
| View logs | ✅ Yes | ✅ Yes, but not archive |
| View metrics | ✅ Yes | ✅ Yes |


## App Configuration & Access Control

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| Manage Apps | ✅ Yes | ❌ No |
| Invite/Remove Collab on an App | ✅ Yes | ❌ No |
| Change role of another collab | ✅ Yes | ❌ No |


## Deployment

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| SCM Configuration | ✅ Yes | ❌ No |
| Automatic deployments management | ✅ Yes | ❌ No |
| Redeploy any branch | ✅ Yes | ❌ No |
| Redeploy main bran | ✅ Yes | ✅ Yes |
| See deployments history | ✅ Yes | ✅ Yes |
| See deployments logs | ✅ Yes | ⚠️ Yes, but not from old deployments (7 days) |
| Empty cache | ✅ Yes | ✅ Yes |


## One-off Containers & Scheduled Jobs

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| List one-offs | ✅ Yes | ✅ Yes |
| Create One-off | ✅ Yes | ❌ No |
| Access one-off | ✅ Yes | ❌ No |
| List CRONs | ✅ Yes | ✅ Yes |


## Environment Variables

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| Manage environment variables | ✅ Yes | ❌ No |
| View environment variables name | ✅ Yes | ✅ Yes |
| View environment variables secrete | ✅ Yes | ❌ No |


## Review Apps

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| Configure Review Apps | ✅ Yes | ❌ No |
| List Review Apps | ✅ Yes | ✅ Yes |
| Create Review Apps | ✅ Yes | ✅ Yes (only via GitHub if allowed) |
| Close Review Apps | ✅ Yes | ✅ Yes |
| Redeploy a Review App | ✅ Yes | ✅ Yes |


## Add-ons

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| Add add-on | ✅ Yes | ❌ No |
| View add-on | ✅ Yes | ❌ No |
| Change add-on plan | ✅ Yes | ❌ No |
| Remove add-on | ✅ Yes | ❌ No |


## Databases

| Permission | Collaborator | Limited Collaborator |
|---|---|---|
| Access database | ✅ Yes | ❌ No |
| Create a manual backup | ✅ Yes | ❌ No |
| Manage scheduled backups | ✅ Yes | ❌ No |
| Restore / Download backups | ✅ Yes | ❌ No |
| Restore a PITR | ✅ Yes | ❌ No |
| View connexion details | ✅ Yes | ❌ No |
| View database logs | ✅ Yes | ❌ No |
| View database metrics | ✅ Yes | ❌ No |
| Manage Internet accessibility | ✅ Yes | ❌ No |
| Manage database configuration | ✅ Yes | ❌ No |
| Manage database users | ✅ Yes | ❌ No |
| Manage maintenance windows | ✅ Yes | ❌ No |
| Perform major upgrades | ✅ Yes | ❌ No |
| Perform minor upgrades | ✅ Yes | ❌ No |
