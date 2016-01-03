cookbook_file "/usr/local/collectd/collectd-cpu-temp.sh" do
  source "collectd-cpu-temp.sh"
  owner "root"
  group "wheel"
  mode 0755
end

# only add dashboard data if the sysctl values exist
if system('sysctl -a dev.cpu | grep -q temperature')
  node.default[:yagd][:additional_metrics][:cpu_temp] = {
    "CPU temperature (celsius)" => "collectd.#{node[:fqdn].gsub(".","_")}.cputemp-*.celsius_current",
  }
end
