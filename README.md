# docker-file-backup

This container can be used to periodically backup files or folders.

Example usage which will backup the source file or folder every day at 03:00. You can check the last run with the integrated HTTP server on port 18080:

```bash
docker run -d \
-v ./mount:/var/destination \
-v ./source:/var/source \
-p 127.0.0.1:18080:18080 \
-e SCHEDULE="0 0 3 * *" \
-e NAME="key" \
dylangmiles/docker-file-backup
```

```bash
docker run \
-v ./mount:/var/destination \
-v ./source:/var/source \
-p 127.0.0.1:18080:18080 \
-e SCHEDULE="0 0/2 0 * * ?" \
-e NAME="mydata" \
dylangmiles/docker-file-backup
```

# Available backup methods

## file

Backups a file or folder.

Example standalone run:

```bash
docker run -i -t --rm \
-v ./mount:/var/destination \
-v ./source:/var/source \
dylangmiles/docker-file-backup \
backup-file
```

NB: The backup will ignore any directories with .file-backup-ignore in them.