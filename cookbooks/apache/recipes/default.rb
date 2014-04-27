#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "apache22" do
  action :install
end

service "apache22" do
  action :enable
end

directory "/var/log/httpd/" do
  action :create
  owner "root"
  group "wheel"
  mode 0755
end
