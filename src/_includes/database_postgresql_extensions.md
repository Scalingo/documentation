<!--
Generate the below table with the follow psql commands: 

\pset format html
SELECT CONCAT('<code class="language-plaintext highlighter-rouge">', name, '</code>') as "Name", CONCAT('<code>', default_version, '</code>') as "Version", comment AS "Description" FROM pg_available_extensions ORDER BY name;

Then replace the &lt; by '<' and &gt; by '>'
-->
<table border="1">
  <tr>
    <th align="center">Name</th>
    <th align="center">Version</th>
    <th align="center">Description</th>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">address_standardizer</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">3.4.2</code></td>
    <td align="left">Used to parse an address into constituent elements. Generally used to support geocoding address normalization step.</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">address_standardizer-3</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">3.4.2</code></td>
    <td align="left">Used to parse an address into constituent elements. Generally used to support geocoding address normalization step.</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">address_standardizer_data_us</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">3.4.2</code></td>
    <td align="left">Address Standardizer US dataset example</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">address_standardizer_data_us-3</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">3.4.2</code></td>
    <td align="left">Address Standardizer US dataset example</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">adminpack</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">2.1</code></td>
    <td align="left">administrative functions for PostgreSQL</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">amcheck</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.3</code></td>
    <td align="left">functions for verifying relation integrity</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">autoinc</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">functions for autoincrementing fields</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">bloom</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">bloom access method - signature file based index</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">btree_gin</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.3</code></td>
    <td align="left">support for indexing common datatypes in GIN</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">btree_gist</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.7</code></td>
    <td align="left">support for indexing common datatypes in GiST</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">citext</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.6</code></td>
    <td align="left">data type for case-insensitive character strings</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">cube</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.5</code></td>
    <td align="left">data type for multidimensional cubes</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">dblink</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.2</code></td>
    <td align="left">connect to other PostgreSQL databases from within a database</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">dict_int</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">text search dictionary template for integers</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">dict_xsyn</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">text search dictionary template for extended synonym processing</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">earthdistance</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.1</code></td>
    <td align="left">calculate great-circle distances on the surface of the Earth</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">file_fdw</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">foreign-data wrapper for flat file access</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">fuzzystrmatch</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.1</code></td>
    <td align="left">determine similarities and distance between strings</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">hstore</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.8</code></td>
    <td align="left">data type for storing sets of (key, value) pairs</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">insert_username</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">functions for tracking who changed a table</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">intagg</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.1</code></td>
    <td align="left">integer aggregator and enumerator (obsolete)</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">intarray</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.5</code></td>
    <td align="left">functions, operators, and index support for 1-D arrays of integers</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">isn</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.2</code></td>
    <td align="left">data types for international product numbering standards</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">lo</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.1</code></td>
    <td align="left">Large Object maintenance</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">ltree</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.2</code></td>
    <td align="left">data type for hierarchical tree-like structures</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">moddatetime</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">functions for tracking last modification time</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">old_snapshot</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">utilities in support of old_snapshot_threshold</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pageinspect</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.11</code></td>
    <td align="left">inspect the contents of database pages at a low level</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pg_buffercache</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.3</code></td>
    <td align="left">examine the shared buffer cache</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pg_freespacemap</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.2</code></td>
    <td align="left">examine the free space map (FSM)</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pg_prewarm</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.2</code></td>
    <td align="left">prewarm relation data</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pg_repack</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.5.0</code></td>
    <td align="left">Reorganize tables in PostgreSQL databases with minimal locks</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pg_stat_statements</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.10</code></td>
    <td align="left">track planning and execution statistics of all SQL statements executed</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pg_surgery</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">extension to perform surgery on a damaged relation</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pg_trgm</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.6</code></td>
    <td align="left">text similarity measurement and index searching based on trigrams</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pg_visibility</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.2</code></td>
    <td align="left">examine the visibility map (VM) and page-level visibility info</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pg_walinspect</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">functions to inspect contents of PostgreSQL Write-Ahead Log</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pgcrypto</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.3</code></td>
    <td align="left">cryptographic functions</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pgrowlocks</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.2</code></td>
    <td align="left">show row-level locking information</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pgstattuple</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.5</code></td>
    <td align="left">show tuple-level statistics</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">plpgsql</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">PL/pgSQL procedural language</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">3.4.2</code></td>
    <td align="left">PostGIS geometry and geography spatial types and functions</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis-3</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">3.4.2</code></td>
    <td align="left">PostGIS geometry and geography spatial types and functions</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis_raster</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">3.4.2</code></td>
    <td align="left">PostGIS raster types and functions</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis_raster-3</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">3.4.2</code></td>
    <td align="left">PostGIS raster types and functions</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis_sfcgal</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">3.4.2</code></td>
    <td align="left">PostGIS SFCGAL functions</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis_sfcgal-3</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">3.4.2</code></td>
    <td align="left">PostGIS SFCGAL functions</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis_tiger_geocoder</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">3.4.2</code></td>
    <td align="left">PostGIS tiger geocoder and reverse geocoder</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis_tiger_geocoder-3</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">3.4.2</code></td>
    <td align="left">PostGIS tiger geocoder and reverse geocoder</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis_topology</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">3.4.2</code></td>
    <td align="left">PostGIS topology spatial types and functions</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis_topology-3</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">3.4.2</code></td>
    <td align="left">PostGIS topology spatial types and functions</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgres_fdw</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.1</code></td>
    <td align="left">foreign-data wrapper for remote PostgreSQL servers</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">refint</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">functions for implementing referential integrity (obsolete)</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">seg</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.4</code></td>
    <td align="left">data type for representing line segments or floating-point intervals</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">sslinfo</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.2</code></td>
    <td align="left">information about SSL certificates</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">tablefunc</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">functions that manipulate whole tables, including crosstab</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">tcn</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">Triggered change notifications</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">timescaledb</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">2.14.2</code></td>
    <td align="left">Enables scalable inserts and complex queries for time-series data (Apache 2 Edition)</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">tsm_system_rows</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">TABLESAMPLE method which accepts number of rows as a limit</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">tsm_system_time</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.0</code></td>
    <td align="left">TABLESAMPLE method which accepts time in milliseconds as a limit</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">unaccent</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.1</code></td>
    <td align="left">text search dictionary that removes accents</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">uuid-ossp</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.1</code></td>
    <td align="left">generate universally unique identifiers (UUIDs)</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">vector</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">0.7.0</code></td>
    <td align="left">vector data type and ivfflat and hnsw access methods</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">xml2</code></td>
    <td align="left"><code class="language-plaintext highlighter-rouge">1.1</code></td>
    <td align="left">XPath querying and XSLT</td>
  </tr>
</table>
