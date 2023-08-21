#!/bin/bash

# Get last error even in piped commands
set -o pipefail

if [ -z "$NAME" ]; then
  echo No NAME specified, using default
	NAME=backup
fi

if [ -z "$FILENAME" ]; then
	FILENAME=$(date +"%Y%m%d_%H%M%S")_${NAME}.tar.gz
fi

echo "Backup starting: ${FILENAME}"
echo ""

tar --exclude-tag-under=.file-backup-ignore -czv /var/source | aws s3 cp - "${AWS_DESTINATION}/${FILENAME}.tar.gz"
RETVAL=$?

echo ""

if [ "$RETVAL" == 0 ]; then
	echo "Backup completed successfully."
	exit 0
else
	echo "Backup failed with error ${RETVAL}."
	exit 1
fi

