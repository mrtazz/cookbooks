template "/etc/sysctl.conf" do
  source "sysctl.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
end
