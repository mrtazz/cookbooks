template "/root/.forward" do
  source "forward.erb"
  owner "root"
  group "wheel"
  mode 0400
  variables( :mailaddresses => ['d@unwiredcouch.com'] )
end
