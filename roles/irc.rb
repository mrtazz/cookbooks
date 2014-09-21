name "irc"
description "irc server"
run_list(
  "recipe[system::ssl]",
  "recipe[irc]"
)
