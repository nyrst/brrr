require "../lib/common"
require "../lib/errors"
require "../lib/downloader"
require "../lib/repository"
require "../lib/worker/worker"

module Brrr
  module Commands
    class Install
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        @repository = Repository.new @config.repository

        if args.size == 0
          puts "Nothing to do."
        end

        args.each do |package_name|
          if @config.installed.has_key? package_name
            puts "#{package_name} (version #{show_version(@config.installed[package_name])}) is already installed."
            puts "Try the following command:"
            puts ""
            puts "  brrr upgrade #{package_name}"
            break
          end

          begin
            if package_name.includes? "@"
              package_name, package_version = package_name.split("@")
              install(package_name, package_version)
            else
              install(package_name, "latest")
            end
          rescue ex
            puts "Failed to install #{package_name}"
            puts "  #{ex.message}"
          end

          puts ""
        end
      end

      protected def show_version(version : Installation)
        version.version
      end

      protected def install(package_name : String, package_version : String)
        Log.debug { "install #{package_name}, version #{package_version}" }

        # Let's get this package
        yaml = Common.get_yaml(@repository, package_name)

        if yaml.nil?
          PackageNotFound.log(package_name, @repository.repository)
          exit 0
        end

        # Now, time to read the package and get some info
        url = yaml.url
        body = yaml.body

        if body.nil?
          Logger.end "Failed to get #{package_name} data"
          return
        end

        package = Package.from_yaml(body)

        # Check brrr version
        brrr_version = package.brrr_version
        if !brrr_version.nil? && !(Common.can_upgrade(VERSION, brrr_version) || Common.is_same_version(VERSION, brrr_version))
          Logger.log("Incompatible brrr version (current: #{VERSION}, needed: #{brrr_version})")
          return
        end

        name = package.name
        cache_package_dir = @cache.path / name

        # And check a few things
        latest_version = if package_version == "latest"
                           package.latest_version
                         else
                           package_version
                         end

        Logger.start "Installing #{name} v#{latest_version}"

        if !package.versions.has_key? latest_version
          Logger.log "Version #{latest_version} not found in binaries list."
          return
        end

        latest_version_details = package.versions[latest_version]
        version_archs = Common.get_archs(latest_version_details, package.templates)
        if !version_archs.includes? @config.arch
          Logger.log "Binary for arch #{@config.arch} not found. Available archs are: #{version_archs.join(",")}"
          return
        end

        # Let's save this yaml
        Common.save_yaml(cache_package_dir, name, body)

        # Time to download the binary
        Worker.new(@config).download(latest_version_details, latest_version, cache_package_dir, name, package)

        # Finally, we add the package to our installed packages
        yaml_installation = <<-YAML
          url: #{yaml.url}
          version: #{latest_version}
        YAML
        installation = Installation.from_yaml yaml_installation
        @config.add_installed_package(name, installation)

        Logger.end "#{name} #{latest_version} installed successfully!"
      end
    end
  end
end
