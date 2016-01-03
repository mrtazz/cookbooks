#!/bin/sh

# this needs the amdtemp or cputemp kernel module to be loaded

PLUGIN_NAME="cputemp"
HOSTNAME=$(hostname -f)
COLLECTD="/usr/local/bin/collectdctl"

/sbin/sysctl -a dev.cpu | \
awk -F '[\.:C]' '/temper/ {print $3" " $5"."$6}' | \
while read cpu temp; do
  ${COLLECTD} putval ${HOSTNAME}/${PLUGIN_NAME}-cpu${cpu}/celsius_current interval=60 N:${temp}
  if [ $? != 0 ]; then
    echo "ERROR ${0}: ${HOSTNAME}/${PLUGIN_NAME}-cpu${cpu}/celsius_current interval=60 N:${temp}"
  fi
done
