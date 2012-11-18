name "ircbouncer"
description "irc bouncer running znc and bitlbee"
run_list(
  "recipe[sensu::ircbouncer]",
  "recipe[znc]",
  "recipe[bitlbee]"
)
