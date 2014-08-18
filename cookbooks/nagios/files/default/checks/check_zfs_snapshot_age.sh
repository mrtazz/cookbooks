#!/bin/sh

# nagios script to check age of backup snapshots

YESTERDAY=`date -v-1d +%Y-%m-%d`
EXITCODE=0

for backup in $(zfs list -r -o name -H backup | grep "/"); do
  zfs list -r -t snapshot ${backup}@${YESTERDAY}-23:00:00 > /dev/null 2>&1
  if [ $? != 0 ]; then
    echo "Snapshot of ${backup} missing for ${YESTERDAY}."
    EXITCODE=2
  fi
done

if [ ${EXITCODE} == 0 ]; then
  echo "All backup volumes were snapshotted on ${YESTERDAY}."
fi

exit ${EXITCODE}
