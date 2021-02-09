require "../lib/common"
require "../lib/errors"

module Brrr
  module Commands
    class Outdated
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache)
        @repository = Repository.new @config.repository

        packages_to_update = Array(String).new

        packages = @config.installed.keys.sort

        packages.each do |package_name|
          package_installation = @config.installed[package_name]
          if !package_installation.nil? && outdated(package_name, package_installation)
            packages_to_update << package_name
          end
        end

        if packages_to_update.size > 0
          puts ""
          puts "To upgrade, run:"
          puts ""
          puts "  brrr upgrade #{packages_to_update.join(" ")}"
        end
      end

      protected def outdated(name : String, version : String)
        yaml_installation = <<-YAML
          url: #{name}
          version: #{version}
        YAML
        installation = Installation.from_yaml yaml_installation

        outdated(name, installation)
      end

      protected def outdated(package_name : String, package_installation : Installation)
        package_url = package_installation.url
        current_version = package_installation.version

        # Let's get this package
        yaml = Common.get_yaml(@repository, package_url)

        if yaml.nil?
          PackageNotFound.log(package_name, @repository.repository)
          exit 0
        else
          # Now, time to read the package and get some info
          body = yaml.body

          if body.nil?
            puts "Failed to read content for #{package_name}"
            return
          end

          package = Package.from_yaml(body)

          latest = package.latest_version
          all_versions = package.versions.keys
          next_versions = all_versions.select { |v| Common.can_upgrade(v, current_version) }

          has_next_version = next_versions.size > 0

          next_text = if has_next_version
                        "Available version(s): #{next_versions.sort.join(", ")}"
                      else
                        "You already have the latest version."
                      end

          puts "#{package_name} (#{current_version}). #{next_text}"

          has_next_version
        end
      end
    end
  end
end
