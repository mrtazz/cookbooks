if node[:platform] == "freebsd"
  homedir = "/home/mrtazz"
  mrtazz_group = "mrtazz"
  secret_key_path = "/root/.chef/credentials-bag.key"
elsif node[:platform] == "mac_os_x"
  homedir = "/Users/mrtazz"
  mrtazz_group = "staff"
  secret_key_path = "#{homedir}/.chef/credentials-bag.key"
end

# dotfiles
script "install_dotfiles" do
  interpreter "sh"
  user "mrtazz"
  cwd homedir
  code <<-EOH
  git clone https://github.com/mrtazz/dotfiles.git
  cd dotfiles
  make install
  EOH
  not_if { File.exists? "#{homedir}/dotfiles" }
end

script "install_bin" do
  interpreter "sh"
  user "mrtazz"
  cwd homedir
  code <<-EOH
  git clone https://github.com/mrtazz/bin.git
  EOH
  not_if { File.exists? "#{homedir}/bin" }
end

# vimfiles
script "install_vimfiles" do
  interpreter "sh"
  user "mrtazz"
  cwd homedir
  code <<-EOH
  git clone https://github.com/mrtazz/vimfiles.git .vim
  EOH
  not_if { File.exists? "#{homedir}/.vim" }
end

link "#{homedir}/.vimrc" do
    to "#{homedir}/.vim/vimrc"
end

# muttfiles
script "install_muttfiles" do
  interpreter "sh"
  user "mrtazz"
  cwd homedir
  code <<-EOH
  git clone https://github.com/mrtazz/muttfiles.git .mutt
  EOH
  not_if { File.exists? "#{homedir}/.mutt" }
end
link "#{homedir}/.muttrc" do
    to "#{homedir}/.mutt/basic-settings"
end

# authorized keys
directory "#{homedir}/.ssh" do
  action :create
  owner "mrtazz"
  group mrtazz_group
  mode "0755"
end

secret = Chef::EncryptedDataBagItem.load_secret(secret_key_path)
creds = Chef::EncryptedDataBagItem.load("credentials", "mrtazz", secret)
keys = creds["authorized_keys"]

template "#{homedir}/.ssh/authorized_keys" do
  source "mrtazz/authorized_keys.erb"
  owner "mrtazz"
  group mrtazz_group
  mode "0644"
  variables( :keys => keys )
end

script "install zshfiles from github" do
  interpreter "sh"
  user "mrtazz"
  cwd homedir
  code <<-EOS
  git clone git://github.com/mrtazz/zshfiles.git .zsh
  cd .zsh
  make install
  EOS
  not_if { File.directory? "#{homedir}/.zsh" }
end

directory "#{homedir}/bin" do
  action :create
  owner "mrtazz"
  group mrtazz_group
  mode "0755"
end

script "hub install from github" do
  interpreter "sh"
  user "mrtazz"
  cwd homedir
  code <<-EOS
    curl http://defunkt.io/hub/standalone -sLo bin/hub
    chmod +x bin/hub
  EOS
  not_if { File.exists? "#{homedir}/bin/hub" }
end


bitlbee_password = creds["bitlbee"]["password"]

# procmail Maildir setup
directory "#{homedir}/Mails" do
  action :create
  owner "mrtazz"
  group mrtazz_group
  mode "0700"
end

mrtazz_data_bag = data_bag_item('users', 'mrtazz')
spams = mrtazz_data_bag["spamaddresses"]
maillists = mrtazz_data_bag["maillists"]

template "#{homedir}/.procmailrc" do
  source "mrtazz/procmailrc.erb"
  owner "mrtazz"
  group mrtazz_group
  mode "0600"
  variables({ :spams => spams, :maillists => maillists })
end

template "#{homedir}/.forward" do
  source "mrtazz/forward.erb"
  owner "mrtazz"
  group mrtazz_group
  mode "0600"
  only_if { File.exists? "/usr/local/bin/procmail" }
end

if (File.exists?("/usr/local/bin/fetchmail") && (node[:mrtazz][:run_fetchmail] == true))

  fetchmailaccounts = creds["fetchmail"]

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

if (node.role? "ircbouncer")
  include_recipe "znc"

  # znc stuff
  directory "#{homedir}/.znc" do
    action :create
    owner "mrtazz"
    group mrtazz_group
    mode "0700"
  end

  # modules dir
  directory "#{homedir}/.znc/modules" do
    action :create
    owner "mrtazz"
    group mrtazz_group
    mode "0700"
  end

  directory "#{homedir}/.znc/configs" do
    action :create
    owner "mrtazz"
    group mrtazz_group
    mode "0700"
  end

  mrtazz = creds["znc"]["mrtazz"]
  mrtazz_im = creds["znc"]["mrtazz_im"]
  mrtazz_grove = creds["znc"]["mrtazz_grove"]
  mrtazz_ircnet = creds["znc"]["mrtazz_ircnet"]

  template "#{homedir}/.znc/configs/znc.conf" do
    source "mrtazz/znc.conf.erb"
    owner "mrtazz"
    group mrtazz_group
    mode "0700"
    variables( :homedir => homedir, :mrtazz_password => mrtazz,
              :mrtazz_im_password => mrtazz_im,
              :mrtazz_grove_password => mrtazz_grove,
              :mrtazz_ircnet_password => mrtazz_ircnet,
              :bitlbee_password => bitlbee_password
            )
    not_if { File.exist? "#{homedir}/.znc/configs/znc.conf" }

  end

  modules = ["away", "bouncedcc", "keepnick", "log", "nickserv", "push"]

  creds["znc"].each do |z|
    modules.each do |m|
      directory "#{homedir}/.znc/users/#{z[0]}/#{m}" do
        action :create
        owner "mrtazz"
        group mrtazz_group
        mode "0700"
        recursive true
      end
    end
  end

  script "install znc push module" do
    interpreter "sh"
    user "mrtazz"
    cwd "#{homedir}/.znc/modules"
    code <<-EOS
    curl https://raw.github.com/jreese/znc-push/master/push.cpp -sLO
    /usr/local/bin/znc-buildmod push.cpp
    EOS
    creates "#{homedir}/.znc/modules/push.so"
  end

  script "generate znc ssl cert" do
    interpreter "sh"
    cwd "#{homedir}/.znc"
    code <<-EOH
    umask 077
    openssl genrsa 2048 > znc.key
    openssl req -subj /C=US/ST=Several/L=Locality/O=Example/OU=Operations/CN=#{node[:fqdn]}/emailAddress=root@#{node['fqdn']} \
  -new -x509 -nodes -sha1 -days 3650 -key znc.key > znc.crt
    cat znc.key znc.crt > znc.pem
    EOH
    user "mrtazz"
    group mrtazz_group
    creates "#{homedir}/.znc/znc.pem"
  end

  cron "restart znc" do
    user "mrtazz"
    hour "*"
    minute "*/10"
    command "/usr/local/bin/znc >/dev/null 2>&1"
  end

end
