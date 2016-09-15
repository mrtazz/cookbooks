package "duo" do
  action :install
end

# get duo integration data from data bag
secret_key_path = "/root/.chef/credentials-bag.key"
secret = Chef::EncryptedDataBagItem.load_secret(secret_key_path)
duo_creds = Chef::EncryptedDataBagItem.load("credentials", "duo", secret)

template "/usr/local/etc/login_duo.conf" do
  source "login_duo.conf.erb"
  owner "sshd"
  group "wheel"
  variables ({
    :ikey => duo_creds["ikey"],
    :skey => duo_creds["skey"],
    :host => duo_creds["host"],
  })
end
