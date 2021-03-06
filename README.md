# docker-file-backup

This container can be used to periodically backup files or folders.

Example usage which will backup the source file or folder every day at 03:00. You can check the last run with the integrated HTTP server on port 18080:

```bash
docker run -d \
-v /var/backups:/var/backups \
-v /var/source:/var/source \
-p 18080:18080 \
-e SCHEDULE="0 0 3 * *" \
-e NAME="key" \
dylangmiles/docker-file-backup
```

```bash
docker run \
-v /home/julian/Development/alchemy@bitbucket/assa-education/backups:/var/backups \
-v /home/julian/Development/alchemy@bitbucket/assa-education/data:/var/source \
-p 18080:18080 \
-e SCHEDULE="0 0/2 0 * * ?" \
-e NAME="moodledata" \
dylangmiles/docker-file-backup
```

# Available backup methods

## file

Backups a file or folder.

Example standalone run:

```bash
docker run -i -t --rm \
-v /home/julian/Development/alchemy@bitbucket/assa-education/backups:/var/backups \
-v /home/julian/Development/alchemy@bitbucket/assa-education/data:/var/source \
dylangmiles/docker-file-backup \
backup-file
```


## Docker Compose

filebackup:
  image: dylangmiles/docker-file-backup
  restart: always
  volumes:
   - /mnt/ftp_backup:/var/backups
  ports:
   - 16060:16060
  environment:
   - SCHEDULE=0 0 3 * * ?
   - NAME=moodledata


docker run \
-v ~/destination:/var/destination \
-v ~/source:/var/source \
-p 18080:18080 \
-e SCHEDULE="*/10 * * * *" \
-e NAME="test" \
dylangmiles/docker-file-backup

NB: The backup will ignore any directories with .file-backup-ignore in them.