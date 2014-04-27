#!/bin/sh

# check to figure out if chef is running

NUMBER=$(ps ax | grep "chef-client" | grep -v "grep" | wc -l | sed "s/ //g")

if [ ${NUMBER} -lt 1 ] ; then
  echo "${NUMBER} processes found matching \"chef-client\"."
  exit 2
else
  echo "\"chef-client\" is running."
  exit 0
fi
