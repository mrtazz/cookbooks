#
# Cookbook Name:: sudo
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "sudo" do
  action :install
end

template "/usr/local/etc/sudoers" do
  source "sudoers.erb"
  owner "root"
  group "wheel"
  mode 0440
end
