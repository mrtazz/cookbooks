#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

if node[:platform_version] =~ /^10.0/ or node[:apache_version] == "2.4"

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

  template "/usr/local/etc/apache24/Includes/status.conf" do
    source "status.conf.erb"
    owner "root"
    group "wheel"
    mode 0644
    variables({:hostname => node[:fqdn]})
  end

else
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

  template "/usr/local/etc/apache22/Includes/status.conf" do
    source "status.conf.erb"
    owner "root"
    group "wheel"
    mode 0644
    variables({:hostname => node[:fqdn]})
  end
end
