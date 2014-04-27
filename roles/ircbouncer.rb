name "ircbouncer"
description "irc bouncer running znc and bitlbee"
run_list(
  "recipe[znc]",
  "recipe[bitlbee]"
)
