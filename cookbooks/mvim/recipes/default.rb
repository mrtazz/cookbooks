#
# Cookbook Name:: atmos.vim
# Recipe:: default
#

script "installing http://github.com/mrtazz/vimfiles" do
  interpreter "bash"
  code <<-EOS
    source #{ENV['HOME']}/.profile
    git clone git://github.com/mrtazz/vimfiles.git #{ENV['HOME']}/.vim
    cd #{ENV['HOME']}/.vim
    git submodule update --init
    git remote rm origin
    git remote add origin git@github.com:mrtazz/vimfiles.git
  EOS
  not_if { File.directory? "#{ENV['HOME']}/.vim"}
end

directory "#{ENV['HOME']}/bin" do
  action :create
  not_if { File.directory? "#{ENV['HOME']}/bin"}
end

script "installing macvim from github" do
  interpreter "bash"
  code <<-EOS
    source #{ENV['HOME']}/.profile
    rm -rf /Applications/MacVim.app
    cd #{Chef::Config[:file_cache_path]}
    curl -sfL https://github.com/downloads/b4winckler/macvim/MacVim-snapshot-61.tbz -o - | tar xj -
    cd MacVim-snapshot-61
    cp mvim ~/bin
    cp -r MacVim.app /Applications/
  EOS
  not_if { File.exist? "#{ENV['HOME']}/bin/mvim"}
end

link "#{ENV['HOME']}/.vimrc" do
  to "#{ENV['HOME']}/.vim/vimrc"
end
