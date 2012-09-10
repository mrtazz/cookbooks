name "mailserver"
description "mail servers"
default_attributes :mail_domains => [
 ["unwiredcouch.com", "mrtazz"],
 ["lordofhosts.de", "mrtazz"],
 ["danielschauenberg.com", "mrtazz"],
 ["mrtazz.com", "mrtazz"],
 ["mrtazz.de", "mrtazz"],
 ["hoogy58.de", "mrtazz"]
]
run_list(
  "recipe[sensu::mailserver]",
  "recipe[sendmail::freebsd]"
)
