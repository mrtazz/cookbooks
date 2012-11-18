#
# Cookbook Name:: bitlbee
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "bitlbee" do
  action :install
end

secret = Chef::EncryptedDataBagItem.load_secret("/root/.chef/credentials-bag.key")
creds = Chef::EncryptedDataBagItem.load("credentials", "mrtazz", secret)
md5sum = creds["bitlbee"]["md5sum"]

template "/usr/local/etc/bitlbee/bitlbee.conf" do
  source "bitlbee.conf.erb"
  owner "root"
  group "wheel"
  mode  0444
  variables( :md5password => md5sum )
  notifies :restart, "service[bitlbee]"
end

service "bitlbee" do
  supports [:start, :stop, :restart]
  action :enable
end
