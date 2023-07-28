{% note %}
  Running a migration on an application that then crashes on startup can be risky, so the application must start without the database migration.
  Scalingo makes sure the application starts before running the hook. If the application does not start, the post-deployment hook won't run. Consequently the database migration won't be executed either.
{% endnote %}
