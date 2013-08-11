name "freebsd-base"
description "freebsd servers base role"
run_list(
  "recipe[chef-client::freebsd]",
  "recipe[collectd::freebsd]",
  "recipe[logging::freebsd]",
  "recipe[sysctl::freebsd]",
  "recipe[ipv6::freebsd]",
  "recipe[tmux]",
  "recipe[git::freebsd]",
  "recipe[homedirs::mrtazz]",
  "recipe[sensu::client]",
  "recipe[sensu::chef-client]",
  "recipe[sensu::server]",
  "recipe[security::freebsd]",
  "recipe[system::freebsd]",
  "recipe[cron::freebsd]"
)
