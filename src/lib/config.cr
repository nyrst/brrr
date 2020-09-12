require "file_utils"
require "../structs/package"

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

    def installed
      @conf.installed
    end

    def post_install(package : String, scripts : Array(PostInstall))
      scripts.each do |script|
        case script.type
        when PostInstallType.echo
          message = script.message

          if !message.nil?
            puts "\n  #{message}\n"
          end
        when PostInstallType.move
          source = script.source
          target = script.target

          if !source.nil? && !target.nil?
            move(package, source, target)
          end
        when PostInstallType.run
          command = script.command
          if !command.nil?
            io_err = IO::Memory.new
            io_in = IO::Memory.new
            io_out = IO::Memory.new

            puts "\n"
            Logger.log "Running #{command}"
            puts "\n\n"

            Process.new(command, nil, nil, false, true, io_in, io_out, io_err).wait

            log_err = io_err.to_s
            log_out = io_out.to_s

            if log_err.size > 0
              Logger.log "An error occured while running #{command}"
              puts log_err
              Logger.log "End of error"
            else
              puts log_out
            end
          end
        when PostInstallType.symlink
          source = script.source
          target = script.target

          if !source.nil? && !target.nil?
            link(package, source, target)
          end
        else
          Logger.log "Unknown script command: #{script.type}."
        end
      end
    end

    def post_uninstall(package : String, scripts : Array(PostInstall))
      scripts.each do |script|
        case script.type
        when PostInstallType.move
          target = script.target
          if !target.nil?
            FileUtils.rm_rf (bin_path / target).to_s
          end
        when PostInstallType.symlink
          target = script.target
          if !target.nil?
            FileUtils.rm_rf (bin_path / target).to_s
          end
        when PostInstallType.echo
        when PostInstallType.run
        else
          Logger.log "Unknown script command: #{script.type}."
        end
      end
    end

    protected def link(package : String, file_path : String, link_path : String)
      source = @packages_path / package / file_path

      canResolvePath = link_path.starts_with?("/") || link_path.starts_with?(".") || link_path.starts_with?("~")
      target = if canResolvePath
                 Path[link_path].expand(home: Path.home)
               else
                 @bin_path / link_path
               end

      if File.exists? source
        Logger.log "Linking #{source} to #{target}"
        File.chmod(source, 0o755)
        FileUtils.ln_sf(source.to_s, target.to_s)
      else
        Logger.log "Failed to link #{source} to #{target}"
      end
    end

    protected def move(package : String, file_path : String, link_path : String)
      source = @packages_path / package / file_path

      canResolvePath = link_path.starts_with?("/") || link_path.starts_with?(".") || link_path.starts_with?("~")
      to = if canResolvePath
             Path[link_path].expand(home: Path.home)
           else
             link_path
           end

      if File.exists? source
        Logger.log "Moving #{source} to #{to}"
        FileUtils.mv([source.to_s], to.to_s)
      else
        Logger.log "Failed to move #{source} to #{to}"
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
      end

      save
    end

    def save
      File.open(@config_filepath, "w") { |f| @conf.to_yaml(f) }
    end
  end
end
