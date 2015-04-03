name "imapserver"
description "imap servers"
run_list(
  "recipe[system::ssl]",
  "recipe[dovecot]"
)
