name "nagios"
description "run nagios"
default_attributes :nagios => {
  :fake_hosts => {
    :services_file => "external_fake_services",
    :hosts => [
      {:name => "ExternalChecks", :alias => "External Checks"}
    ]
  }
}
run_list(
  "recipe[system::ssl]",
  "recipe[php]",
  "recipe[apache]",
  "recipe[apache::ssl]",
  "recipe[nagios]"
)
