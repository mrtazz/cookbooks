#
# Cookbook Name:: ruby
# Recipe:: default
#

RVM_INSTALL_ROOT     = "#{ENV['HOME']}/.rvm"
DEFAULT_RUBY_VERSION = "1.9.2"

wk = data_bag_item(:apps,"workstation")

template "#{ENV['HOME']}/.rvmrc" do
  mode   0700
  owner  ENV['USER']
  group  Etc.getgrgid(Process.gid).name
  source "dot.rvmrc.erb"
  variables({ :home => ENV['HOME'] })
end

script "installing rvm to ~/" do
  interpreter "bash"
  code <<-EOS
    bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
  EOS
  not_if { File.directory? "#{ENV['HOME']}/.rvm" }
end

file "#{ENV['HOME']}/.profile" do
  action :create
  not_if { File.exist? "#{ENV['HOME']}/.profile" }
end

script "update .profile file" do
  interpreter "bash"
  code <<-EOS
    echo '[[ -s "#{ENV['HOME']}/.rvm/scripts/rvm" ]] && . "#{ENV['HOME']}/.rvm/scripts/rvm"' >> ~/.profile
  EOS
  not_if "grep rvm #{ENV['HOME']}/.profile"
end

script "updating rvm to the latest stable version" do
  interpreter "bash"
  code <<-EOS
    source #{ENV['HOME']}/.profile
    rvm update --head
  EOS
end

script "installing ruby" do
  interpreter "bash"
  code <<-EOS
    source #{ENV['HOME']}/.profile
    `rvm list | grep -q '#{DEFAULT_RUBY_VERSION}'`
    if [ $? -ne 0 ]; then
      CC=/usr/bin/gcc-4.2
      rvm install #{DEFAULT_RUBY_VERSION}
    fi
  EOS
end

script "ensuring a default ruby is set" do
  interpreter "bash"
  code <<-EOS
    source #{ENV['HOME']}/.profile
    `which ruby | grep -q rvm`
    if [ $? -ne 0 ]; then
      rvm use #{DEFAULT_RUBY_VERSION} --default
    fi
  EOS
end

directory "#{ENV['HOME']}/.rvm/gemsets" do
  action 'create'
end

template "#{ENV['HOME']}/.rvm/gemsets/default.gems" do
  source "default.gems.erb"
  variables({:gems => wk['gems']['defaults']})
end

script "ensuring default rubygems are installed" do
  interpreter "bash"
  code <<-EOS
    source #{ENV['HOME']}/.profile
    rvm gemset load ~/.rvm/gemsets/default.gems
  EOS
end

execute "cleanup rvm build artifacts" do
  command "find ~/.rvm/src -depth 1 | grep -v src/rvm | xargs rm -rf "
end

template "#{ENV['HOME']}/.gemrc" do
  source "dot.gemrc.erb"
end

template "#{ENV['HOME']}/.rdebugrc" do
    source "dot.rdebugrc.erb"
end
