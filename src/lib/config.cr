require "file_utils"

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

    def installed
      @conf.installed
    end

    def link(package : String, binaries : Hash(String, String)?)
      if binaries.nil?
        return
      end

      binaries.each do |key, value|
        from = @packages_path / package / key
        to = @bin_path / value

        if File.exists? from
          puts "Linking #{from} to #{to}"
          File.chmod(from, 0o755)
          FileUtils.ln_s(from.to_s, to.to_s)
        else
          puts "Failed to link #{from} to #{to}"
        end
      end
    end

    def list
      puts @conf
    end

    def add_installed_package(package : String, version : String)
      @conf.installed[package] = version

      save
    end

    def remove(package : String, links : Array(String))
      # Remove config package
      FileUtils.rm_rf (packages_path / package).to_s

      # Remove config symbolic links
      FileUtils.rm_rf links.map { |ln| (bin_path / ln).to_s }

      # Remove from installed version
      @conf.installed.delete package
      save
    end

    def set(key : String, value : String)
      if key == "arch"
        @conf.arch = value
      end

      save
    end

    def save
      File.open(@config_filepath, "w") { |f| @conf.to_yaml(f) }
    end
  end
end
