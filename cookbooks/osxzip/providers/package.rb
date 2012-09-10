#
# Cookbook Name:: osx_zip
# Resource:: package
#
# Copyright 2011, Daniel Schauenberg
#

def load_current_resource
  @zippkg = Chef::Resource::OsxzipPackage.new(new_resource.name)
  @zippkg.app(new_resource.app)
  @zippkg.source(new_resource.source)
  @zippkg.checksum(new_resource.checksum)
  @zippkg.destination(new_resource.destination)
  Chef::Log.debug("Checking for application #{@zippkg.app}")
  installed = ::File.directory?("#{@zippkg.destination}/#{@zippkg.app}.app")
  @zippkg.installed(installed)
end

action :install do

  unless @zippkg.installed

    remote_file "#{Chef::Config[:file_cache_path]}/#{new_resource.app}.zip" do
      source new_resource.source
      checksum new_resource.checksum
    end

    execute "unzip #{new_resource.app}.zip" do
      command "unzip #{Chef::Config[:file_cache_path]}/#{new_resource.app}.zip"
      cwd new_resource.destination
      not_if new_resource.installed
    end

    file "#{new_resource.destination}/#{new_resource.app}.app/Contents/MacOS/#{new_resource.app}" do
      mode 0755
      ignore_failure true
    end

    directory "#{new_resource.destination}/__MACOSX" do
      recursive true
      action :delete
      ignore_failure true
    end

  end
end
