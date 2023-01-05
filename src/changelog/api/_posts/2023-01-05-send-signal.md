---
modified_at: 2023-01-05 15:00:00
title: "Add an endpoint to send signal to a container"
---

A new endpoint has been added to the API:

`POST https://$SCALINGO_API_URL/apps/:app_id/containers/:container_id/kill`

Send a signal to the running container. More information in the [developers' documentation](https://developers.scalingo.com/apps#send-signal-to-a-container).
