#!/bin/bash

echo
echo Starting backup
echo ===============
echo

if [ -z "$NAME" ]; then
  echo No NAME specified, using default
	NAME=backup
fi

if [ -z "$FILENAME" ]; then
	FILENAME=$(date +"%Y%m%d_%H%M%S")_${NAME}.tar.gz
fi



echo "FILENAME:        ${FILENAME}"
echo

echo Archiving files ...

tar --exclude-tag-under=.file-backup-ignore -czv /var/source | aws s3 cp - "${AWS_DESTINATION}/${FILENAME}.tar.gz"

RETVAL=$?

if [ "$RETVAL" == 0 ]; then
	echo Backup finished successfully.

	exit 0
else
	echo Backup failed with errors!

    # Send success email
    #EMAIL_BUFF="To:${MAIL_TO}\nFrom:${MAIL_FROM}\nSubject:Backup successful ${FILENAME}\n\n${OUT_BUFF}"
    #echo ${EMAIL_BUFF} | ssmtp -v ${MAIL_TO}

	exit 1
fi

