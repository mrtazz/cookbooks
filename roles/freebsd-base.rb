name "freebsd-base"
description "freebsd servers base role"
run_list(
  "recipe[chef-client::freebsd]",
  "recipe[collectd::freebsd]",
  "recipe[logging::freebsd]",
  "recipe[sysctl::freebsd]",
  "recipe[ipv6::freebsd]",
  "recipe[tmux]",
  "recipe[git]",
  "recipe[homedirs::mrtazz]",
  "recipe[sudo]",
  "recipe[nagios::nrpe]",
  "recipe[security::freebsd]",
  "recipe[system::freebsd]",
  "recipe[cron::freebsd]",
  "recipe[sendmail::default]",
  "recipe[ohai-public_ip]"
)
