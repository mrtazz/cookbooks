#!/bin/sh

RELREGEX='[0-9.]*\?-RELEASE-p[0-9]*\?'
NEEDSUPDATING=$(sed 's/\[ ! -t 0 \]/false/' /usr/sbin/freebsd-update | sh -s fetch | grep "files will be ")

if [ "z${NEEDSUPDATING}" == "z" ]; then
  echo "FreeBSD installation up-to-date."
  exit 0
else
  ISREL=$(uname -r)
  SHOULDREL=$(echo "${NEEDSUPDATING}" | grep -o -m1 "${RELREGEX}")
  echo "FreeBSD installation is on ${ISREL} and should be on ${SHOULDREL}"
  exit 2
fi
