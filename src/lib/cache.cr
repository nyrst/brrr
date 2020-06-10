require "file_utils"
require "yaml_mapping"

module Brrr
  class Cache
    home : Path
    getter path : Path

    def initialize
      @home = Path.home
      @path = @home / ".cache" / "brrr"

      env_cache_dir = ENV["BRRR_CACHE_PATH"]?
      if !env_cache_dir.nil?
        @path = Path[env_cache_dir].expand(home: true)
      end

      if !Dir.exists? @path
        Dir.mkdir_p(@path, 0o755)
      end
    end

    def get_all_packages
      Dir.new(@path.to_s).children
    end

    def read_yaml(package : String)
      package_path = @path / package / "#{package}.yaml"

      if File.exists? package_path
        yaml = File.open(package_path) do |file|
          Package.from_yaml(file)
        end
      end

      yaml
    end

    def uninstall(package : String)
      FileUtils.rm_rf (@path / package).to_s
    end

    def remove_binary(package : String)
      Dir.new((@path / package).to_s).children.each do |e|
        if e != "#{package}.yaml"
          FileUtils.rm_rf (@path / package / e).to_s
        end
      end
    end
  end
end
