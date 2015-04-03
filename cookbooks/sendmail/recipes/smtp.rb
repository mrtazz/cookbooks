# configure sendmail for SMTP with SSL and auth

# saslauthd is gonna take care of brokering between sendmail and passwd
package "cyrus-sasl-saslauthd" do
  action :install
end

template "/usr/local/lib/sasl2/Sendmail.conf" do
  source "Sendmail.conf"
  owner "root"
  group "wheel"
  mode 0644
end

service "saslauthd" do
  action [:enable, :start]
end


# set compile parameters in make.conf
template "/etc/make.conf" do
  source "make.conf.erb"
  owner "root"
  group "wheel"
  mode 0600
end

# this needs a manual step, yea...
#
# cd /usr/src/lib/libsmutil
# make cleandir && make obj && make
# cd /usr/src/lib/libsm
# make cleandir && make obj && make
# cd /usr/src/usr.sbin/sendmail
# make cleandir && make obj && make && make install
#

# tell the sendmail config to use sasl and also listen on port 25 and 465,
# this needs the system:ssl recipe to work
template "/etc/mail/#{node[:fqdn]}.mc" do
  source "sendmail.mc.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables ( { :ssmtp => true,
                :ssl_dir => "/usr/local/ssl"  ,
                :ssl_cert => "star.unwiredcouch.com.cert",
                :ssl_key => "star.unwiredcouch.com.key"
  } )
end
