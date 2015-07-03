docroot = "/usr/local/www/unwiredcouch/"
domain_aliases = [
  "www.unwiredcouch.com",
]

directory docroot do
  owner "www"
  group "mrtazz"
  mode 0775
end

template "/usr/local/etc/apache24/Includes/unwiredcouch.com.conf" do
  source "unwiredcouch.com.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables( :docroot => docroot,
             :hostname => "unwiredcouch.com",
             :aliases => domain_aliases )
end
