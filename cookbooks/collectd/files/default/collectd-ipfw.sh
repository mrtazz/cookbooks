#!/bin/sh

PLUGIN_NAME="ipfw"
HOSTNAME=$(hostname -f)
COLLECTD="/usr/local/bin/collectdctl"
IPFW="/sbin/ipfw"

DYNAMIC_RULES=$(${IPFW} -d list | awk '/Dynamic rules/{print $4}' | grep -o '[0-9]\{1,4\}')

if [ -n "${DYNAMIC_RULES}" ]; then
  ${COLLECTD} putval ${HOSTNAME}/${PLUGIN_NAME}/dynamic_rules interval=60 N:${DYNAMIC_RULES}
  if [ $? != 0 ]; then
    echo "ERROR ${0}: ${HOSTNAME}/${PLUGIN_NAME}/dynamic_rules interval=60 N:${DYNAMIC_RULES}"
  fi
fi
