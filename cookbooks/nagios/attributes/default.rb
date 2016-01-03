default[:nagios] = {}

default[:nagios][:external_fake_hosts] = {
  :services_file => "external_fake_services",
  :hosts => [
    {:name => "ExternalChecks", :alias => "External Checks"}
  ]
}

default[:nagios][:home_fake_hosts] = {
  :services_file => "home_fake_services",
  :hosts => []
}
