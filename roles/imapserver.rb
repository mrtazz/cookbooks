name "imapserver"
description "imap servers"
run_list(
  "recipe[dovecot]",
  "recipe[sensu::dovecot]"
)
