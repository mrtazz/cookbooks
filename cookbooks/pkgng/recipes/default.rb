#
# Cookbook Name:: pkgng
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/usr/local/etc/pkg/repos/FreeBSD.conf" do
  source "freebsd.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
end

Chef::Platform.set({
  :platform => :freebsd,
  :resource => :package,
  :provider => Chef::Provider::Package::Pkgng
})
