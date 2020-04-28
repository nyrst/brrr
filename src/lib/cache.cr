require "file_utils"
require "yaml"

module Brrr
  class Cache
    home : Path
    getter path : Path

    def initialize
      @home = Path.home
      @path = @home / ".cache" / "brrr"

      if !Dir.exists? @path
        Dir.mkdir_p(@path, 0o755)
      end
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

    def remove(package : String)
      FileUtils.rm_rf (@path / package).to_s
    end
  end
end
