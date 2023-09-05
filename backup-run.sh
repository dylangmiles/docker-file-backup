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
LOGFILE=/root/$(date +"%Y%m%d_%H%M%S")_${NAME}.log.gz
OUT_BUFF=$( /usr/local/sbin/backup-file.sh 2>&1 | tee /proc/1/fd/1 >(gzip > $LOGFILE))

RETVAL=$?

# Calculate result in words
RESULT="unknown"
if [ "$RETVAL" == 0 ]; then
	RESULT="success"
else
	RESULT="failed"
fi

cat <<EOF | mutt -a ${LOGFILE} -s "Backup ${RESULT}: ${FILENAME}" -- $MAIL_TO
The backup log is attached.
EOF

rm $LOGFILE
rm $PIDFILE

exit $RETVAL
