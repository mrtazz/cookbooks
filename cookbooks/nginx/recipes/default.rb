#
# Cookbook Name:: nginx
# Recipe:: default
#

script "install nginx" do
  interpreter "sh"
  cwd "/usr/ports/www/nginx"
  code <<-EOS
  make -DBATCH -DWITH_HTTP_SSL_MODULE install clean
  EOS
  not_if { File.exists? "/usr/local/sbin/nginx" }
end

directory "/usr/local/etc/nginx/sites" do
  owner "root"
  group "wheel"
  mode "0755"
  action :create
end

directory "/var/log/nginx" do
  owner "root"
  group "wheel"
  mode  0755
  action :create
end

template "nginx.conf" do
  path "/usr/local/etc/nginx/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
end

service "nginx" do
  action [:enable, :start]
end
