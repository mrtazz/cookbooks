include_recipe 'sensu::client'

# install plugin gem
gem_package 'sensu-plugin'

# create plugin directory
directory '/usr/local/etc/sensu/plugins' do
  action :create
  owner 'root'
  group 'wheel'
end

# checks
cookbook_file "/usr/local/etc/sensu/plugins/check-procs.rb" do
  source "check-procs.rb"
  mode 0755
  owner "root"
  group "wheel"
  notifies :restart, "service[sensu_client]"
end

template '/usr/local/etc/sensu/conf.d/check-dovecot.json' do
  source 'check-dovecot.json.erb'
  owner 'root'
  group 'wheel'
  mode 0555
  notifies :restart, "service[sensu_client]"
end

service 'sensu_client' do
  supports [:start, :stop, :restart]
  action :enable
end
