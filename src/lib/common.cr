module Brrr
  module Common
    def self.get_yaml(registry : Api, package_name : String)
      local_path = Path[package_name].expand(Dir.current)
      is_local = registry.is_local_package local_path

      if is_local
        registry.get_local_package local_path
      else
        registry.get_package package_name
      end
    end
  end
end
