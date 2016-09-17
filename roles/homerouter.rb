name "homerouter"
description "recipes to set up a homerouter"
default_attributes :duo => {
  :ssh => true
}
override_attributes :nagios => {
  :fake_hosts => {
    :services_file => "home_fake_services",
    :hosts => []
  }
}
run_list(
  "role[nagios]",
  "role[smokeping]",
  "recipe[collectd::ipfw]",
  "recipe[homerouter::dhcp]",
  "recipe[homerouter::nat]",
  "recipe[homerouter::firewall]",
  "recipe[homerouter::dns]",
  "recipe[homerouter::dynamic_dns]"
)
