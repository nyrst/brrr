module Brrr
  module Commands
    class Info
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        @repository = Repository.new @config.repository

        if args.size == 0
          Logger.log "Nothing to do."
        end

        args.each do |package_name|
          if @config.installed.has_key? package_name
            info(package_name, @config.installed[package_name])
            puts ""
          end
        end
      end

      protected def info(package_name : String, package_installation : Installation)
        package_url = package_installation.url
        installed_version = package_installation.version

        result = Common.get_yaml(@repository, package_url)
        yaml = result.body
        url = result.url

        if yaml.nil?
          PackageNotFound.log(package_name, @repository.repository)
          exit 0
        else
          package = Package.from_yaml(yaml)
          name = package.name
          line = "—" * name.size

          content = <<-TEXT
          #{name}
          #{line}
          Definition: #{url}
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
