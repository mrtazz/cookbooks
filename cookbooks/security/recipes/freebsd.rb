template "/etc/ssh/sshd_config" do
  source "sshd_config.erb"
  owner "root"
  group "wheel"
  mode 0644
  notifies :restart, "service[sshd]"
end

service "sshd" do
  supports [:start, :stop, :restart]
  action :enable
end
