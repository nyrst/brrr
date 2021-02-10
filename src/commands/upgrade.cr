require "../lib/common"
require "../lib/errors"
require "../structs/package"

module Brrr
  module Commands
    class Upgrade
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        @repository = Repository.new @config.repository

        package_to_update = if args.size == 0
                              @config.installed.keys.sort
                            else
                              args
                            end

        package_to_update.each do |package_name|
          if @config.installed.has_key? package_name
            upgrade(package_name, @config.installed[package_name])
          else
            puts "Package #{package_name} not found."
            puts ""
          end
        end
      end

      protected def upgrade(package_name : String, package_installation : Installation)
        package_url = if package_installation.url == ""
                        package_name
                      else
                        package_installation.url
                      end
        current_version = package_installation.version

        # Let's get this package
        yaml = Common.get_yaml(@repository, package_url)

        if yaml.nil?
          PackageNotFound.log(package_name, package_url)
          exit 0
        end

        # Now, time to read the package and get some info
        body = yaml.body

        if body.nil?
          Logger.log "Failed to get content for #{package_name}"
          return
        end

        package = Package.from_yaml(body)
        package_name = package.name
        latest_version = package.latest_version
        cache_package_dir = @cache.path / package_name

        # If latest version > current version
        if Common.can_upgrade(latest_version, current_version)
          Logger.start "Update #{package_name}: v#{current_version} => #{latest_version}"
          # Clean package
          Commands::Uninstall.new(@config, @cache, [package_name])

          # TODO calling this directly will download again the yaml file. It's okay for now.
          # Save new version
          Commands::Install.new(@config, @cache, [package_name])
        else
          Logger.log "#{package_name} v#{current_version} is up to date."
        end
      end
    end
  end
end
