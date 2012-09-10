#!/bin/sh

# FreeBSD rc.d script for sensu-server

. /etc/rc.subr

name="sensu_server"
start_cmd="${name}_start"
stop_cmd="${name}_stop"
restart_cmd="${name}_restart"

sensu_server_start()
{
  /usr/local/bin/sensu-server -b \
                              -c /usr/local/etc/sensu/conf.d/config.json \
                              -d /usr/local/etc/sensu/conf.d \
                              -l /var/log/sensu/server.log \
                              -p /var/run/sensu-server.pid start
}

sensu_server_stop()
{
  /usr/local/bin/sensu-server -b \
                              -c /usr/local/etc/sensu/conf.d/config.json \
                              -d /usr/local/etc/sensu/conf.d \
                              -l /var/log/sensu/server.log \
                              -p /var/run/sensu-server.pid stop
}

sensu_server_restart()
{
  sensu_server_stop
  sensu_server_start
}

load_rc_config $name
run_rc_command "$1"
