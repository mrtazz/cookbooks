firewall_script = "/etc/ipfw.rules"

# attribute based firewall rules
allowed_tcp = (node[:firewall][:allowed_tcp] || [])
allowed_udp = (node[:firewall][:allowed_udp] || [])
allowed_tcp_inbound = (node[:firewall][:allowed_tcp_inbound] || [22])

template firewall_script do
  source "ipfw.rules.erb"
  owner "root"
  group "wheel"
  mode 0750
  variables({ :allowed_tcp => allowed_tcp,
              :allowed_udp => allowed_udp,
              :allowed_tcp_inbound => allowed_tcp_inbound
  })
  notifies :run, 'execute[reload_firewall]', :immediately
end

execute 'reload_firewall' do
  #command "sh #{firewall_script}"
  command "echo 'reloaded firewall'"
  action :nothing
end
