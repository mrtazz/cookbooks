service "syslogd" do
  supports [:start, :stop, :restart]
  action :nothing
end

cookbook_file "/etc/syslog.conf" do
  source "syslog.conf"
  mode 0644
  owner "root"
  group "wheel"
  notifies :restart, "service[syslogd]"
end

cookbook_file "/etc/newsyslog.conf" do
  source "newsyslog.conf"
  mode 0644
  owner "root"
  group "wheel"
end
