gem_package "syslog-logger" do
  action :install
end
gem_package "SyslogLogger" do
  action :remove
end

gem_package "knife-lastrun" do
  action :install
end

service "chef_client" do
  supports [:start, :stop, :restart]
  action :enable
  ignore_failure true
end

ruby_block "reload_client_config" do
  block do
    Chef::Config.from_file("#{node["chef_client"]["conf_dir"]}/client.rb")
  end
  action :nothing
end

template "#{node["chef_client"]["conf_dir"]}/client.rb" do
  source "client.rb.erb"
  mode 0644
  owner "root"
  group "wheel"
  variables ({ :chefbasedir => node["chef_client"]["conf_dir"] })
  notifies :create, "ruby_block[reload_client_config]"
end
