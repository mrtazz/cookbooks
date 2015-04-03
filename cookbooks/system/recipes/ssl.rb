require 'base64'

secret_key_path = "/root/.chef/credentials-bag.key"
secret = Chef::EncryptedDataBagItem.load_secret(secret_key_path)
creds = Chef::EncryptedDataBagItem.load("credentials", "serversecrets", secret)
the_cert = creds["sslcert"]
the_key = creds["sslkey"]
wildcard_cert = creds["wildcardcert"]
wildcard_key = creds["wildcardkey"]
intermediate_cert = creds["intermediatecert"]

ssl_group = "ssl_services"
ssl_dir = "/usr/local/ssl"

group_members = []

if node.roles.include? "irc"
  group_members << "ircd"
end

group ssl_group do
  action :create
  members group_members
end

directory ssl_dir do
  action :create
  owner "root"
  group ssl_group
  mode 0550
end

template "#{ssl_dir}/ssl.cert" do
  source "ssl.cert.erb"
  owner "root"
  group ssl_group
  mode 0400
  variables( :the_cert => Base64.encode64(Base64.decode64(the_cert)) )
end

template "#{ssl_dir}/ssl.key" do
  source "ssl.key.erb"
  owner "root"
  group ssl_group
  mode 0400
  variables( :the_key => Base64.encode64(Base64.decode64(the_key)) )
end

template "#{ssl_dir}/star.unwiredcouch.com.cert" do
  source "ssl.cert.erb"
  owner "root"
  group ssl_group
  mode 0400
  variables( :the_cert => Base64.encode64(Base64.decode64(wildcard_cert)))
end

template "#{ssl_dir}/intermediate.cert" do
  source "ssl.cert.erb"
  owner "root"
  group ssl_group
  mode 0400
  variables( :the_cert => Base64.encode64(Base64.decode64(intermediate_cert)))
end

template "#{ssl_dir}/star.unwiredcouch.com.key" do
  source "ssl.key.erb"
  owner "root"
  group ssl_group
  mode 0400
  variables( :the_key => Base64.encode64(Base64.decode64(wildcard_key)) )
end

package "ca_root_nss" do
  action :install
end

# TODO: install ca root bundle containing the intermediate
# TODO: install crl
# TODO: cron update of crl


