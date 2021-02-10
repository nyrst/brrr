require "../structs/package"

module Brrr
  module Commands
    class Uninstall
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        if args.size == 0
          Logger.log "Nothing to do."
        end

        args.each do |name|
          uninstall name
          puts ""
        end
      end

      def uninstall(name : String)
        # Read installed version

        if !@config.installed.has_key? name
          Logger.log "#{name} is not installed."
          exit 0
        end

        run(name, @config.installed[name])
      end

      protected def run(package_name : String, installation : Installation)
        installed_version = installation.version

        Logger.start "Removing #{package_name} v#{installed_version}"

        # Read cache yaml
        package = @cache.read_yaml package_name

        if package.nil?
          Logger.log "Local package definition for #{package_name} not found! Is it really installed?"
        else
          if !package.versions.has_key? installed_version
            Logger.log "Version #{installed_version} not found."
            return
          end

          arch = @config.arch
          binary = package.versions[installed_version]

          if !Common.get_archs(binary, package.templates).includes?(arch)
            Logger.log "Binary for arch #{arch} not found."
            return
          end

          Worker.new(@config).remove(binary, installed_version, package_name, package)

          # Clean cache
          @cache.uninstall package_name

          Logger.end "#{package_name} v#{installed_version} removed successfully!"
        end
      end
    end
  end
end
