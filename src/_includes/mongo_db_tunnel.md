{% warning %}
If your MongoDB database uses a Business plan, you have a replica set.
It is not possible to access a replica set using the DB tunnel or the
encrypted tunnel of MongoDB Compass.
You should
[enable Internet Accessibility]({% post_url databases/about/2000-01-01-network-exposure %}#making-your-database-reachable-from-the-internet)
on your database.
The reason is that the DB tunnel is designed to connect to only one node.
On the other hand, MongoDB clients require to reach all the instances of
the replica set to work.
{% endwarning %}
