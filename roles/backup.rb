name "backup"
description "backup servers"
default_attributes :duo => {
  :ssh => true
}
run_list(
  "recipe[backup]",
  "recipe[security::duo]"
)
