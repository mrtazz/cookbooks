name "workstation"
description "Mac OS X workstaions"
run_list(
  "recipe[git]",
  "recipe[oh-my-zsh]",
  "recipe[ruby]",
  "recipe[python]",
  "recipe[mvim]",
  "recipe[kerl]",
  "recipe[ghmac]",
  "recipe[iterm2]",
  "recipe[macosx-workstation]"
)
