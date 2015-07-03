name "smokeping"
description "recipes to set up smokeping"
run_list(
  "recipe[apache]",
  "recipe[apache::smokeping]"
)
