package "python27"

script "install collectd" do
  interpreter "sh"
  cwd "/usr/ports/net-mgmt/collectd5"
  code <<-EOS
  make -DBATCH -DWITH_PYTHON -DWITHOUT_RRDTOOL -DWITHOUT_RRDCACHED install clean
  EOS
  not_if { File.exists? "/usr/local/sbin/collectd" }
end

template "/usr/local/lib/collectd/collectd-librato.py" do
  source "collectd-librato.py.erb"
  mode "0744"
  owner "root"
  group "wheel"
  variables( :types_db => "/usr/local/share/collectd/types.db" )
  notifies :restart, "service[collectd]"
end

# get secrets for librato metrics
librato_secret = Chef::EncryptedDataBagItem.load_secret("/root/.chef/credentials-bag.key")
librato_creds = Chef::EncryptedDataBagItem.load("credentials", "librato", librato_secret)
token = librato_creds["token"]
user = librato_creds["user"]

# create config file
template "/usr/local/etc/collectd.conf" do
  source "collectd.conf.erb"
  owner "root"
  group "wheel"
  mode 0700
  variables( :interval => 60, :timeout => 2, :readthreads => 1,
             :librato_user => user, :librato_token => token)
  notifies :restart, "service[collectd]"
end

service "collectd" do
  supports [:start, :stop, :restart]
  action :enable
end
