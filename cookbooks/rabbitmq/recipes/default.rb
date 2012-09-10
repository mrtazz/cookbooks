#
# Cookbook Name:: rabbitmq
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'rabbitmq'

template '/usr/local/etc/rabbitmq/rabbitmq.config' do
  source "rabbitmq.config.erb"
  mode   0700
  owner  "rabbitmq"
  group  "rabbitmq"
end
