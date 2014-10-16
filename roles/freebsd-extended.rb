name "freebsd-extended"
description "freebsd servers extended role"
run_list(
  "recipe[zsh]",
  "recipe[curl]",
  "recipe[htop]",
  "recipe[rsync]",
  "recipe[elinks]",
  "recipe[mosh]",
  "recipe[mutt::freebsd]",
  "recipe[weechat]",
  "recipe[vim]",
  "recipe[procmail]",
  "recipe[fetchmail]"
)
