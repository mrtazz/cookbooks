name "workstation"
description "Mac OS X workstaions"
run_list(
  "recipe[git]",
  "recipe[iterm2]",
  "recipe[homedirs::mrtazz]"

)
