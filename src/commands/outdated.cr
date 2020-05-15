require "../lib/common"

module Brrr
  module Commands
    class Outdated
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        @registry = Api.new nil

        # List installed packages
        @config.installed.each do |name, current_version|
          # Fetch package from registry

          # Let's get this package
          yaml = Common.get_yaml(@registry, name)

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

          puts "#{name} (#{current_version}). #{next_text}"
        end
      end
    end
  end
end
