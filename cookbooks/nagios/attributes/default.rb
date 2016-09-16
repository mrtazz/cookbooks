default[:nagios] = {}
default[:nagios][:disk] = {
  :temperature => {
    :warning => 55,
    :critical => 60
  },
  :devices => []
}
