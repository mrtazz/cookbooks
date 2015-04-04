#
# Cookbook Name:: dovecot
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "dovecot2" do
  action :install
end

template "/usr/local/etc/dovecot/dovecot.conf" do
  source "dovecot.conf.erb"
  owner "root"
  group "wheel"
  mode 0600
  notifies :restart, "service[dovecot]"
end

# get secrets for mrtazz
secret = Chef::EncryptedDataBagItem.load_secret("/root/.chef/credentials-bag.key")
creds = Chef::EncryptedDataBagItem.load("credentials", "dovecot", secret)
users = creds["users"]

# create the users DB
template "/var/db/dovecot.users" do
  source "passwd-file.erb"
  owner "root"
  group "wheel"
  mode 0600
  variables( :users => users )
  notifies :restart, "service[dovecot]"
end


service "dovecot" do
  supports [:start, :stop, :restart]
  action :enable
end
