module Brrr
  module Commands
    class Cache
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        if args.size == 0
          puts "Nothing to do."
        end

        command = args[0]

        if command == "clean"
          clean
        else
          puts "Nothing to do."
        end
      end

      def clean
        installed_packages = @config.installed.keys
        cache_packages = @cache.get_all_packages

        # Remove packages that are not installed
        to_remove_completely = cache_packages - installed_packages
        to_remove_completely.map { |p| @cache.uninstall p }

        # For installed packages, keep only the yaml file
        installed_packages.each { |p| @cache.remove_binary p }
      end
    end
  end
end
