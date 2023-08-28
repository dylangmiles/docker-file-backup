#!/bin/bash

# Get last error even in piped commands
set -o pipefail

PIDFILE=/var/run/backup-run.pid

if [ -f $PIDFILE ]; then
	echo $0 is already running with pid $(cat $PIDFILE), aborting!
	exit 1
fi

echo $$ >$PIDFILE

# Call backup script and capture output
FILENAME=$(date +"%Y%m%d_%H%M%S")_${NAME}.tar.gz
OUT_BUFF=$( /usr/local/sbin/backup-file.sh 2>&1 | tee /proc/1/fd/1 )

RETVAL=$?

# Calculate result in words
RESULT="unknown"
if [ "$RETVAL" == 0 ]; then
	RESULT="success"
else
	RESULT="failed"
fi

# Email results
ssmtp "${MAIL_TO}" <<EOF
To:${MAIL_TO}
From:${SMTP_FROM}
Subject:Backup ${RESULT}: ${FILENAME}
${OUT_BUFF}
EOF

rm $PIDFILE

exit $RETVAL
