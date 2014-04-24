name "graphite"
description "graphite serving role"
run_list(
  "recipe[apache]",
  "recipe[apache::ssl]",
  "recipe[graphite]",
  "recipe[apache::graphite]"
)
