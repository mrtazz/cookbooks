#!/bin/sh

# Example output:
# Statistics from Wed Jul  1 14:00:00 2015
#  M   msgsfr  bytes_from   msgsto    bytes_to  msgsrej msgsdis msgsqur  Mailer
#  3      825       4464K        0          0K       30       0       0  local
#  5        0          0K      825       4501K        0       0       0  esmtp
# =====================================================================
#  T      825       4464K      825       4501K       30       0       0
#  C      825                  855                   30

PLUGIN_NAME="mailstats"
HOSTNAME=$(hostname -f)
COLLECTD="/usr/local/bin/collectdctl"
MAILSTATS="/usr/sbin/mailstats -P"

${MAILSTATS} | tail -n+2 | while read ID MSGS_FROM BYTES_FROM MSGS_TO BYTES_TO MSGS_REJ MSGS_DISC MSGS_QUAR MAILERNAME ; do
    # skip totals and TCP connections for now
    if [ "${ID}" != "T" ] && [ "${ID}" != "C" ]; then
        ${COLLECTD} putval ${HOSTNAME}/${PLUGIN_NAME}-${MAILERNAME}/messages interval=60 N:${MSGS_TO}:${MSGS_FROM}
        ${COLLECTD} putval ${HOSTNAME}/${PLUGIN_NAME}-${MAILERNAME}/bytes interval=60 N:${BYTES_TO}:${BYTES_FROM}
        ${COLLECTD} putval ${HOSTNAME}/${PLUGIN_NAME}-${MAILERNAME}/messages_rejected interval=60 N:${MSGS_REJ}
        ${COLLECTD} putval ${HOSTNAME}/${PLUGIN_NAME}-${MAILERNAME}/messages_discarded interval=60 N:${MSGS_DISC}
        ${COLLECTD} putval ${HOSTNAME}/${PLUGIN_NAME}-${MAILERNAME}/messages_quarantined interval=60 N:${MSGS_QUAR}
    fi
done
