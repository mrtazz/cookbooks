homedir = "/home/mrtazz"
mrtazz_group = "mrtazz"

mrtazz_data_bag = data_bag_item('users', 'mrtazz')
spams = mrtazz_data_bag["spamaddresses"]
maillists = mrtazz_data_bag["maillists"]

procmail_files = [
  { :source => "mrtazz/procmailrc.erb",
    :target => "#{homedir}/.procmailrc" },
  { :source => "mrtazz/procmail-spam.rc.erb",
    :target => "#{homedir}/.procmail/spam.rc" },
  { :source => "mrtazz/procmail-maillists.rc.erb",
    :target => "#{homedir}/.procmail/maillists.rc" },
]

# procmail Maildir setup
directory "#{homedir}/Mails" do
  action :create
  owner "mrtazz"
  group mrtazz_group
  mode "0700"
end

directory "#{homedir}/.procmail" do
  owner 'mrtazz'
  group mrtazz_group
  mode '0700'
  action :create
end

procmail_files.each do |procfile|

  template procfile[:target] do
    source procfile[:source]
    owner "mrtazz"
    group mrtazz_group
    mode "0600"
    variables({ :spams => spams, :maillists => maillists })
  end

end

file "#{homedir}/.procmail/custom.rc" do
  owner 'mrtazz'
  group mrtazz_group
  mode '0600'
  action :create_if_missing
end

template "#{homedir}/.forward" do
  source "mrtazz/forward.erb"
  owner "mrtazz"
  group mrtazz_group
  mode "0600"
end
