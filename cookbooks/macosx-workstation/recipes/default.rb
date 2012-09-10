wk = data_bag_item(:apps,"workstation")

%w{ bin }.each do |dir|
  directory "#{ENV['HOME']}/#{dir}" do
    action :create
    not_if { File.directory? "#{ENV['HOME']}/bin"}
  end
end

case node['platform']
when "mac_os_x"

  directory "#{ENV['HOME']}/Applications"

  wk['dmgs'].each do |pkg, data|
    dmg_package pkg do
      volumes_dir data['volumes_dir'] if data.has_key?('volumes_dir')
      type data['type'] if data.has_key?('type')
      app data['app'] if data.has_key?('app')
      dmg_name data['dmg_name'] if data.has_key?('dmg_name')
      destination data['destination'] if data.has_key?('destination')
      source data['url']
      checksum data['checksum']
    end
  end

  wk['brews'].each do |brew|
    package brew
  end

  wk['zip-apps'].each do |pkg, data|
    puts data
    osxzip_package pkg do
      volumes_dir data['volumes_dir'] if data.has_key?('volumes_dir')
      dmg_name data['dmg_name'] if data.has_key?('dmg_name')
      destination data['destination'] if data.has_key?('destination')
      source data['source']
      checksum data['checksum']
    end
  end

end

link "#{ENV['HOME']}/Projects" do
  to "#{ENV['HOME']}/Dropbox/Projects"
end

script "add hub as a git alias" do
  interpreter "bash"
  code "echo alias git=hub >> #{ENV['HOME']}/.zshrc"
  not_if "grep hub #{ENV['HOME']}/.zshrc"
end

template "#{ENV['HOME']}/.tmux.conf" do
    mode   0700
    owner  ENV['USER']
    group  Etc.getgrgid(Process.gid).name
    source "dot.tmux.conf"
    variables({ :home => ENV['HOME'] })
    not_if { File.exist? "#{ENV['HOME']}/.tmux.conf" }
end

