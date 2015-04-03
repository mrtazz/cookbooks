name "jail-extended"
description "freebsd extended jail role for jails having a user"
run_list(
  "role[jail]",
  "recipe[security::freebsd]",
  "recipe[homedirs::mrtazz]"
)
