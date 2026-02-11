---
title: PostgreSQL® Anonymizer
nav: PostgreSQL® Anonymizer
modified_at: 2025-02-03 12:00:00
tags: databases postgresql anonymization extensions
index: 50
---

**PostgreSQL® Anonymizer** is an open-source extension for PostgreSQL® that
facilitates the masking or replacement of personally identifiable information
(PII) and commercially sensitive data directly within a database.

This extension is particularly useful for organizations handling sensitive data
and is designed with **anonymization by design** principles to ensure
compliance with privacy regulations such as GDPR, HIPAA, and CCPA.

This extension adds several features and functions. You can find more
information on the [official documentation][official_doc].


## Enabling PostgreSQL® Anonymizer

1. [Create a new user with read only abilities][creating-user]
2. Contact our support team and provide the name of the user you just created
   to request activation of the extension
3. Our team activates the extension and sets up masking for the given user
4. Once done, you can define and manage masking rules for your user
   autonomously as described below.


## Example: Dynamic Masking for Read-Only Users

Suppose you have a table named users containing the columns `first_name`,
`last_name`, `email`, and `phone` and you want to hide sensitive data
dynamically for specific users.

These users must be restricted to read-only abilities and must have been masked
as described above. You can then declare `SECURITY LABEL` with your regular
user.

- Regular roles still have access to the original data
- Masked users see altered data according to the masking rules

Connect as the regular user to the database:

```sql
SELECT * FROM people;

Result:
  id | firstname | lastname |   phone    |         email
 ----+-----------+----------+------------+-------------------------
   1 | Sarah     | Conor    | 0606060606 |  sarah.conor@example.com
   2 | John      | Doe      | 0707070707 |  john.doe@example.com

-- Declare the masking rules
SECURITY LABEL FOR anon ON COLUMN people.lastname
IS 'MASKED WITH FUNCTION anon.dummy_last_name();';

SECURITY LABEL FOR anon ON COLUMN people.phone
IS 'MASKED WITH FUNCTION anon.partial(phone, 2, $$******$$, 2)';
```

Connect as the read-only user to the database and view data:

```sql
SELECT * FROM people;

 Result:
  id | firstname | lastname  |    phone     |           email
 ----+-----------+-----------+--------------+----------------------------
   1 |  Sarah    | Preston   | 06********06 | sarah.conor@example.com
   2 |  John     | Cristian  | 07********07 | john.doe@example.com
```


## Example: Anonymizing Entire Rows with a Query

Suppose you have a table named users containing the columns `first_name`,
`last_name`, `email`, and `phone`. If you want to retrieve as many rows as your
query can fetch with anonymized data, you can use the following query:

```sql
SELECT anon.fake_last_name() AS anonymized_last_name,
       anon.fake_first_name() AS anonymized_first_name,
       anon.random_phone('+33') AS anonymized_phone,
       anon.fake_email() AS anonymized_email
FROM users;

anonymized_last_name | anonymized_first_name | anonymized_phone |      anonymized_email
----------------------+-----------------------+------------------+-----------------------------
 Garza                | Reginald              | +33959147281     | richardsmall@example.org
 Schwartz             | Amber                 | +33180356490     | brittanystewart@example.net
 Shelton              | Kerry                 | +33711805689     | boyerkrystal@example.com
 Mcneil               | Darryl                | +33982131333     | leethomas@example.net
 Mcintosh             | Evan                  | +33158299618     | mariahpatrick@example.org
 Shaffer              | Cristian              | +33225352636     | ashley66@example.org
 Mack                 | Kaitlyn               | +33739247085     | rayamanda@example.net
 Warren               | Vanessa               | +33531162736     | allen06@example.com
 Baldwin              | Sarah                 | +33113538315     | tpeterson@example.net
 Hudson               | Preston               | +33477420668     | andreaortiz@example.com
```


[official_doc]: https://postgresql-anonymizer.readthedocs.io/en/stable/

[creating-user]: {% post_url databases/postgresql/shared-resources/guides/2000-01-01-managing-users %}#creating-a-new-user
