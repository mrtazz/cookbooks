#
# Cookbook Name:: nagios
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "nagios4" do
  action :install
end

nagios_dirs = %w{
  hosts
  commands
  services
  contacts
  timeperiods
  templates
  hostgroups
}

roles = ["VirtualServers"]
# get secrets
secret = Chef::EncryptedDataBagItem.load_secret("/root/.chef/credentials-bag.key")
pushover_creds = Chef::EncryptedDataBagItem.load("credentials", "pushover", secret)
pushover_key = pushover_creds["nagios_key"]
mrtazz_creds = Chef::EncryptedDataBagItem.load("credentials", "mrtazz", secret)
mrtazz_pushover_id = mrtazz_creds["pushover_id"]
slack_creds = Chef::EncryptedDataBagItem.load("credentials", "slack", secret)

search(:role, "name:*") do |role|
  roles << role.name
end

nagios_dirs.each do |cfg_dir|
  directory "/usr/local/etc/nagios/#{cfg_dir}" do
    action :create
    owner "root"
    group "wheel"
    mode 0755
  end
  unless cfg_dir.eql? "hosts"
    template "/usr/local/etc/nagios/#{cfg_dir}/#{cfg_dir}.cfg" do
      source "#{cfg_dir}.cfg.erb"
      owner "root"
      group "wheel"
      mode 0644
      variables( :hostgroups => roles,
                 :pushover_key => pushover_key,
                 :mrtazz_pushover_id => mrtazz_pushover_id
               )
    end
  end
end

template "/usr/local/etc/apache24/Includes/nagios.conf" do
  source "nagios_apache.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
end

template "/usr/local/etc/nagios/nagios.cfg" do
  source "nagios.cfg.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables(:cfg_dirs => nagios_dirs)
end

template "/usr/local/etc/nagios/resource.cfg" do
  source "resource.cfg.erb"
  owner "root"
  group "wheel"
  mode 0644
end

template "/usr/local/etc/nagios/cgi.cfg" do
  source "cgi.cfg.erb"
  owner "root"
  group "wheel"
  mode 0644
end

# install deps for slack notifier
[
  "p5-libwww",
  "p5-Crypt-SSLeay"
]. each do |pkg|
  package pkg do
    action :install
  end
end

template "/usr/local/libexec/nagios/notify_slack.pl" do
  source "nagios_slack.pl.erb"
  owner "root"
  group "wheel"
  mode 0755
  variables( :token => slack_creds["nagios_token"] )
end

# this is just because nagios needs a localhost definition
template "/usr/local/etc/nagios/hosts/localhost.cfg" do
  source "host.cfg.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables( :server => {
      :name => "localhost",
      :fqdn => "localhost",
      :ip   => "127.0.0.1",
      :hostgroups => []
    })
end


nodes = search(:node, "domain:*unwiredcouch.com")
my_subdomain = node[:fqdn].split(".").drop(1).join(".")

nodes.each do |computer|

  subdomain = computer[:fqdn].split(".").drop(1).join(".")

  next unless subdomain == my_subdomain

  hostgroups = []
  if computer[:roles]
    computer[:roles].each do |role|
      hostgroups << "#{role}"
    end
  end

  if computer[:is_virtual]
    hostgroups << "VirtualServers"
  end

  template "/usr/local/etc/nagios/hosts/#{computer[:fqdn]}.cfg" do
    source "host.cfg.erb"
    owner "root"
    group "wheel"
    mode 0644
    variables( :server => {
      :name => computer[:fqdn].sub('.unwiredcouch.com', ''),
      :fqdn => computer[:fqdn],
      :ip   => computer[:ipaddress],
      :hostgroups => hostgroups
    })
  end

end

template "/usr/local/etc/nagios/hosts/fake_hosts.cfg" do
  source "fake_host.cfg.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables( :hosts => node[:nagios][:fake_hosts][:hosts] )
end

template "/usr/local/etc/nagios/services/fake_services.cfg" do
  source "#{node[:nagios][:fake_hosts][:services_file]}.cfg.erb"
  owner "root"
  group "wheel"
  mode 0644
end

service "nagios" do
  action :enable
end
