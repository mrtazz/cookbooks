default[:firewall] = {}
default[:firewall][:allowed_tcp] = [
  22, 25, 80, 443, 465, 587, 993,
  # graphite
  2003,
  # docker
  2376,
  # facetime
  5223,
  # git
  9418
]
default[:firewall][:allowed_udp] = [
  123,
  1196,
  # facetime
  "3478-3497",
  "16384-16387",
  "16393-16402",
  # mosh
  "60000-60010"
]
