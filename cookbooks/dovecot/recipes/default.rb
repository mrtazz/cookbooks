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

# create ssl cert if it doesn't exist

directory "/usr/local/etc/ssl/certs" do
  owner "root"
  group "wheel"
  mode 0755
  action :create
  recursive true
end

directory "/usr/local/etc/ssl/private" do
  owner "root"
  group "wheel"
  mode 0755
  action :create
  recursive true
end

script "generate ssl cert" do
  interpreter "sh"
  cwd "/root"
  code <<-EOH
  umask 077
  openssl genrsa 2048 > dovecot.key
  openssl req -subj /C=US/ST=Several/L=Locality/O=Example/OU=Operations/CN=#{node['fqdn']}/emailAddress=root@#{node['fqdn']} \
-new -x509 -nodes -sha1 -days 3650 -key dovecot.key > dovecot.crt
  cat dovecot.key dovecot.crt > dovecot.pem
  mv dovecot.pem /usr/local/etc/ssl/certs/dovecot.pem
  mv dovecot.key /usr/local/etc/ssl/private/dovecot.key
  EOH
  user "root"
  group "wheel"
  creates "/usr/local/etc/ssl/certs/dovecot.pem"
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
