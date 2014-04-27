package "ap22-mod_wsgi3"

template "/usr/local/etc/apache22/Includes/graphite.conf" do
  source "graphite.conf.erb"
  owner "root"
  group "wheel"
  mode 0644
  variables( :hostname => "graphite.unwiredcouch.com",
             :graphite_root => "/usr/local/share/graphite-web",
             :wsgi_path => "/usr/local/etc/graphite",
             :django_root => "/usr/local/lib/python2.7/site-packages/django/"
           )
  notifies :restart, "service[apache22]"
end
