#!/bin/sh

# nagios script to check age of backup snapshots

YESTERDAY=`date -v-1d +%Y-%m-%d`
EXITCODE=0

for backup in $(ls /backup); do
  zfs list -t snapshot | grep ${backup} | grep -q ${YESTERDAY}
  if [ $? != 0 ]; then
    echo "Snapshot of ${backup} missing for ${YESTERDAY}."
    EXITCODE=2
  fi
done

if [ ${EXITCODE} == 0 ]; then
  echo "All backup volumes were snapshotted on ${YESTERDAY}."
fi

exit ${EXITCODE}
