name "nagios"
description "run nagios"
run_list(
  "recipe[php]",
  "recipe[apache]",
  "recipe[apache::ssl]",
  "recipe[nagios]"
)
