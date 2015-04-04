if node[:platform] == "freebsd"
  homedir = "/home/mrtazz"
  mrtazz_group = "mrtazz"
  secret_key_path = "/root/.chef/credentials-bag.key"
elsif node[:platform] == "mac_os_x"
  homedir = "/Users/mrtazz"
  mrtazz_group = "staff"
  secret_key_path = "#{homedir}/.chef/credentials-bag.key"
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

template "#{homedir}/.forward" do
  source "mrtazz/forward.erb"
  owner "mrtazz"
  group mrtazz_group
  mode "0600"
end

if (node.role? "ircbouncer")
  bitlbee_password = creds["bitlbee"]["password"]

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

  modules = ["away", "bouncedcc", "keepnick", "log", "nickserv", "push", "palaver"]

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

  script "install znc palaver module" do
    interpreter "sh"
    user "mrtazz"
    cwd "#{homedir}/.znc/modules"
    code <<-EOS
    curl https://raw.github.com/Palaver/znc-palaver/master/palaver.cpp -sLO
    /usr/local/bin/znc-buildmod palaver.cpp
    EOS
    creates "#{homedir}/.znc/modules/palaver.so"
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
