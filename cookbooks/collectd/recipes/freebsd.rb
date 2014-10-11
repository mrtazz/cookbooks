package "python27"

package "collectd5" do
  action :install
end

# create config file
template "/usr/local/etc/collectd.conf" do
  source "collectd.conf.erb"
  owner "root"
  group "wheel"
  mode 0700
  variables( :interval => 60, :timeout => 2, :readthreads => 1,
             :has_apache => node.recipe?("apache") )
  notifies :restart, "service[collectd]"
end

service "collectd" do
  supports [:start, :stop, :restart]
  action :enable
end
