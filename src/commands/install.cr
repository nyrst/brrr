require "../lib/downloader"
require "../lib/registry"

module Brrr
  module Commands
    class Install
      def self.run(config : Brrr::Config, cache : Brrr::Cache, args : Array(String))
        registry = Api.new nil

        # TODO Make this parallel for multiple packages
        args.each do |package_name|
          # Let's get this package

          local_path = Path[package_name].expand(Dir.current)
          is_local = registry.is_local_package local_path
          yaml = if is_local
                   registry.get_local_package local_path
                 else
                   registry.get_package package_name
                 end

          # Now, time to read the package and get some info
          package = Package.from_yaml(yaml)
          name = package.name

          cache_package_dir = cache.path / name
          FileUtils.mkdir_p(cache_package_dir.to_s)

          File.write("#{cache_package_dir}/#{package_name}#{is_local ? "" : ".yaml"}", yaml)

          latest_version = package.latest_version
          if !package.versions.has_key? latest_version
            puts "Version #{latest_version} not found in binaries list."
            return
          end

          latest_binary = package.versions[latest_version]
          if !latest_binary.has_key? config.arch
            puts "Binary for arch #{config.arch} not found. Available archs are: #{latest_binary.keys.join(",")}"
            return
          end

          puts "Installing #{name} v#{latest_version}"

          # Time to download the binary
          binary = latest_binary[config.arch]
          start_index = (binary.url.rindex("/") || 0) + 1
          binary_name = binary.url[start_index..-1]
          cache_target_path = cache_package_dir / binary_name
          Downloader.get_file(binary.url, cache_target_path)

          # If a hash is provided, we verify the package
          if binary.hash && !Downloader.verify(cache_target_path, binary)
            puts "Failed to verify checksum for file #{cache_target_path}."
            return
          end

          # Then we can extract from the cache to our packages folder
          Downloader.extract(cache_target_path, binary, config.packages_path / name)

          # And write some symbolic links
          config.link(name, binary.binaries)

          # Finally, we add the package to our installed packages
          config.add_installed_package(name, latest_version)
        end
      end
    end
  end
end
