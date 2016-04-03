package "smokeping" do
  action :install
end

template "/usr/local/etc/apache24/Includes/smokeping.conf" do
  source "smokeping.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables( :hostname => "smokeping-nyc.unwiredcouch.com")
  notifies :restart, "service[apache24]"
end

template "/usr/local/etc/smokeping/config" do
  source "smokeping.config.erb"
  owner "root"
  group "wheel"
  mode 0644
  notifies :restart, "service[smokeping]"
end

service "apache24" do
  action [:enable, :start]
  supports [:restart]
end

service "smokeping" do
  action [:enable, :start]
  supports [:restart]
end
