name "omnipresence"
description "recipes to set up an omnipresence server"
run_list(
  "recipe[apache]",
  "recipe[apache::ssl]",
  "recipe[apache::omnipresence]"
)
