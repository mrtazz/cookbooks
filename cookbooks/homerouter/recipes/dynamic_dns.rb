secret = Chef::EncryptedDataBagItem.load_secret("/root/.chef/credentials-bag.key")
creds = Chef::EncryptedDataBagItem.load("credentials", "dnsimple", secret)

template "/usr/local/bin/dnsimple_update.sh" do
  source "dnsimple_update.sh.erb"
  owner "root"
  group "wheel"
  mode 0700
  variables({ :token  => creds["token"],
              :domain => "unwiredcouch.com",
              :record => creds["record"]
  })
end

# run the update script on a cron
cron "update_external_ip" do
  command "/usr/local/bin/dnsimple_update.sh"
  minute "*/15"
  user "root"
  action :create
end
