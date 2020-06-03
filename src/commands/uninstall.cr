module Brrr
  module Commands
    class Uninstall
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        if args.size == 0
          puts "Nothing to do."
        end

        args.each do |name|
          uninstall name
          puts ""
        end
      end

      def uninstall(name : String)
        # Read installed version
        arch = @config.arch

        if !@config.installed.has_key? name
          puts "#{name} is not installed."
          exit 0
        end

        installed_version = @config.installed[name]

        puts "Removing #{name} v#{installed_version}"

        # Read cache yaml
        package = @cache.read_yaml name

        if !package.nil?
          if !package.versions.has_key? installed_version
            puts "Version #{installed_version} not found."
            return
          end

          binary = package.versions[installed_version]
          if !binary.has_key? arch
            puts "Binary for arch #{arch} not found."
            return
          end

          @config.uninstall(name, binary[arch])

          # Clean cache
          @cache.uninstall name
        end
      end
    end
  end
end
