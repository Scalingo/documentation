---
title: App Notifications
nav: Notifications
modified_at: 2017-09-25 00:00:00
tags: app notification
---

Notification can be defined per application. You can find the settings into the "Notification" tab of your app.

A notifier have:
* a name
* a communication channel (Slack, webhook, Rocket.Chat, email).
* a group of events to react to (or a precise list of events)

## Events list

* addon_db_upgraded: Addon database upgraded, A database addon was upgraded
* addon_deleted: Addon deleted, An addon was deleted
* addon_plan_changed: Addon plan changed, An addon plan was changed
* addon_provisioned: Addon provisioned, An addon was provisioned
* addon_resumed: Addon resumed, An addon was provisioned
* addon_suspended: Addon suspended, An addon was suspended
* app_alert_triggered: App alert triggered, An app alert was triggered (no triggered at the moment, feature is in alpha)
* app_command_ran: App command ran, A command was ran in an app
* app_crashed: App crashed, An app was crashed
* app_crashed_repeated: App crashed repeated, An app was crashed. This event is sent on each crash.
* app_deleted: App deleted, A command was ran in an app
* app_deployed: App deployed, An app was deployed
* app_renamed: App renamed, An app was renamed
* app_restarted: App restarted, An app was restarted
* app_scaled: App scaled, An app was scaled
* app_stopped: App stopped, An app was stopped
* app_transferred: App transferred, An app was transferred
* collaborator_accepted: Collaborator accepted, A collaborator invitation was accepted
* collaborator_invited: Collaborator invited, A collaborator was invited
* collaborator_removed: Collaborator removed, A collaborator was removed
* domain_added: Domain added, A domain was added
* domain_edited: Domain edited, A domain was edited
* domain_removed: Domain removed, A domain was removed
* github_link: GitHub link, A GitHub repository was linked to an app
* github_unlink: GitHub unlink, A GitHub repository was unlinked from an app
* notifier_added: Notifier added, A notifier was added
* notifier_edited: Notifier edited, A notifier was edited
* notifier_removed: Notifier removed, A notifier was removed
* variable_added: Variable added, A variable was added
* variable_bulk_edited: Variables bulk edited,	Some variables were bulk edited
* variable_edited: Variable edited, A variable was edited
* variable_removed: Variable removed, A variable was removed
