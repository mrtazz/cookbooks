#
# Cookbook Name:: backup
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/root/snapshot_backup_volumes.sh" do
  source "snapshot_backup_volumes.sh.erb"
  owner "root"
  group "wheel"
  mode 0755
end

cron "daily backup snapshot" do
  command "/root/snapshot_backup_volumes.sh"
  hour "23"
  minute "0"
  action :create
end

cron "mrtazz backup script" do
  command "/home/mrtazz/bin/backup.sh"
  minute "*/15"
  user "mrtazz"
  action :create
end
