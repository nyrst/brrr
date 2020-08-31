require "../structs/package"

module Brrr
  module Commands
    class Uninstall
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        if args.size == 0
          puts "❄️ Nothing to do."
        end

        args.each do |name|
          uninstall name
          puts ""
        end
      end

      def uninstall(name : String)
        # Read installed version

        if !@config.installed.has_key? name
          puts "❄️ #{name} is not installed."
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

        puts "⛄ Removing #{package_name} v#{installed_version}"

        # Read cache yaml
        package = @cache.read_yaml package_name

        if !package.nil?
          if !package.versions.has_key? installed_version
            puts "❄️ Version #{installed_version} not found."
            return
          end

          arch = @config.arch
          binary = package.versions[installed_version]
          if !binary.has_key? arch
            puts "❄️ Binary for arch #{arch} not found."
            return
          end

          @config.uninstall(package_name, binary[arch])

          # Clean cache
          @cache.uninstall package_name

          puts "☃️ #{package_name} v#{installed_version} removed successfully!"
        end
      end
    end
  end
end
