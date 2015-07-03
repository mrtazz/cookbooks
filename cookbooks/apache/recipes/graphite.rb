package "ap24-mod_wsgi3"

service "apache24" do
  action :enable
  supports [:restart]
end

template "/usr/local/etc/apache24/Includes/graphite.conf" do
  source "graphite.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables( :hostname => "graphite.unwiredcouch.com",
             :graphite_root => "/usr/local/share/graphite-web",
             :wsgi_path => "/usr/local/etc/graphite",
             :django_root => "/usr/local/lib/python2.7/site-packages/django/"
           )
  notifies :restart, "service[apache24]"
end

template "/usr/local/etc/graphite/local_settings.py" do
  source "local_settings.py.erb"
  owner "root"
  group "wheel"
  mode 0644
end

dashboards_dir = "/usr/local/www/dashboards/"

directory dashboards_dir do
  owner "www"
  group "wheel"
  mode 0775
end

# get a list of all nodes to show on the dashboard
hosts = []
nodes = search(:node, "domain:*unwiredcouch.com")

nodes.each do |computer|

  this_computer = {}

  this_computer[:name] = computer[:fqdn]
  this_computer[:cpus] = computer[:cpu].nil? ? 0 : computer[:cpu][:total]
  this_computer[:apache] = computer.recipes.include?("apache")
  this_computer[:interfaces] = computer.network.interfaces.keys.select {|k| k != "lo0"}
  this_computer[:filesystems] = []
  computer.filesystem.each do |k,v|
    name = v[:mount] == "/" ? "/root" : v[:mount]
    # cut out leading '/'
    name[0] = ''
    # substitute '/' with '-'
    name.gsub!("/", "-")
    # substitute '.' with '_'
    name.gsub!(".", "_")
    # and add to array
    this_computer[:filesystems] << name
  end

  hosts << this_computer

end

template "#{dashboards_dir}/config.php" do
  source "yagd.config.php.erb"
  owner "www"
  group "wheel"
  mode 0775
  variables( :hosts => hosts )
end

template "/usr/local/etc/apache24/Includes/dashboards.conf" do
  source "dashboards.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables( :hostname => "dashboards.unwiredcouch.com",
             :docroot => "#{dashboards_dir}/htdocs"
           )
end
