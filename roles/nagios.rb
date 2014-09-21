name "nagios"
description "run nagios"
run_list(
  "recipe[system::ssl]",
  "recipe[php]",
  "recipe[apache]",
  "recipe[apache::ssl]",
  "recipe[nagios]"
)
