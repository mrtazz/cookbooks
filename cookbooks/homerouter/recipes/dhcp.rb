secret = Chef::EncryptedDataBagItem.load_secret("/root/.chef/credentials-bag.key")
creds = Chef::EncryptedDataBagItem.load("credentials", "dns", secret)

package "isc-dhcp43-server-4.3.4" do
  action :install
end

template "/usr/local/etc/dhcpd.conf" do
  source "dhcpd.conf.erb"
  owner "root"
  group "wheel"
  mode  0644
  variables({ :key => creds["key"] })
  notifies :restart, "service[dhcpd]"
end

service "dhcpd" do
  action [:enable, :start]
  supports [:restart]
  service_name "isc-dhcpd"
end
