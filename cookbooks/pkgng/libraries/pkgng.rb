require 'chef/mixin/shell_out'
require 'chef/platform'
require 'chef'

include Chef::Mixin::ShellOut

class Chef
  class Provider
    class Package
      class Pkgng < Chef::Provider::Package

        def initialize(*args)
          super
          @current_resource = Chef::Resource::Package.new(@new_resource.name)
          @current_resource.package_name(@new_resource.package_name)
          @current_resource
        end

        def check_package_state
          pkg_info = shell_out!("pkg info #{package_name}", :env => nil, :returns => [0,70])

          version = nil
          t = pkg_info.stdout.match(/(.*)-(\d+\.\d+\.\d+(\.\d+.*\s)?)\s+(.*)/)
          unless t.nil?
            version = t[2].strip
          end

          return version
        end

        def load_current_resource
           @current_resource.package_name(@new_resource.package_name)
           @current_resource.version(self.check_package_state())
           @candidate_version = ""
        end

        def package_name
          @new_resource.package_name
        end

        def install_package(name, version = "")
          shell_out!("pkg install -y #{package_name}", :env => nil).status
          Chef::Log.debug("PKGNG : #{@new_resource} installed from: #{@new_resource.source}")
        end

        def remove_package(name, version = nil)
            shell_out!("pkg delete -y #{package_name}", :env => nil).status
        end
      end
    end
  end
end
