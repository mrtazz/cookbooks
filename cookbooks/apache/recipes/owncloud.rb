davroot = "/home/mrtazz/owncloud"
the_group = "op_mrtazz"

group the_group do
  action :create
  members ["mrtazz", "www"]
end

directory davroot do
  action :create
  owner "www"
  group the_group
  mode "0770"
end

template "/usr/local/etc/apache22/Includes/owncloud.conf" do
  source "owncloud.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables( :docroot => davroot,
             :hostname => "owncloud.unwiredcouch.com" )
end
