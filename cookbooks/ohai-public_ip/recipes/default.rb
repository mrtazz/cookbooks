#
# Cookbook Name:: ohai-public_ip
# Recipe:: ohai-public_ip
#

include_recipe 'chef-client::config' # update the chef-client configuration with the custom plugin path

package 'curl'

ohai 'reload_ohai-public_ip' do
  action :reload
  plugin 'ohai-public_ip'
end

include_recipe 'ohai' # In conjunction with attribute setting, tells Chef to drop the plugin file where Ohai can find it.
