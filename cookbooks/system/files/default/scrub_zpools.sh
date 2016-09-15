#!/bin/sh

ZPOOL="/sbin/zpool"

for pool in $(${ZPOOL} list -H -oname); do
    "${ZPOOL}" scrub "${pool}"
done
