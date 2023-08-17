# docker-file-backup

This container can be used to periodically backup files or folders.

Example usage which will backup the source file or folder every day at 03:00. You can check the last run with the integrated HTTP server on port 18080:

# Setup

1. Clone this repository to your server with files that need to be backed up
```
git clone git@github.com:dylangmiles/docker-file-backup.git
```

1. Create a `.env` file in the directory with the following settings:
```bash
# Cron schedule
SCHEDULE=* * * * *

# Label used for the backup filename. The result backup file name will use the format  YYMMDD_HH_mm_ss_NAME_tar.gz
NAME=test

# The location where backups will be written to
DESTINATION=./data/destination

# The location that will be backed up
SOURCE=./data/source
```

NB: The backup will ignore any directories with .file-backup-ignore in them.



# Reference
https://superuser.com/questions/1248276/aws-upload-folder-to-s3-as-tar-gz-without-compressing-locally
