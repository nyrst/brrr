module Brrr
  module Script
    class Run
      def initialize(@packages_path : Path)
      end

      def on_install(package : String, script : PostInstall)
        command = script.command
        if !command.nil?
          io_err = IO::Memory.new
          io_in = IO::Memory.new
          io_out = IO::Memory.new

          puts "\n"
          Logger.log "Running #{command}"
          puts "\n\n"

          working_directory = script.working_directory
          dir = if working_directory.nil?
                  nil
                else
                  (@packages_path / package / working_directory).to_s
                end

          Process.new(command, nil, nil, false, true, io_in, io_out, io_err, dir).wait

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
      end
    end
  end
end
