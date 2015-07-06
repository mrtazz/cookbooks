#!/bin/sh

PLUGIN_NAME="disktemp"
HOSTNAME=$(hostname -f)
SMARTCMD="/usr/local/sbin/smartctl"
COLLECTD="/usr/local/bin/collectdctl"

for disk in $(ls /dev/ada* | grep -o "ada[0-9]$"); do
    TEMP=$(${SMARTCMD} -a /dev/${disk} | grep 194 | awk '{print $10}')
    ${COLLECTD} putval ${HOSTNAME}/${PLUGIN_NAME}-${disk}/current interval=60 N:${TEMP}
done
