#!/bin/sh

# FreeBSD rc.d script for sensu-dashboard

. /etc/rc.subr

name="sensu_dashboard"
start_cmd="${name}_start"
stop_cmd="${name}_stop"
restart_cmd="${name}_restart"

sensu_dashboard_start()
{
  /usr/local/bin/sensu-dashboard -b \
                                 -c /usr/local/etc/sensu/conf.d/config.json \
                                 -d /usr/local/etc/sensu/conf.d \
                                 -l /var/log/sensu/dashboard.log \
                                 -p /var/run/sensu-dashboard.pid start
}

sensu_dashboard_stop()
{
  /usr/local/bin/sensu-dashboard -b \
                                 -c /usr/local/etc/sensu/conf.d/config.json \
                                 -d /usr/local/etc/sensu/conf.d \
                                 -l /var/log/sensu/dashboard.log \
                                 -p /var/run/sensu-dashboard.pid stop
}

sensu_dashboard_restart()
{
  sensu_dashboard_stop
  sensu_dashboard_start
}


load_rc_config $name
run_rc_command "$1"
