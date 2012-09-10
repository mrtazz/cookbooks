name "webserver"
description "generic webserver role"

run_list(
  "recipe[nginx]"
)
