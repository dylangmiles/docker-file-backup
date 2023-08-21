# docker-file-backup

This container can be used to periodically backup files or folders.

You can check the last run with the integrated HTTP server on port 18080.

The backup location is tar gziped to an Amazon S3 bucket and an email sent with the status of the backup.

# Setup

1. Clone this repository to your server with files that need to be backed up
```
git clone git@github.com:dylangmiles/docker-file-backup.git
```

2. Create a `.env` file in the directory with the following settings:
```bash
# Cron schedule
SCHEDULE=* * * * *

# Label used for the backup filename. The result backup file name will use the format  YYMMDD_HH_mm_ss_NAME_tar.gz
NAME=test

# METHOD local | aws
METHOD=aws

# The location where backups will be written to if file based
DESTINATION=./data/destination

# The location that will be backed up
SOURCE=./data/source

# AWS Access Key
AWS_ACCESS_KEY=***************

# AWS Secret Key
AWS_SECRET_KEY=***************

# AWS Region
AWS_REGION=eu-west-1

# AWS Bucket name
AWS_DESTINATION=s3://bucketname/path


# Email address where notifications are sent
MAIL_TO=name@email.com

# Email sending options
SMTP_FROM=from@email.com
SMTP_SERVER=mail.server.com:587
SMTP_HOSTNAME=local.server.com
SMTP_USERNAME=username@email.com
SMTP_PASSWORD=*******

```

3. Start the container
```
docker compose up -d file-backup
```


NB: The backup will ignore any directories with .file-backup-ignore in them.

# Reference
https://superuser.com/questions/1248276/aws-upload-folder-to-s3-as-tar-gz-without-compressing-locally
