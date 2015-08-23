# docker-mariadb-backup

This container can be used to periodically backup MySQL, MariaDB, and MariaDB Galera cluster instances.

Example usage which will backup the database every day at 03:00. You can check the last run with the integrated HTTP server on port 18080:

```bash
docker run -d \
-v /var/backups:/var/backups \
-v /var/source:/var/source \
-p 18080:18080 \
-e SCHEDULE="0 0 3 * *" \
-e NAME="key" \
dylangmiles/docker-file-backup
```

# Available backup methods

## mysqldump

Backups a MySQL/MariaDB database via mysqldump.

Example standalone run:

```bash
docker run -i -t --rm \
-v /var/backups:/var/backups \
hauptmedia/mariadb-backup \
backup-mysqldump \
-u root -p test -h 172.17.0.19
```

```
Usage: /usr/local/bin/backup-mysqldump -u mysqluser -p mysqlpassword -h mysqlhost

  -u  Specifies the MySQL user (required)
  -p  Specifies the MySQL password (required)
  -h  Specifies the MySQL host (required)
  -P  Specifies the MySQL port (optional)
  -d  Specifies the backup file where to put the backup (default: /var/backups/CURRENT_DATETIME_MYSQLHOST_mysqldump)
```
