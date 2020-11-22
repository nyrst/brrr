module Brrr
  module Script
    class Symlink
      def initialize(@packages_path : Path, @bin_path : Path)
      end

      def on_install(package : String, script : PostInstall)
        source = script.source
        target = script.target

        if !source.nil? && !target.nil?
          link(package, source, target)
        end
      end

      def on_uninstall(package : String, script : PostInstall)
        target = script.target
        if !target.nil?
          FileUtils.rm_rf (@bin_path / target).to_s
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
    end
  end
end
