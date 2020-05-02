require "../lib/common"

module Brrr
  module Commands
    class Doctor
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        @registry = Api.new nil

        if @config.installed.size == 0
          puts "No installed package."
        end

        @config.installed.each do |package_name, package_version|
          puts "Checking #{package_name}..."
          has_errors = doctor(package_name, package_version)
          if !has_errors
            puts "All good!"
          end
        end
      end

      protected def doctor(package_name : String, package_version : String)
        # Check if we have the yaml in cache, download it otherwise
        yaml = @cache.read_yaml(package_name)
        package : Package | Nil = nil
        if yaml.nil?
          yaml = download_yaml_and_load package_name
        end

        binary = get_package_description(yaml, package_name, package_version)

        if binary.nil?
          puts "Could not find binary definition for #{package_name} (version #{package_version}, arch #{@config.arch})."
          return true
        end

        symlinks = binary.symlinks
        if !symlinks.nil?
          return check_symlinks_errors(package_name, symlinks)
        end

        return false
      end

      protected def download_yaml_and_load(package_name : String)
        yaml = Common.get_yaml(@registry, package_name)
        package = Package.from_yaml(yaml)
        name = package.name
        cache_package_dir = @cache.path / name
        Common.save_yaml(cache_package_dir, name, yaml)

        package
      end

      protected def get_package_description(yaml : Package, package_name : String, package_version : String)
        if !yaml.versions.has_key? package_version
          return nil
        end

        binary = yaml.versions[package_version]

        if !binary.has_key? @config.arch
          return nil
        end

        return binary[@config.arch]
      end

      def check_symlinks_errors(package_name : String, symlinks : Hash(String, String))
        errors = 0

        symlinks.each do |exec_path, symlink_path|
          execOk = File.exists? @config.packages_path / package_name / exec_path
          symlinkOk = File.exists? @config.bin_path / symlink_path
          if !execOk || !symlinkOk
            puts "Missing files for symlink #{symlink_path} => #{exec_path}. Please reinstall #{package_name}."
            errors = errors + 1
          end
        end

        return errors != 0
      end
    end
  end
end
