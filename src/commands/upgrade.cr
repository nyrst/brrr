require "semantic_version"
require "../lib/common"

module Brrr
  module Commands
    class Upgrade
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        @registry = Api.new nil

        if args.size == 0
          # FIXME this is dirty and I feel bad.
          args = @config.installed.keys
        end

        args.each do |package_name|
          upgrade package_name
          puts ""
        end
      end

      protected def can_upgrade(latest_version : String, installed_version : String)
        begin
          (SemanticVersion.parse(latest_version) <=> SemanticVersion.parse(installed_version)) == 1
        rescue
          latest_version > installed_version
        end
      end

      protected def upgrade(package_name : String)
        # Let's get this package
        yaml = Common.get_yaml(@registry, package_name)

        # Now, time to read the package and get some info
        package = Package.from_yaml(yaml)
        name = package.name
        latest_version = package.latest_version
        cache_package_dir = @cache.path / name

        # Get installed version from configuration
        # arch = @config.arch
        installed_version = @config.installed[name]

        # If latest version > current version
        if can_upgrade(latest_version, installed_version)
          puts "Update #{name}: v#{installed_version} => #{latest_version}"
          # Clean package
          Commands::Uninstall.new(@config, @cache, [name])

          # TODO calling this directly will download again the yaml file. It's okay for now.
          # Save new version
          Commands::Install.new(@config, @cache, [name])
        else
          puts "#{name} v#{installed_version} is up to date."
        end
      end
    end
  end
end
