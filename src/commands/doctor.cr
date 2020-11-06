require "../lib/common"
require "../lib/errors"

module Brrr
  module Commands
    class Doctor
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache, args : Array(String))
        @repository = Repository.new @config.repository

        if @config.installed.size == 0
          puts "No installed package."
        end

        @config.installed.each do |package_name, package_installation|
          puts "Checking #{package_name}..."
          is_ok = doctor(package_name, package_installation)
          if is_ok
            puts "All good!"
          else
            puts "Errors found, please reinstall #{package_name}"
          end
        end
      end

      protected def doctor(package_name : String, package_version : String)
        yaml_installation = <<-YAML
          url: #{package_name}
          version: #{package_version}
        YAML
        installation = Installation.from_yaml yaml_installation

        doctor(package_name, installation)
      end

      protected def doctor(package_name : String, package_installation : Installation)
        package_version = package_installation.version
        package_url = package_installation.url

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

        is_ok = [] of Bool

        binary.post_install.each do |script|
          case script.type
          when PostInstallType.move
            # TODO
          when PostInstallType.symlink
            is_ok << is_symlink_ok(package_name, script.source, script.target)
          else
            puts "Unknown script command: #{script.type}."
          end
        end

        return is_ok.all?
      end

      protected def download_yaml_and_load(package_name : String)
        yaml = Common.get_yaml(@repository, package_name)

        if yaml.nil?
          PackageNotFound.log(package_name, @repository.repository)
          exit 0
        else
          package = Package.from_yaml(yaml)

          name = package.name
          cache_package_dir = @cache.path / name

          Common.save_yaml(cache_package_dir, name, yaml)

          package
        end
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

      protected def is_moved_ok
      end

      protected def is_symlink_ok(package_name : String, exec_path : String?, symlink_path : String?)
        if exec_path.nil? || symlink_path.nil?
          puts "Wrong symlink for package #{package_name} (#{symlink_path} -> #{exec_path})"
          return false
        end

        execOk = File.exists? @config.packages_path / package_name / exec_path
        symlinkOk = File.exists? @config.bin_path / symlink_path

        if !execOk || !symlinkOk
          puts "Missing files for symlink #{symlink_path} => #{exec_path}. Please reinstall #{package_name}."
          return false
        end

        return true
      end
    end
  end
end
