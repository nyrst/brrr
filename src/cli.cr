require "log"
require "option_parser"
require "./commands/*"
require "./lib/cache"
require "./lib/config"

module Brrr
  DEFAULT_COMMAND = "help"

  def self.run
    config = Config.new
    cache = Cache.new

    OptionParser.parse(ARGV) do |opts|
      opts.on("-v", "--verbose", "Increase the log verbosity, printing all debug statements.") {
        backend = Log::IOBackend.new
        Log.dexter.configure(:debug, backend)
      }

      opts.unknown_args do |args, options|
        command = args[0]? || DEFAULT_COMMAND

        Log.debug { "Command: #{command}" }

        case command
        when "cache"
          Commands::Cache.new(config, cache, args[1..-1])
        when "config"
          Commands::Configure.new(config, args[1..-1])
        when "doctor"
          Commands::Doctor.new(config, cache, args[1..-1])
        when "help"
          Commands::Help.run
        when "install"
          Commands::Install.new(config, cache, args[1..-1])
        when "outdated"
          Commands::Outdated.new(config, cache, args[1..-1])
        when "reset"
          Commands::Reset.new(config, cache)
        when "uninstall"
          Commands::Uninstall.new(config, cache, args[1..-1])
        when "upgrade"
          Commands::Upgrade.new(config, cache, args[1..-1])
        when "version"
          Commands::Version.run
        else
          puts "Unknown command: #{command}"
        end
      end
    end
  end
end
