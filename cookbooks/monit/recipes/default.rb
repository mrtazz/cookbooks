#
# Cookbook Name:: monit
# Recipe:: default
#

# load databag with credentials for the monit frontend
secret = Chef::EncryptedDataBagItem.load_secret("#{node[:credentials][:secretpath]}")
creds = Chef::EncryptedDataBagItem.load("credentials", "monit", secret)

package "monit"

directory "/usr/local/etc/monit.rc.d/" do
  group "wheel"
  owner "root"
  mode 0755
  action :create
end

template "monitrc" do
  path "/usr/local/etc/monitrc"
  source "monitrc.erb"
  owner "root"
  group "wheel"
  mode 0700
  puts creds[:users]
  variables( :users => creds[:users] )
end

template "monit.rc.conf" do
  path "/etc/rc.conf.d/monit"
  source "monit.rc.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
end

if node[:monit][:web] == true
  template "monit.nginx.conf" do
    path "/usr/local/etc/nginx/sites/monit.conf"
    source "monit.nginx.conf.erb"
    owner "root"
    group "wheel"
    mode 0644
  end
end

service "monit" do
  action :start
end
