name "freebsd-extended"
description "freebsd servers extended role"
run_list(
  "recipe[zsh]",
  "recipe[curl]",
  "recipe[htop]",
  "recipe[rsync]",
  "recipe[elinks]",
  "recipe[mosh::freebsd]",
  "recipe[mutt::freebsd]",
  "recipe[weechat::freebsd]",
  "recipe[vim::freebsd]",
  "recipe[procmail]",
  "recipe[fetchmail]"
)
