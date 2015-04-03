homedir = "/home/mrtazz"
mrtazz_group = "mrtazz"
secret_key_path = "/root/.chef/credentials-bag.key"

secret = Chef::EncryptedDataBagItem.load_secret(secret_key_path)
creds = Chef::EncryptedDataBagItem.load("credentials", "mrtazz", secret)
fetchmailaccounts = creds["fetchmail"]

node_data = node[:mrtazz] || {}

if node_data[:run_fetchmail] == true

  template "#{homedir}/.fetchmailrc" do
    source "mrtazz/fetchmailrc.erb"
    owner "mrtazz"
    group mrtazz_group
    mode "0600"
    variables( :accounts => fetchmailaccounts )
  end

  cron "user fetchmail" do
    user "mrtazz"
    hour "*"
    minute "*/5"
    command "/usr/local/bin/fetchmail -as >/dev/null 2>&1"
  end

end
