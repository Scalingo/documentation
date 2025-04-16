<!--
Generate the below table with the follow psql commands:

\pset format html
SELECT CONCAT('<code class="language-plaintext highlighter-rouge">', name, '</code>') as "Name", CONCAT('<code>', default_version, '</code>') as "Version", comment AS "Description" FROM pg_available_extensions RIGHT JOIN (SELECT unnest(string_to_array(reset_val, ',')) AS extension FROM pg_settings WHERE name = 'extwlist.extensions') settings ON settings.extension = pg_available_extensions.name ORDER BY Name;

Then replace the &lt; by '<' and &gt; by '>'
vim Syntax:
:12,$s/&lt;/</g
:12,$s/&gt;/>/g
:12,$s/&quot;/"/g
-->
<table border="1">
  <tr>
    <th align="center">Name</th>
    <th align="center">Version</th>
    <th align="center">Description</th>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">anon</code></td>
    <td align="left"><code>2.0.0</code></td>
    <td align="left">Anonymization &amp; Data Masking for PostgreSQL</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">btree_gin</code></td>
    <td align="left"><code>1.3</code></td>
    <td align="left">support for indexing common datatypes in GIN</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">btree_gist</code></td>
    <td align="left"><code>1.7</code></td>
    <td align="left">support for indexing common datatypes in GiST</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">citext</code></td>
    <td align="left"><code>1.6</code></td>
    <td align="left">data type for case-insensitive character strings</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">cube</code></td>
    <td align="left"><code>1.5</code></td>
    <td align="left">data type for multidimensional cubes</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">dblink</code></td>
    <td align="left"><code>1.2</code></td>
    <td align="left">connect to other PostgreSQL databases from within a database</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">dict_int</code></td>
    <td align="left"><code>1.0</code></td>
    <td align="left">text search dictionary template for integers</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">earthdistance</code></td>
    <td align="left"><code>1.2</code></td>
    <td align="left">calculate great-circle distances on the surface of the Earth</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">fuzzystrmatch</code></td>
    <td align="left"><code>1.2</code></td>
    <td align="left">determine similarities and distance between strings</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">hstore</code></td>
    <td align="left"><code>1.8</code></td>
    <td align="left">data type for storing sets of (key, value) pairs</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">intarray</code></td>
    <td align="left"><code>1.5</code></td>
    <td align="left">functions, operators, and index support for 1-D arrays of integers</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">isn</code></td>
    <td align="left"><code>1.2</code></td>
    <td align="left">data types for international product numbering standards</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">ltree</code></td>
    <td align="left"><code>1.2</code></td>
    <td align="left">data type for hierarchical tree-like structures</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pg_repack</code></td>
    <td align="left"><code>1.5.2</code></td>
    <td align="left">Reorganize tables in PostgreSQL databases with minimal locks</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pg_stat_statements</code></td>
    <td align="left"><code>1.10</code></td>
    <td align="left">track planning and execution statistics of all SQL statements executed</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pg_trgm</code></td>
    <td align="left"><code>1.6</code></td>
    <td align="left">text similarity measurement and index searching based on trigrams</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pgcrypto</code></td>
    <td align="left"><code>1.3</code></td>
    <td align="left">cryptographic functions</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">pgrowlocks</code></td>
    <td align="left"><code>1.2</code></td>
    <td align="left">show row-level locking information</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis</code></td>
    <td align="left"><code>3.5.2</code></td>
    <td align="left">PostGIS geometry and geography spatial types and functions</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis_raster</code></td>
    <td align="left"><code>3.5.2</code></td>
    <td align="left">PostGIS raster types and functions</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis_sfcgal</code></td>
    <td align="left"><code>3.5.2</code></td>
    <td align="left">PostGIS SFCGAL functions</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis_tiger_geocoder</code></td>
    <td align="left"><code>3.5.2</code></td>
    <td align="left">PostGIS tiger geocoder and reverse geocoder</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgis_topology</code></td>
    <td align="left"><code>3.5.2</code></td>
    <td align="left">PostGIS topology spatial types and functions</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">postgres_fdw</code></td>
    <td align="left"><code>1.1</code></td>
    <td align="left">foreign-data wrapper for remote PostgreSQL servers</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">tablefunc</code></td>
    <td align="left"><code>1.0</code></td>
    <td align="left">functions that manipulate whole tables, including crosstab</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">timescaledb</code></td>
    <td align="left"><code>2.19.3</code></td>
    <td align="left">Enables scalable inserts and complex queries for time-series data</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">unaccent</code></td>
    <td align="left"><code>1.1</code></td>
    <td align="left">text search dictionary that removes accents</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">uuid-ossp</code></td>
    <td align="left"><code>1.1</code></td>
    <td align="left">generate universally unique identifiers (UUIDs)</td>
  </tr>
  <tr valign="top">
    <td align="left"><code class="language-plaintext highlighter-rouge">vector</code></td>
    <td align="left"><code>0.8.0</code></td>
    <td align="left">vector data type and ivfflat and hnsw access methods</td>
  </tr>
</table>
