require "../lib/downloader"
require "../lib/registry"

module Brrr
  module Commands
    class Install
      def self.run(config : Brrr::Config, cache : Brrr::Cache, args : Array(String))
        registry = Api.new nil

        # TODO Make this parallel for multiple packages
        args.each do |package_name|
          local_path = Path[package_name].expand(Dir.current)

          yaml = if registry.is_local_package local_path
                   registry.get_local_package local_path
                 else
                   registry.get_package package_name
                 end

          File.write("#{cache.path}/#{package_name}.yaml", yaml)
          package = Package.from_yaml(yaml)

          name = package.name
          latest_version = package.latest_version

          binary = package.versions[latest_version][config.arch]

          start_index = (binary.url.rindex("/") || 0) + 1
          binary_name = binary.url[start_index..-1]

          cache_target_path = cache.path / binary_name
          Downloader.get_file(binary.url, cache_target_path)

          if binary.hash && !Downloader.verify(cache_target_path, binary)
            puts "Failed to verify checksum for file #{cache_target_path}."
            return
          end

          Downloader.extract(cache_target_path, binary, config.packages_path / name)

          config.link(name, binary.binaries)
        end
      end
    end
  end
end
