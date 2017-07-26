---
title: Git Submodule on Scalingo
modified_at: 2017-04-27 00:00:00
category: config
order: 2
tags: git submodule
---

If your project repository uses Git submodules, please be aware that Scalingo
will not pull them. This Git feature is not supported on the platform for
different reasons. The main reason being that we currently have no way to
authenticate the `git pull` operation to a private git repository when doing
the deployment. Actually Git submodules are often considered as a broken
feature of Git, that is why we do not encourage its usage or support it today.

We recommend you to vendor a specific release of the code of the sub-git
repository in your main repository before pushing.
