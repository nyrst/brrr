module Brrr
  module Script
    class Move
      def initialize(@packages_path : Path, @bin_path : Path)
      end

      def on_install(package : String, script : PostInstall)
        source = script.source
        target = script.target

        if !source.nil? && !target.nil?
          move(package, source, target)
        end
      end

      def on_uninstall(package : String, script : PostInstall)
        target = script.target
        if !target.nil?
          FileUtils.rm_rf (@bin_path / target).to_s
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
    end
  end
end
