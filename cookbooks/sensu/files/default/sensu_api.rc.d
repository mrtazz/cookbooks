#!/bin/sh

# FreeBSD rc.d script for sensu-api

. /etc/rc.subr

name="sensu_api"
start_cmd="${name}_start"
stop_cmd="${name}_stop"
restart_cmd="${name}_restart"

sensu_api_start()
{
  /usr/local/bin/sensu-api -b \
                           -c /usr/local/etc/sensu/conf.d/config.json \
                           -d /usr/local/etc/sensu/conf.d \
                           -l /var/log/sensu/api.log \
                           -p /var/run/sensu-api.pid start
}

sensu_api_stop()
{
  /usr/local/bin/sensu-api -b \
                           -c /usr/local/etc/sensu/conf.d/config.json \
                           -d /usr/local/etc/sensu/conf.d \
                           -l /var/log/sensu/api.log \
                           -p /var/run/sensu-api.pid stop
}

sensu_api_restart()
{
  sensu_api_stop
  sensu_api_start
}

load_rc_config $name
run_rc_command "$1"
