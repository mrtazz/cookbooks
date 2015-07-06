unless node[:is_virtual]

  cookbook_file "/usr/local/collectd/collectd-disk-temp.sh" do
    source "collectd-disk-temp.sh"
    owner "root"
    group "wheel"
    mode 0755
  end

  node.default[:yagd][:additional_metrics][:disk_temperature] = {
    "Disk Temperature" => "collectd.#{node[:fqdn].gsub(".","_")}.disktemp-ada*.current"
  }

end
