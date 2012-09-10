# install client gem
gem_package 'sensu'

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

directory '/var/log/sensu' do
  action :create
  owner 'root'
  group 'wheel'
end

# install init script
template "/usr/local/etc/rc.d/sensu_client" do
    source "sensu_startup.erb"
    mode 0755
    owner "root"
    group "wheel"
    variables(:part => "client")
end

template '/usr/local/etc/sensu/conf.d/client.json' do
  source 'client.json.erb'
  owner 'root'
  group 'wheel'
  mode 0555
  variables(:subscriptions => ["servers"])
end

service 'sensu_client' do
  action :enable
end
