#
# Cookbook Name:: python
# Recipe:: default
#
# Copyright 2011, Daniel Schauenberg
#
# MIT
#
package 'python'

script "install pip" do
  interpreter 'bash'
  code <<-EOS
  /usr/local/share/python/easy_install install pip
  EOS
  not_if { File.exist? "/usr/local/share/python/pip" }
end

script "install virtualenvwrapper" do
  interpreter 'bash'
  code <<-EOS
  /usr/local/share/python/pip install virtualenvwrapper
  EOS
  not_if { File.exist? "/usr/local/share/python/virtualenvwrapper.sh" }
end

file "#{ENV['HOME']}/.profile" do
  action :create
  not_if { File.exist? "#{ENV['HOME']}/.profile" }
end

script "setup virtualenvwrapper config" do
  interpreter "bash"
  code <<-EOS
    echo 'source /usr/local/share/python/virtualenvwrapper.sh' >> ~/.profile
  EOS
  not_if "grep virtualenvwrapper #{ENV['HOME']}/.profile"
end

script "setup WORKON env var in zsh config" do
  interpreter "bash"
  code <<-EOS
    echo 'export WORKON=\'~/.virtualenv\'' >> ~/.zshrc
  EOS
  not_if "grep virtualenvwrapper #{ENV['HOME']}/.profile"
end
