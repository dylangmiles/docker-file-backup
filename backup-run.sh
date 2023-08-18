#!/bin/sh

PIDFILE=/var/run/backup-run.pid

if [ -f $PIDFILE ]; then
	echo $0 is already running with pid $(cat $PIDFILE), aborting!
	exit 1
fi

echo $$ >$PIDFILE

# Call backup script and capture output
FILENAME=$(date +"%Y%m%d_%H%M%S")_${NAME}.tar.gz
OUT_BUFF=$( /usr/local/sbin/backup-file.sh 2>&1 | tee /dev/tty )

retval=$?

# Email results
ssmtp "${MAIL_TO}" <<EOF
To:${MAIL_TO}
From:${SMTP_FROM}
Subject:Backup successful: ${FILENAME}
${OUT_BUFF}
EOF

rm $PIDFILE

exit $retval
