module Brrr
  module Commands
    class Uninstall
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        if args.size == 0
          puts "Nothing to do."
        end

        args.each do |name|
          uninstall name
        end
      end

      protected def uninstall(name : String)
        # Read installed version
        arch = @config.arch
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

          # Clean configuration
          @config.remove(name, binary[arch].symlinks.values)

          # Clean cache
          @cache.remove name
        end
      end
    end
  end
end
