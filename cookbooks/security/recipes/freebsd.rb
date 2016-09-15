use_duo = node[:duo][:ssh] rescue false
template "/etc/ssh/sshd_config" do
  source "sshd_config.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables ( {
    :no_passwords => (node.role? "jail-extended") ? true : false,
    :use_duo => use_duo,
    :listen_all => (node.role? "homerouter") ? true : false
  } )
  notifies :restart, "service[sshd]"
end

service "sshd" do
  supports [:start, :stop, :restart]
  action :enable
end
