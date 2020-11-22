require "file_utils"
require "../structs/package"
require "./scripts/*"

module Brrr
  class Config
    home : Path
    filename : String
    getter conf : BrrrConfig
    getter path : Path
    getter bin_path : Path
    getter packages_path : Path
    getter config_filepath : Path

    def initialize
      @home = Path.home
      @filename = "brrr.yaml"
      @path = @home / ".config" / "brrr"

      env_config_dir = ENV["BRRR_CONFIG_PATH"]?
      if !env_config_dir.nil?
        @path = Path[env_config_dir].expand(home: true)
      end

      @bin_path = @path / "bin"
      @packages_path = @path / "packages"

      if !Dir.exists? @bin_path
        Dir.mkdir_p(@bin_path, 0o755)
      end
      if !Dir.exists? @packages_path
        Dir.mkdir_p(@packages_path, 0o755)
      end

      @config_filepath = @path / @filename
      if File.exists? @config_filepath
        @conf = File.open(@config_filepath) do |file|
          BrrrConfig.from_yaml(file)
        end
      else
        @conf = BrrrConfig.from_yaml(
          <<-END
         arch: linux
         installed: {}
         END
        )

        save
      end
    end

    # TODO Get this from the system instead of a config file
    def arch
      @conf.arch
    end

    def repository
      @conf.repository
    end

    def installed
      @conf.installed
    end

    def post_install(package : String, scripts : Array(PostInstall))
      scripts.each do |script|
        case script.type
        when PostInstallType.echo
          Script::Echo.new.on_install(package, script)
        when PostInstallType.move
          Script::Move.new(@packages_path, @bin_path).on_install(package, script)
        when PostInstallType.run
          Script::Run.new(@packages_path).on_install(package, script)
        when PostInstallType.symlink
          Script::Symlink.new(@packages_path, @bin_path).on_install(package, script)
        else
          Logger.log "Unknown script command: #{script.type}."
        end
      end
    end

    def post_uninstall(package : String, scripts : Array(PostInstall))
      scripts.each do |script|
        case script.type
        when PostInstallType.move
          Script::Move.new(@packages_path, @bin_path).on_uninstall(package, script)
        when PostInstallType.symlink
          Script::Symlink.new(@packages_path, @bin_path).on_uninstall(package, script)
        when PostInstallType.echo
        when PostInstallType.run
        else
          Logger.log "Unknown script command: #{script.type}."
        end
      end
    end

    def list
      puts "Reading configuration from #{@config_filepath}"
      puts @conf.to_yaml
    end

    def add_installed_package(package : String, installation : Installation)
      @conf.installed[package] = installation

      save
    end

    def uninstall(package : String, binary : Binary)
      # Remove config package
      FileUtils.rm_rf (packages_path / package).to_s

      # Remove script contents
      post_uninstall(package, binary.post_install)

      # Remove from installed version
      @conf.installed.delete package
      save
    end

    def set(key : String, value : String)
      if key == "arch"
        @conf.arch = value
      elsif key == "repository"
        @conf.repository = value
      else
        puts "Unsupported key: #{key}"
        return
      end

      save
    end

    def save
      File.open(@config_filepath, "w") { |f| @conf.to_yaml(f) }
    end
  end
end
