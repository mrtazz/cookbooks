package "nrpe" do
  action :install
end

nagioshosts = ["127.0.0.1", node[:ipaddress]]
plugindir = "/usr/local/nagios/plugins"
node_nagiosconfig = node[:nagios] || {}

nodes = search(:node, "roles:nagios")
my_subdomain = node[:fqdn].split(".").drop(1).join(".")

nodes.each do |computer|

  subdomain = computer[:fqdn].split(".").drop(1).join(".")
  next unless subdomain == my_subdomain

  computer[:network]['interfaces'].each do |iface, addrs|
    addresses =  addrs['addresses'] || []
    addresses.each do |ip, params|
      nagioshosts << ip if params['family'].eql?('inet')
    end
  end

end

directory plugindir do
  action :create
  owner "root"
  group "wheel"
  mode 0755
  recursive true
end

checks = [
  {:name => "check_portaudit", :script => "check_portaudit.sh"},
  {:name => "check_zpool", :script => "check_zpool.sh"},
  {:name => "check_snapshots", :script => "check_zfs_snapshot_age.sh"},
  {:name => "check_freebsd_kernel", :script => "check_freebsd_kernel.sh"},
  {:name => "check_freebsd_update", :script => "check_freebsd_update.sh", :run_with_sudo => true}
]

checks.each do |check|
  cookbook_file "#{plugindir}/#{check[:script]}" do
    source "checks/#{check[:script]}"
    owner "root"
    group "wheel"
    mode 0555
  end
end

package "nagios-check_smartmon" do
  action :install
end

template "#{plugindir}/check_smartmon.sh" do
  source "checks/check_smartmon.sh.erb"
  owner "root"
  group "wheel"
  mode 0555
  variables( :disks => node_nagiosconfig[:disks] || []  )
end

template "/usr/local/etc/nrpe.cfg" do
  source "nrpe.cfg.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables( :nagioshosts => nagioshosts, :checks => checks, :plugindir => plugindir )
  notifies :restart, "service[nrpe2]"
end

service "nrpe2" do
  action [:enable, :start]
  supports [:enable, :start, :stop, :restart]
end
