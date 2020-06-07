require "../lib/common"
require "../lib/errors"

module Brrr
  module Commands
    class Outdated
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        @registry = Api.new nil

        # List installed packages
        @config.installed.each do |package_name, package_installation|
          outdated(package_name, package_installation)
        end
      end

      protected def outdated(name : String, version : String)
        yaml_installation = <<-YAML
          url: #{name}
          version: #{version}
        YAML
        installation = Installation.from_yaml yaml_installation

        outdated(name, installation)
      end

      protected def outdated(package_name : String, package_installation : Installation)
        package_url = package_installation.url
        current_version = package_installation.version

        # Let's get this package
        yaml = Common.get_yaml(@registry, package_url)

        if yaml.nil?
          PackageNotFound.log(package_name, @registry.registry)
          exit 0
        else
          # Now, time to read the package and get some info
          package = Package.from_yaml(yaml)

          latest = package.latest_version
          all_versions = package.versions.keys
          next_versions = all_versions.select { |v| Common.can_upgrade(v, current_version) }

          next_text = if next_versions.size > 0
                        "Available version(s): #{next_versions.join(", ")}"
                      else
                        "You already have the latest version."
                      end

          puts "#{package_name} (#{current_version}). #{next_text}"
        end
      end
    end
  end
end
