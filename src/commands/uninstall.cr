module Brrr
  module Commands
    class Uninstall
      def self.run(config : Brrr::Config, cache : Brrr::Cache, args : Array(String))
        args.each do |name|
          # Read installed version
          installed_version = config.installed[name]

          puts "Removing #{name} v#{installed_version}"

          # Read cache yaml
          package = cache.read_yaml name

          if !package.nil?
            if !package.versions.has_key? installed_version
              puts "Version #{installed_version} not found."
              return
            end

            binary = package.versions[installed_version]
            if !binary.has_key? config.arch
              puts "Binary for arch #{config.arch} not found."
              return
            end

            # Clean configuration
            config.remove(name, binary[config.arch].binaries.values)

            # Clean cache
            cache.remove name
          end
        end
      end
    end
  end
end
