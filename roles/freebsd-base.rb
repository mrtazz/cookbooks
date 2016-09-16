name "freebsd-base"
description "freebsd servers base role"
run_list(
  "recipe[chef-client::freebsd]",
  "recipe[collectd::freebsd]",
  "recipe[collectd::disk]",
  "recipe[collectd::mailstats]",
  "recipe[collectd::cpu-temp]",
  "recipe[logging::freebsd]",
  "recipe[sysctl::freebsd]",
  "recipe[ipv6::freebsd]",
  "recipe[tmux]",
  "recipe[git]",
  "recipe[homedirs::mrtazz]",
  "recipe[sudo]",
  "recipe[nagios::nrpe]",
  "recipe[security::freebsd]",
  "recipe[security::duo]",
  "recipe[system::freebsd]",
  "recipe[system::zfs]",
  "recipe[cron::freebsd]",
  "recipe[sendmail::default]",
  "recipe[ohai-public_ip]"
)
