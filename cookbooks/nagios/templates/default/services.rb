#!/bin/env ruby

require "alertdesigner"
require "alertdesigner/formatters/nagios"

AlertDesigner.define do

  # let's use the Nagios formatter
  formatter AlertDesigner::Formatters::Nagios do
    check_template "local-service"
  end

  checks = {
    "freebsd-base" => {
      "PING"                     => "check_ping!500.0,20%!1000.0,60%",
      "vulnerable packages"      => "check_nrpe!check_portaudit",
      "FreeBSD security updates" => "check_nrpe!check_freebsd_update",
      "FreeBSD kernel version"   => "check_nrpe!check_freebsd_kernel",
      "SMTP"                     => "check_smtp",
      "SSH"                      => "check_ssh",
      "/ partition"              => "check_nrpe!check_root",
      "/usr partition"           => "check_nrpe!check_usr",
      "/var partition"           => "check_nrpe!check_var",
      "collectd running"         => "check_nrpe!check_collectd",
    },
    "freebsd-base, !VirtualServers" => {
      "zpool status"             => "check_nrpe!check_zpool",
      "disk smartmon health"     => "check_nrpe!check_smartmon",
    },
    "jail" => {
      "collectd_running"         => "check_nrpe!check_collectd",
      "vulnerable packages"      => "check_nrpe!check_portaudit",
    },
    "backup" => {
      "backup snapshot age"      => "check_nrpe!check_snapshots",
    },
    "mailserver" => {
      "SMTP"                     => "check_smtp",
    },
    "secure-smtp" => {
      "SMTP TLS"                 => "check_smtp_tls",
      "saslauthd"                => "check_nrpe!check_saslauthd",
    },
    "ircbouncer" => {
      "znc bouncer"              => "check_tcp!33333",
    },
    "imapserver" => {
      "IMAP"                     => "check_imap",
    },
    "smokeping" => {
      "smokeping HTTP"           => "check_nrpe!check_smokeping_http",
      "smokeping running"        => "check_nrpe!check_smokeping",
    },
    "homerouter" => {
      "BIND"                     => "check_nrpe!check_bind",
      "DHCPD"                    => "check_nrpe!check_dhcpd",
    },
    "owncloud" => {
      "owncloud"                 => "check_http!owncloud.unwiredcouch.com",
      "owncloud HTTPS"           => "check_https!owncloud.unwiredcouch.com",
    },
    "nagios" => {
      "Current Users"            => "check_local_users!5!7",
      "Current Load"             => "check_local_load!5.0,4.0,3.0!10.0,6.0,4.0",
      "Swap Usage"               => "check_local_swap!20!10",
    },
  }



  # define some base checks with repeating properties
  checks.each do |role, services|
    services.each do |description, check_cmd|
      check description do
        hostgroups [role]
        command check_cmd
      end
    end
  end

end

puts "# Contents are generated from #{__FILE__}"
puts AlertDesigner.format
