gem_package "knife-lastrun" do
  action :install
end

template "#{node["chef_client"]["conf_dir"]}/client.rb" do
  source "client.rb.erb"
  mode 0644
  owner "root"
  group "wheel"
  variables ({ :chefbasedir => node["chef_client"]["conf_dir"] })
end

directory "/var/log/chef" do
  action :create
  owner "root"
  group "wheel"
end

cron "chef-client" do
  command "/usr/bin/chef-client -l error -L /var/log/chef/client.log --config /usr/local/etc/chef/client.rb --once"
  minute "*/15"
end

service "chef_client" do
  action [:disable, :stop]
  ignore_failure true
end
