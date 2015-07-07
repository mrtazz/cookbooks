cookbook_file "/usr/local/collectd/collectd-mailstats.sh" do
  source "collectd-mailstats.sh"
  owner "root"
  group "wheel"
  mode 0755
end

node.default[:yagd][:additional_metrics][:mailstats] = {
  "messages received" => "collectd.#{node[:fqdn].gsub(".","_")}.mailstats-*.messages.rx",
  "messages sent" => "collectd.#{node[:fqdn].gsub(".","_")}.mailstats-*.messages.tx",
  "bytes received" => "collectd.#{node[:fqdn].gsub(".","_")}.mailstats-*.bytes.rx",
  "bytes sent" => "collectd.#{node[:fqdn].gsub(".","_")}.mailstats-*.bytes.tx"
}
