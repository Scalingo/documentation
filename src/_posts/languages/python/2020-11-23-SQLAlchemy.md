---
title: "SQLAlchemy: PostgreSQL connection URI"
nav: SQLAlchemy
modified_at: 2021-11-23 00:00:00
---

To connect to PostgreSQL most frameworks accept a connection URI that begins with `postgres://`, this is not the case with SQLAlchemy that requires the connection URI to begin with `postgresql://`.

To handle this situation we added this feature in our buildpack: if we detect that you're using SQLAlchemy (to do so we check the presence of `sqlalchemy` in the files `requirements.txt` or `Pipfile`), we're adding a new environment variables `SCALINGO_POSTGRESQL_URL_ALCHEMY` with the right format.
