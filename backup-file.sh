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

echo "Authenticating with AWS"
aws configure set aws_access_key_id ${AWS_ACCESS_KEY}
aws configure set aws_secret_access_key ${AWS_SECRET_KEY}
aws configure set default.region ${AWS_REGION}
#$ aws configure set default.ca_bundle /path/to/ca-bundle.pem
#$ aws configure set region ${AWS_REGION}
#$ aws configure set profile.testing2.region eu-west-1



echo "FILENAME:        ${FILENAME}"
echo

echo Archiving files ...

tar --exclude-tag-under=.file-backup-ignore -czv /var/source | aws s3 cp - "${AWS_DESTINATION}/${FILENAME}.tar.gz"

RETVAL=$?


#if [ "$RETVAL" == 0 ]; then
#    echo Copy archive to final destination
#    cp -v ${FILENAME} /var/destination
#    RETVAL=$?
#fi
#
#if [ "$RETVAL" == 0 ]; then
#    echo Remove temporary archives
#    rm -v ./*
#    RETVAL=$?
#fi
#
#cd ~

if [ "$RETVAL" == 0 ]; then
	echo Backup finished successfully.
	exit 0
else
	echo Backup failed with errors!
	exit 1
fi
