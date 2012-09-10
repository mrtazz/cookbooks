#
# Cookbook Name:: ruby
# Recipe:: irbrc
#

template "#{ENV['HOME']}/.irbrc" do
  source "dot.irbrc.erb"
end
