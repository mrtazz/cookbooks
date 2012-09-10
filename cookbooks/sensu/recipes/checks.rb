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
end

template '/usr/local/etc/sensu/conf.d/check-httpd.json' do
  source 'check-httpd.json.erb'
  owner 'root'
  group 'wheel'
  mode 0555
end

template '/usr/local/etc/sensu/conf.d/check-cron.json' do
  source 'check-cron.json.erb'
  owner 'root'
  group 'wheel'
  mode 0555
end


service 'sensu_server' do
  supports :restart => true
  action [:enable, :restart]
end

service 'sensu_dashboard' do
  action [:enable, :restart]
end

service 'sensu_client' do
  action [:enable, :restart]
end
