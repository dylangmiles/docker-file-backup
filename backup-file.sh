#!/bin/bash

# Get last error even in piped commands
set -o pipefail

if [ -z "$METHOD" ]; then
  echo No METHOD specified, using default
	METHOD=local
fi

if [ -z "$NAME" ]; then
  echo No NAME specified, using default
	NAME=backup
fi

if [ -z "$FILENAME" ]; then
	FILENAME=$(date +"%Y%m%d_%H%M%S")_${NAME}.tar.gz
fi

CMD="echo Backup method not available"
DESTINATION=$LOCAL_DESTINATION
if [ "$METHOD" == "local" ]; then
	DESTINATION=$LOCAL_DESTINATION
	CMD="tar --exclude-tag-under=.file-backup-ignore -czvf "/var/destination/${FILENAME}" /var/source"
fi

if [ "$METHOD" == "aws" ]; then
	DESTINATION=$AWS_DESTINATION
	CMD="tar --exclude-tag-under=.file-backup-ignore -czv /var/source | aws s3 cp - "${AWS_DESTINATION}/${FILENAME}.tar.gz""
fi

echo "Backup starting of ${FILENAME} using ${METHOD} method to ${DESTINATION}"
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

