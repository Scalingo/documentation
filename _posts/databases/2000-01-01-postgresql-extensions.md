---
title: Managing PostgreSQL extensions
modified_at: 2015-11-05 00:00:00
category: postgresql
tags: extensions postgresql addons databases
---

{% include info_command_line_tool.md %}

PostgreSQL is a database engine which is extensible thanks to
a large set of extensions. A lot of them a installed alongside
your PostgreSQL but you need to enable those manually according
to your need.

## Enable a specific extension

To enable the extensions you want for your application, run the following command:

```bash
$ scalingo -a <appname> pgsql-console
psql (9.4.5)
Type "help" for help.

user=> CREATE extension hstore;
CREATE EXTENSION
user=> CREATE extension postgis;
CREATE EXTENSION
```

This example uses 'hstore' and 'postgis' but you can do that for all the underneath list of
extensions.

## List of available extensions

<table>
	<thead>
		<tr>
			<th>Extension Name</th>
			<th>Version</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>btree_gist</td>
			<td>1.0</td>
			<td>support for indexing common datatypes in GiST</td>
		</tr>
		<tr>
			<td>citext</td>
			<td>1.0</td>
			<td>data type for case-insensitive character strings</td>
		</tr>
		<tr>
			<td>cube</td>
			<td>1.0</td>
			<td>data type for multidimensional cubes</td>
		</tr>
		<tr>
			<td>dblink</td>
			<td>1.1</td>
			<td>connect to other PostgreSQL databases from within a database</td>
		</tr>
		<tr>
			<td>dict_int</td>
			<td>1.0</td>
			<td>text search dictionary template for integers</td>
		</tr>
		<tr>
			<td>earthdistance</td>
			<td>1.0</td>
			<td>calculate great-circle distances on the surface of the Earth</td>
		</tr>
		<tr>
			<td>fuzzystrmatch</td>
			<td>1.0</td>
			<td>determine similarities and distance between strings</td>
		</tr>
		<tr>
			<td>hstore</td>
			<td>1.3</td>
			<td>data type for storing sets of (key, value) pairs</td>
		</tr>
		<tr>
			<td>intarray</td>
			<td>1.0</td>
			<td>functions, operators, and index support for 1-D arrays of integers</td>
		</tr>
		<tr>
			<td>isn</td>
			<td>1.0</td>
			<td>data types for international product numbering standards</td>
		</tr>
		<tr>
			<td>ltree</td>
			<td>1.0</td>
			<td>data type for hierarchical tree-like structures</td>
		</tr>
		<tr>
			<td>pg_stat_statements</td>
			<td>1.2</td>
			<td>track execution statistics of all SQL statements executed</td>
		</tr>
		<tr>
			<td>pg_trgm</td>
			<td>1.1</td>
			<td>text similarity measurement and index searching based on trigrams</td>
		</tr>
		<tr>
			<td>pgcrypto</td>
			<td>1.1</td>
			<td>cryptographic functions</td>
		</tr>
		<tr>
			<td>pgrowlocks</td>
			<td>1.1</td>
			<td>show row-level locking information</td>
		</tr>
		<tr>
			<td>plpgsql</td>
			<td>1.0</td>
			<td>PL/pgSQL procedural language</td>
		</tr>
		<tr>
			<td>postgis</td>
			<td>2.1.8</td>
			<td>PostGIS geometry, geography, and raster spatial types and functions</td>
		</tr>
		<tr>
			<td>postgis_tiger_geocoder</td>
			<td>2.1.8</td>
			<td>PostGIS tiger geocoder and reverse geocoder</td>
		</tr>
		<tr>
			<td>postgis_topology</td>
			<td>2.1.8</td>
			<td>PostGIS topology spatial types and functions</td>
		</tr>
		<tr>
			<td>tablefunc</td>
			<td>1.0</td>
			<td>functions that manipulate whole tables, including crosstab</td>
		</tr>
		<tr>
			<td>unaccent</td>
			<td>1.0</td>
			<td>text search dictionary that removes accents</td>
		</tr>
		<tr>
			<td>uuid-ossp</td>
			<td>1.0</td>
			<td>generate universally unique identifiers (UUIDs)</td>
		</tr>
	</tbody>
</table>
