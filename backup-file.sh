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
	FILENAME=$(date +"%Y-%m-%d-%H%M%S")_${NAME}.tar.gz
fi

echo "FILENAME:        ${FILENAME}"
echo

cd /var/tmp

echo Archiving files ...

tar --exclude-tag-under=.file-backup-ignore -czvf ${FILENAME} -C /var/source .

RETVAL=$?


if [ "$RETVAL" == 0 ]; then
    echo Copy archive to final destination
    cp -v ${FILENAME} /var/destination
    RETVAL=$?
fi    

if [ "$RETVAL" == 0 ]; then
    echo Remove temporary archives
    rm -v ./*
    RETVAL=$?
fi
    
cd ~

if [ "$RETVAL" == 0 ]; then
	echo Backup finished successfully.
	exit 0
else
	echo Backup failed with errors!
	exit 1
fi
