require 'base64'

service "apache24" do
  supports [:restart]
end

template "/usr/local/etc/apache24/extra/httpd-ssl.conf" do
  source "apache24/httpd-ssl.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
end
