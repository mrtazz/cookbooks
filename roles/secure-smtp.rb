name "secure-smtp"
description "secure smtp"
run_list(
  "recipe[system::ssl]",
  "recipe[sendmail::smtp]"
)
