require 'base64'

secret_key_path = "/root/.chef/credentials-bag.key"
secret = Chef::EncryptedDataBagItem.load_secret(secret_key_path)
creds = Chef::EncryptedDataBagItem.load("credentials", "serversecrets", secret)
the_cert = creds["sslcert"]
the_key = creds["sslkey"]

template "/usr/local/etc/apache22/ssl.cert" do
  source "ssl.cert.erb"
  owner "www"
  group "www"
  mode 0600
  variables( :the_cert => Base64.encode64(Base64.decode64(the_cert)) )
end

template "/usr/local/etc/apache22/ssl.key" do
  source "ssl.key.erb"
  owner "www"
  group "www"
  mode 0600
  variables( :the_key => Base64.encode64(Base64.decode64(the_key)) )
end

template "/usr/local/etc/apache22/httpd.conf" do
  source "httpd.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
end

template "/usr/local/etc/apache22/extra/httpd-ssl.conf" do
  source "httpd-ssl.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
end

service "apache22" do
  supports [:restart]
end
