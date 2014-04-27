#
# Cookbook Name:: sendmail
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
service "sendmail" do
  supports [:start, :stop, :restart]
  action :enable
end
