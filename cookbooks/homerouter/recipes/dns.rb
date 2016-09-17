secret = Chef::EncryptedDataBagItem.load_secret("/root/.chef/credentials-bag.key")
creds = Chef::EncryptedDataBagItem.load("credentials", "dns", secret)

package "bind910" do
  action :install
end

service "named" do
  action [:enable, :start]
  supports [:restart]
end

# create directory for stats file
directory "/usr/local/var/named" do
  action :create
  owner "bind"
  group "bind"
  mode 0755
end

template "/usr/local/etc/namedb/rndc.key" do
  source "rndc.key.erb"
  owner "root"
  group "wheel"
  mode 0600
  variables({ :key => creds["key"] })
  notifies :restart, "service[named]"
end

template "/usr/local/etc/namedb/named.conf" do
  source "named.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables({ :key => creds["key"] })
  notifies :restart, "service[named]"
end

template "/usr/local/etc/namedb/dynamic/3.168.192.in-addr.arpa" do
  action :create_if_missing
  source "zone.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables({ :zone => {
                :is_reverse => true,
                :domain => "3.168.192.in-addr.arpa",
                :ns => "ns1.nyc.unwiredcouch.com",
                :ns_ip  => node[:ipaddress],
                :records => [
                  { :name => node[:ipaddress].split(".")[3],
                    :type => "PTR",
                    :lookup => "#{node[:fqdn]}." }
                ]
            }
  })
  notifies :restart, "service[named]"
end

template "/usr/local/etc/namedb/dynamic/33.168.192.in-addr.arpa" do
  action :create_if_missing
  source "zone.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables({ :zone => {
                :is_reverse => true,
                :domain => "33.168.192.in-addr.arpa",
                :ns => "ns1.nyc.unwiredcouch.com",
                :ns_ip  => node[:ipaddress],
                :records => [
                  { :name => node[:ipaddress].split(".")[3],
                    :type => "PTR",
                    :lookup => "#{node[:fqdn]}." }
                ]
            }
  })
  notifies :restart, "service[named]"
end

template "/usr/local/etc/namedb/dynamic/nyc.unwiredcouch.com" do
  action :create_if_missing
  source "zone.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables({ :zone => {
                :domain => "nyc.unwiredcouch.com",
                :ns => "ns1.nyc.unwiredcouch.com",
                :ns_ip  => node[:ipaddress],
                :records => [
                  { :name => node[:fqdn].split(".")[0],
                    :type => "A",
                    :lookup => node[:ipaddress] }
                ]
            }
  })
  notifies :restart, "service[named]"
end


node.default[:yagd][:additional_metrics][:bind] = {
  "_default cache rr sets" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-_default-cache_rr_sets.*,'.*dns_qtype_cached-','')",
  "_default query types" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-_default-qtypes.*,'.*dns_qtype-','')",
  "_default resolver stats (query)" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-_default-resolver_stats.dns_query*,'.*dns_query-','')",
  "_default resolver stats (rcode)" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-_default-resolver_stats.dns_rcode*,'.*dns_rcode-','')",
  "_default resolver stats (resolver)" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-_default-resolver_stats.dns_resolver*,'.*dns_resolver-','')",
  "_default resolver stats (response)" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-_default-resolver_stats.dns_response*,'.*dns_response-','')",
  "memory" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-global-memory_stats.*,'.*memory-','')",
  "opcodes" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-global-opcodes.*,'.*dns_opcode-','')",
  "global query types" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-global-qtypes.*,'.*dns_qtype-','')",
  "global server stats (query)" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-global-server_stats.dns_query*,'.*dns_query-','')",
  "global server stats (rcode)" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-global-server_stats.dns_rcode*,'.*dns_rcode-','')",
  "global server stats (request)" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-global-server_stats.dns_request*,'.*dns_request-','')",
  "global server stats (response)" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-global-server_stats.dns_response*,'.*dns_response-','')",
  "global server stats (reject)" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-global-server_stats.dns_reject*,'.*dns_reject-','')",
  "global zone maint stats (notify)" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-global-zone_maint_stats.dns_notify*,'.*dns_notify-','')",
  "global zone maint stats (opcode)" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-global-zone_maint_stats.dns_opcode*,'.*dns_opcode-','')",
  "global zone maint stats (transfer)" => "aliasSub(collectd.#{node[:fqdn].gsub(".","_")}.bind-global-zone_maint_stats.dns_transfer*,'.*dns_transfer-','')",
}
