name "smokeping"
description "recipes to set up smokeping"
run_list(
  "recipe[apache]",
  "recipe[system::ssl]",
  "recipe[apache::ssl]",
  "recipe[apache::smokeping]"
)
