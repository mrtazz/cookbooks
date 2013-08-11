davroot = "/usr/home/mrtazz/omnipresence"
secret_key_path = "/root/.chef/credentials-bag.key"
secret = Chef::EncryptedDataBagItem.load_secret(secret_key_path)
creds = Chef::EncryptedDataBagItem.load("credentials", "mrtazz", secret)
op_pass = creds["omnipresence"]

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

template "#{davroot}/passwd.dav" do
  source "passwd.dav.erb"
  owner "www"
  group the_group
  mode 0660
  variables( {:users => [{:name => "mrtazz", :password => op_pass}] })
end

template "/usr/local/etc/apache22/Includes/omnipresence.conf" do
  source "omnipresence.conf.erb"
  owner "www"
  group "www"
  mode 0600
  variables( :davroot => davroot )
end
