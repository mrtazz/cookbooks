package "python27"

package "collectd5" do
  action :install
end

plugin_dir = "/usr/local/collectd"

# install plugin directory and cron to run all plugins every minute
directory plugin_dir do
  owner "root"
  group "wheel"
  mode 0755
end

cron "run collectd plugins" do
  user "root"
  command "for cmd in $(ls #{plugin_dir}/collectd-* 2>/dev/null) ; do command ${cmd} ; done"
end

template "/usr/local/share/collectd/custom_types.db" do
  source "custom_types.db.erb"
  owner "root"
  group "wheel"
  mode 0700
  notifies :restart, "service[collectd]"
end

# create config file
template "/usr/local/etc/collectd.conf" do
  source "collectd.conf.erb"
  owner "root"
  group "wheel"
  mode 0700
  variables( :interval => 60, :timeout => 2, :readthreads => 1,
             :has_apache => node.recipe?("apache"),
             :has_bind => node.role?("homerouter")
)
  notifies :restart, "service[collectd]"
end

node.default[:yagd][:additional_metrics][:disk_performance] = {
  "Disk Octets" => "collectd.#{node[:fqdn].gsub(".","_")}.disk-ada*.disk_octets",
  "Disk Ops" => "collectd.#{node[:fqdn].gsub(".","_")}.disk-ada*.disk_ops",
  "Disk Time" => "collectd.#{node[:fqdn].gsub(".","_")}.disk-ada*.disk_time"
}


service "collectd" do
  supports [:start, :stop, :restart]
  action :enable
end
