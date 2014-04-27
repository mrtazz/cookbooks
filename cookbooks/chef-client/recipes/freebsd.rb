gem_package "syslog-logger" do
  action :install
end
gem_package "SyslogLogger" do
  action :remove
end

gem_package "chef-irc-snitch" do
  action :install
end

gem_package "knife-lastrun" do
  action :install
end

node.default["chef_client"]["conf_dir"] = "/root/.chef/"

service "chef_client" do
  supports [:start, :stop, :restart]
  action :enable
  ignore_failure true
end

ruby_block "reload_client_config" do
  block do
    Chef::Config.from_file("/root/.chef/client.rb")
  end
  action :nothing
end

template "/root/.chef/client.rb" do
  source "client.rb.erb"
  mode 0644
  owner "root"
  group "wheel"
  variables ({ :chefbasedir => '/root/.chef' })
  notifies :create, "ruby_block[reload_client_config]"
end

cookbook_file "/usr/local/etc/rc.d/chef_client" do
  source "chef-client.rc"
  owner "root"
  group "wheel"
  mode  0744
  notifies :restart, "service[chef_client]"
end

