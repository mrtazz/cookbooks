name "blog"
description "recipes to set up blog hosting"
run_list(
  "recipe[apache]",
  "recipe[apache::ssl]",
  "recipe[apache::unwiredcouch.com]"
)
