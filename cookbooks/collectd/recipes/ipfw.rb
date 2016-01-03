cookbook_file "/usr/local/collectd/collectd-ipfw.sh" do
  source "collectd-ipfw.sh"
  owner "root"
  group "wheel"
  mode 0755
end

node.default[:yagd][:additional_metrics][:IPFW] = {
  "dynamic rules" => "collectd.#{node[:fqdn].gsub(".","_")}.ipfw.dynamic_rules"
}
