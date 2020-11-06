require "file_utils"
require "semantic_version"

module Brrr
  module Common
    def self.can_upgrade(latest_version : String, installed_version : String)
      begin
        (SemanticVersion.parse(latest_version) <=> SemanticVersion.parse(installed_version)) == 1
      rescue
        latest_version > installed_version
      end
    end

    def self.get_yaml(repository : Repository, package : String)
      local_path = Path[package].expand(Dir.current)
      is_local = repository.is_local_package local_path

      if is_local
        Log.debug { "Common::get_yaml local #{local_path}" }
        repository.get_local_package local_path
      else
        Log.debug { "Common::get_yaml distant #{package}" }
        repository.get_package package
      end
    end

    def self.save_yaml(cache_package_dir : Path, name : String, yaml : String)
      FileUtils.mkdir_p(cache_package_dir.to_s)
      File.write("#{cache_package_dir}/#{name}.yaml", yaml)
    end
  end
end
