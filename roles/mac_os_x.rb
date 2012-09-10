name "mac_os_x"
description "Role applied to all Mac OS X systems."

run_list(
  "recipe[homebrew]", "recipe[dmg]", "recipe[osxzip]"
)
