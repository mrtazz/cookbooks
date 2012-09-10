#
# Cookbook Name:: sensu
# Recipe:: default
#

# install rabbitmq
include_recipe 'rabbitmq'

# install redis
package 'redis'

# install sensu gem
gem_package 'sensu'

# install sensu dashboard gem
gem_package 'sensu-dashboard'

template "/usr/local/etc/nginx/sites/sensu-dashboard.conf" do
  source "sensu-nginx.conf.erb"
  owner "root"
  group "wheel"
  mode  0755
end

# create FreeBSD directory stuff
directory '/usr/local/etc/sensu' do
  action :create
  owner 'root'
  group 'wheel'
end

directory '/usr/local/etc/sensu/conf.d' do
  action :create
  owner 'root'
  group 'wheel'
end

directory '/var/log/sensu' do
  action :create
  owner 'root'
  group 'wheel'
end

# get secrets for mrtazz
secret = Chef::EncryptedDataBagItem.load_secret("/root/.chef/credentials-bag.key")
creds = Chef::EncryptedDataBagItem.load("credentials", "sensu", secret)

template '/usr/local/etc/sensu/conf.d/config.json' do
  source 'config.json.erb'
  owner "root"
  group "wheel"
  mode  0555
  variables( :config => creds )
end

template "/usr/local/etc/rc.d/sensu_server" do
    source "sensu_startup.erb"
    mode 0755
    owner "root"
    group "wheel"
    variables :part => "server"
end

template "/usr/local/etc/rc.d/sensu_api" do
    source "sensu_startup.erb"
    mode 0755
    owner "root"
    group "wheel"
    variables :part => "api"
end

template "/usr/local/etc/rc.d/sensu_dashboard" do
    source "sensu_startup.erb"
    mode 0755
    owner "root"
    group "wheel"
    variables :part => "dashboard"
end

# start services
service 'rabbitmq' do
  action [:enable, :start]
end

service 'redis' do
  action [:enable, :start]
end

service 'nginx' do
  action :restart
end
