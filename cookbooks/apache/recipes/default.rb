#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "apache24" do
  action :install
end

service "apache24" do
  action :enable
end

directory "/var/log/httpd/" do
  action :create
  owner "root"
  group "wheel"
  mode 0755
end

template "/usr/local/etc/apache24/httpd.conf" do
  source "apache24/httpd.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables( :has_php => node.recipes.include?("php"),
             :has_ssl => node.recipes.include?("apache::ssl"),
           )
end


template "/usr/local/etc/apache24/Includes/status.conf" do
  source "status.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables({:hostname => node[:fqdn]})
end

template "/usr/local/etc/apache24/extra/httpd-mpm.conf" do
  source "apache24/httpd-mpm.conf"
  owner "root"
  group "wheel"
  mode 0644
  variables({:hostname => node[:fqdn]})
end

