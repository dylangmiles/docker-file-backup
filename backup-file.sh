#!/bin/bash

# Get last error even in piped commands
set -o pipefail

if [ -z "$LOCATION" ]; then
  echo No LOCATION specified, using default
	LOCATION=local
fi

if [ -z "$NAME" ]; then
  echo No NAME specified, using default
	NAME=backup
fi

if [ -z "$FILENAME" ]; then
	FILENAME=$(date +"%Y%m%d_%H%M%S")_${NAME}.tar.gz
fi

CMD="echo Backup location not available"
DESTINATION=$LOCAL_DESTINATION
if [ "$LOCATION" == "local" ]; then
	DESTINATION=$LOCAL_DESTINATION
	CMD="tar --exclude-tag-under=.file-backup-ignore -czvf "/var/destination/${FILENAME}" /var/source"
fi

if [ "$LOCATION" == "aws" ]; then
	DESTINATION=$AWS_DESTINATION
	CMD="tar --exclude-tag-under=.file-backup-ignore -czv /var/source | aws s3 cp - "${AWS_DESTINATION}/${FILENAME}""
fi

echo "Backup starting of ${FILENAME} on ${LOCATION} to ${DESTINATION}"
echo ""

eval "$CMD"
RETVAL=$?
echo ""

if [ "$RETVAL" == 0 ]; then
	echo "Backup completed successfully."
	exit 0
else
	echo "Backup failed with error ${RETVAL}."
	exit 1
fi

