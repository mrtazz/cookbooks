#!/bin/sh

# FreeBSD rc.d script for sensu-client

. /etc/rc.subr

name="sensu_client"
start_cmd="${name}_start"
stop_cmd="${name}_stop"
restart_cmd="${name}_restart"

sensu_client_start()
{
  /usr/local/bin/sensu-client -b \
                              -c /usr/local/etc/sensu/conf.d/config.json \
                              -d /usr/local/etc/sensu/conf.d \
                              -l /var/log/sensu/client.log \
                              -p /var/run/sensu-client.pid start
}

sensu_client_stop()
{
  /usr/local/bin/sensu-client -b \
                              -c /usr/local/etc/sensu/conf.d/config.json \
                              -d /usr/local/etc/sensu/conf.d \
                              -l /var/log/sensu/client.log \
                              -p /var/run/sensu-client.pid stop
}

sensu_client_restart()
{
  sensu_client_stop
  sensu_client_start
}

load_rc_config $name
run_rc_command "$1"
