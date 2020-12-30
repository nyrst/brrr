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

      protected def run(package_name : String, package_version : String)
        yaml_installation = <<-YAML
          url: #{package_name}
          version: #{package_version}
        YAML
        installation = Installation.from_yaml yaml_installation

        run(package_name, installation)
      end

      protected def run(package_name : String, installation : Installation)
        installed_version = installation.version

        Logger.start "Removing #{package_name} v#{installed_version}"

        # Read cache yaml
        package = @cache.read_yaml package_name

        if !package.nil?
          if !package.versions.has_key? installed_version
            Logger.log "Version #{installed_version} not found."
            return
          end

          arch = @config.arch
          binary = package.versions[installed_version]
          if !binary.has_key? arch
            Logger.log "Binary for arch #{arch} not found."
            return
          end

          remove(binary[arch], package_name)

          # Clean cache
          @cache.uninstall package_name

          Logger.end "#{package_name} v#{installed_version} removed successfully!"
        end
      end

      private def remove(binary : Binary, package_name : String)
        @config.uninstall(package_name, binary)
      end

      private def remove(binaries : Array(Binary), package_name : String)
        binaries.each { |b| remove(b, package_name) }
      end
    end
  end
end
