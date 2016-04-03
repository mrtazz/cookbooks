#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

php_version = "56"

package "php#{php_version}" do
  action :install
end

package "mod_php#{php_version}" do
  action :install
end

package "php#{php_version}-openssl" do
  action :install
end

# let's also install the sqlite drivers

package "php56-sqlite3" do
  action :install
end

package "php56-pdo_sqlite" do
  action :install
end
