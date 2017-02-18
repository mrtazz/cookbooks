package "coreos-etcd3"

execute "add etcd group" do
  command "pw groupadd etcd"
  not_if "/usr/bin/getent group etcd"
end

execute "add etcd system user" do
  command "pw adduser etcd -g etcd -d /nonexistent -s /usr/sbin/nologin -c 'etcd system user'"
  not_if "/usr/bin/getent passwd etcd"
end

template "/usr/local/etc/rc.d/etcd" do
  source "etcd.rc.erb"
  owner "root"
  group "wheel"
  mode 0755
  variables()
end

[
  "/usr/local/etc/etcd",
  "/var/db/etcd",
  "/var/log/etcd"

].each do |dir|

  directory dir do
    owner "etcd"
    group "etcd"
  end

end

template "/usr/local/etc/etcd/config.yml" do
  source "etcd.conf.yml.erb"
  owner "etcd"
  group "etcd"
  mode 0755
  variables( :name => node[:etcd][:name] )
end

service "etcd" do
  action [:enable, :start]
end
