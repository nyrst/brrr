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

        # TODO Make this parallel for multiple packages
        args.each do |package_name|
          install package_name
        end
      end

      protected def get_yaml(package_name : String)
        local_path = Path[package_name].expand(Dir.current)
        is_local = @registry.is_local_package local_path

        if is_local
          @registry.get_local_package local_path
        else
          @registry.get_package package_name
        end
      end

      protected def check_version_and_arch
      end

      protected def download_and_get_target(url : String, cache_package_dir : Path)
        start_index = (url.rindex("/") || 0) + 1
        binary_name = url[start_index..-1]
        cache_target_path = cache_package_dir / binary_name
        Downloader.get_file(url, cache_target_path)

        cache_target_path
      end

      protected def save_yaml(cache_package_dir : Path, name : String, yaml : String)
        FileUtils.mkdir_p(cache_package_dir.to_s)
        File.write("#{cache_package_dir}/#{name}.yaml", yaml)
      end

      protected def install(package_name : String)
        # Let's get this package
        yaml = get_yaml package_name

        # Now, time to read the package and get some info
        package = Package.from_yaml(yaml)
        name = package.name
        cache_package_dir = @cache.path / name

        # And check a few things
        latest_version = package.latest_version
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
        save_yaml(cache_package_dir, name, yaml)

        # Time to download the binary

        cache_target_path = download_and_get_target(binary.url, cache_package_dir)

        # If a hash is provided, we verify the package
        if binary.hash && !Downloader.verify(cache_target_path, binary)
          puts "Failed to verify checksum for file #{cache_target_path}."
          return
        end

        # Then we can extract from the cache to our packages folder
        Downloader.extract(cache_target_path, binary, @config.packages_path / name)

        # And write some symbolic links
        @config.link(name, binary.symlinks)

        # Finally, we add the package to our installed packages
        @config.add_installed_package(name, latest_version)
      end
    end
  end
end
