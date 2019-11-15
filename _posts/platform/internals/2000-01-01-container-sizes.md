---
title: Container Sizes
modified_at: 2015-12-02 00:00:00
tags: internals containers sizes
index: 2
---

## Comparative Table

<table class="table">
	<thead>
	<tr>
		<th>Name</th>
		<th>Memory</th>
		<th>CPU Priority</th>
    <th>PID Limit</th>
		<th>Price</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td>S - Small</td>
		<td>256MB</td>
		<td>Low</td>
    <td>128</td>
		<td>0.01€/h</td>
	</tr>
	<tr>
		<td>M - Medium (Default)</td>
		<td>512MB</td>
		<td>Standard</td>
    <td>256</td>
		<td>0.02€/h</td>
	</tr>
	<tr>
		<td>L - Large</td>
		<td>1GB</td>
		<td>Standard</td>
    <td>512</td>
		<td>0.04€/h</td>
	</tr>
	<tr>
		<td>XL - eXtra Large</td>
		<td>2GB</td>
		<td>High</td>
    <td>1024</td>
		<td>0.08€/h</td>
	</tr>
	<tr>
		<td>2XL - eXtra eXtra Large</td>
		<td>4GB</td>
		<td>High</td>
    <td>2048</td>
		<td>0.16€/h</td>
	</tr>
	</tbody>
</table>

Bigger container sizes are available upon request on the support.

## Availability of the Sizes

Our 30 days free trial only gives you access to small and medium containers, if you want
to use another kind of size, please [fill your billing profile and payment
method](https://my.scalingo.com/billing).

## Container Limits

Containers have various limits depending on their size. Here is a comprehensive list:

- RAM: cf. above-mentioned table
- Swap: twice the amount of RAM.
- CPU access: all containers have access to all CPU cores. But higher priority
  means twice as much priority compared to standard priority. For example,
  consider three containers, one has a high priority and two others have a
  standard priority. When processes in all three containers attempt to use
  100% of CPU, the first container would receive 50% of the total CPU time and
  the two others would receive 25%.
- PID limits: from 128 (S) to 2048 (2XL).
- Ulimit nofile: 10000. Maximum number of files an application can open.
