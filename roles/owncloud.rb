name "owncloud"
description "recipes to set up an owncloud server"
run_list(
  "recipe[system::ssl]",
  "recipe[apache]",
  "recipe[php]",
  "recipe[apache::ssl]",
  "recipe[owncloud]",
  "recipe[apache::owncloud]"
)
