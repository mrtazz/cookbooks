#!/bin/sh

# nagios script to check age of snapshots

YESTERDAY=`date -v-1d +%Y-%m-%d`
EXITCODE=0
VOLUME="backup"

if [ -n "${1}" ]; then
  VOLUME=${1}
fi

for vol in $(ls /${VOLUME} | grep -v Archive); do
  zfs list -r -t snapshot ${VOLUME}/${vol}@${YESTERDAY}-23:00:00 > /dev/null 2>&1
  if [ $? != 0 ]; then
    zfs list -r -t snapshot ${VOLUME}/${vol}@${YESTERDAY}-23:00:01 > /dev/null 2>&1
    if [ $? != 0 ]; then
      echo "Snapshot of ${vol} missing for ${YESTERDAY}."
      EXITCODE=2
    fi
  fi
done

if [ ${EXITCODE} == 0 ]; then
  echo "All volumes on '${VOLUME}' were snapshotted on ${YESTERDAY}."
fi

exit ${EXITCODE}
