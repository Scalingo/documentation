---
modified_at: 2021-03-31 10:00:00
title: "Add an endpoint to stop a container"
---

A new endpoint has been added to the API:

`POST https://$SCALINGO_API_URL/apps/:app_id/containers/:container_id/stop`

Asynchronously stops a running container →  ONLY one-off can be stopped that way. More information in the [developers' documentation](https://developers.scalingo.com/apps).
