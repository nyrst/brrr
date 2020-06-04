require "../lib/common"
require "../lib/errors"
require "../lib/downloader"
require "../lib/registry"

module Brrr
  module Commands
    class Install
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        @registry = Api.new nil

        if args.size == 0
          puts "Nothing to do."
        end

        args.each do |package_name|
          if @config.installed.has_key? package_name
            puts "#{package_name} (version #{@config.installed[package_name]}) is already installed."
            puts "Try the following command:"
            puts ""
            puts "  brrr upgrade #{package_name}"
            exit 0
          end

          if package_name.includes? "@"
            package_name, package_version = package_name.split("@")
            install(package_name, package_version)
          else
            install(package_name, "latest")
          end

          puts ""
        end
      end

      protected def download_and_get_target(url : String, cache_package_dir : Path)
        start_index = (url.rindex("/") || 0) + 1
        binary_name = url[start_index..-1]
        cache_target_path = cache_package_dir / binary_name
        Downloader.get_file(url, cache_target_path)

        cache_target_path
      end

      protected def install(package_name : String, package_version : String)
        # Let's get this package
        yaml = Common.get_yaml(@registry, package_name)

        if yaml.nil?
          PackageNotFound.log(package_name, @registry.registry)
          exit 0
        end

        # Now, time to read the package and get some info
        package = Package.from_yaml(yaml)
        name = package.name
        cache_package_dir = @cache.path / name

        # And check a few things
        latest_version = if package_version == "latest"
                           package.latest_version
                         else
                           package_version
                         end

        if !package.versions.has_key? latest_version
          puts "Version #{latest_version} not found in binaries list."
          return
        end

        latest_binary = package.versions[latest_version]
        if !latest_binary.has_key? @config.arch
          puts "Binary for arch #{@config.arch} not found. Available archs are: #{latest_binary.keys.join(",")}"
          return
        end

        binary = latest_binary[@config.arch]

        puts "Installing #{name} v#{latest_version}"

        # Let's save this yaml
        Common.save_yaml(cache_package_dir, name, yaml)

        # Time to download the binary

        cache_target_path = download_and_get_target(binary.url, cache_package_dir)

        # Let's verify the hash (check if present is in the `verify` function)
        if !Downloader.verify(cache_target_path, binary)
          puts "Failed to verify checksum for file #{cache_target_path}."
          return
        end

        # Then we can extract from the cache to our packages folder
        Downloader.extract(cache_target_path, binary, @config.packages_path / name)

        if binary.post_install
          @config.post_install(name, binary.post_install)
        end

        # Finally, we add the package to our installed packages
        @config.add_installed_package(name, latest_version)
      end
    end
  end
end
