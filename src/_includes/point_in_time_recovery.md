Point-in-time recovery (PiTR) allows you to ask for the restoration of your
data at a specific date. We achieve this by making a full PiTR backup of the
database weekly. Between two full PiTR backups, we keep track of the
write-ahead logs (WAL). The WAL contains all the modification instructions. By
replaying the WAL from a full PiTR backup to a specific date, we are able to
rebuild the state of the database at that particular date.
