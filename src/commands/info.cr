module Brrr
  module Commands
    class Info
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        @registry = Api.new nil

        if args.size == 0
          Logger.log "Nothing to do."
        end

        args.each do |package_name|
          info(package_name, if @config.installed.has_key? package_name
            @config.installed[package_name]
          else
            nil
          end
          )
          puts ""
        end
      end

      protected def info(name : String, version : String | Nil)
        installation_version = if version.nil?
                                 "latest"
                               else
                                 version
                               end

        yaml_installation = <<-YAML
          url: #{name}
          version: #{installation_version}
        YAML
        installation = Installation.from_yaml yaml_installation

        info(name, installation)
      end

      protected def info(package_name : String, package_installation : Installation)
        package_url = package_installation.url
        installed_version = package_installation.version

        yaml = Common.get_yaml(@registry, package_url)

        if yaml.nil?
          PackageNotFound.log(package_name, @registry.registry)
          exit 0
        else
          package = Package.from_yaml(yaml)
          name = package.name
          line = "—" * name.size

          content = <<-TEXT
          #{name}
          #{line}
          Definition: #{package.brrr}
          Available versions: #{package.versions.keys.sort.join ", "}
          Latest version: #{package.latest_version}
          TEXT

          puts content

          if installed_version != "latest"
            puts "Installed version: #{installed_version}"
          end
        end
      end
    end
  end
end
