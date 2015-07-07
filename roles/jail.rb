name "jail"
description "freebsd servers base role"
run_list(
  "recipe[chef-client::freebsd]",
  "recipe[system::freebsd]",
  "recipe[collectd::freebsd]",
  "recipe[collectd::mailstats]",
  "recipe[logging::freebsd]",
  "recipe[sysctl::freebsd]",
  "recipe[ipv6::freebsd]",
  "recipe[git]",
  "recipe[sudo]",
  "recipe[nagios::nrpe]",
  "recipe[sendmail::default]",
  "recipe[ohai-public_ip]"
)
