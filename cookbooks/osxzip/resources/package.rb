#
# Cookbook Name:: osx_zip
# Resource:: package
#
# Copyright 2011, Daniel Schauenberg


actions :install

attribute :app, :kind_of => String, :name_attribute => true
attribute :source, :kind_of => String, :default => nil
attribute :destination, :kind_of => String, :default => "/Applications"
attribute :checksum, :kind_of => String, :default => nil
attribute :installed, :kind_of => [TrueClass, FalseClass], :default => false

def initialize(name, run_context=nil)
  super
  @action = :install
end
