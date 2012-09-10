mail_domains = node[:mail_domains] || []

domains = []

mail_domains.each do |d|
  domains << d[0]
end


template "/etc/mail/local-host-names" do
  source "local-host-names.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables ({:domains => domains})
  notifies :run, "script[update mail information]", :immediately
  notifies :restart, "service[sendmail]"
end

template "/etc/mail/virtusertable" do
  source "virtusertable.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables ({:domains => mail_domains})
  notifies :run, "script[update mail information]", :immediately
  notifies :restart, "service[sendmail]"
end

script "update mail information" do
  interpreter "sh"
  user "root"
  cwd "/etc/mail"
  code <<-EOH
  make install restart
  EOH
  action :nothing
end

service "sendmail" do
  supports [:start, :stop, :restart]
  action :enable
end
