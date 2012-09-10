if node[:ipv6]
  directory "/etc/rc.conf.d" do
    owner "root"
    group "wheel"
    mode 0755
    action :create
  end

  template "/etc/rc.conf.d/ipv6.conf" do
    source "ipv6.conf.erb"
    owner "root"
    group "wheel"
    mode 0644
  end
end
