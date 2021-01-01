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
      opts.on("-h", "--help", "Show this help") do
        Commands::Help.run
      end
      opts.on("-v", "--verbose", "Increase the log verbosity, printing all debug statements.") do
        Log.setup :debug
      end

      opts.unknown_args do |args, options|
        command = args[0]? || DEFAULT_COMMAND

        Log.debug { "Command: #{command}" }

        case command
        when "cache"
          Commands::Cache.new(config, cache, args[1..-1])
        when "config"
          Commands::Configure.new(config, args[1..-1])
        when "freezer"
          Commands::Freezer.new(config, args[1..-1])
        when "h", "help"
          Commands::Help.run
        when "info"
          Commands::Info.new(config, cache, args[1..-1])
        when "add", "i", "install"
          Commands::Install.new(config, cache, args[1..-1])
        when "list", "ls"
          Commands::List.new(config)
        when "outdated"
          Commands::Outdated.new(config, cache)
        when "reset"
          Commands::Reset.new(config, cache)
        when "remove", "rm", "u", "uninstall"
          Commands::Uninstall.new(config, cache, args[1..-1])
        when "up", "upgrade"
          Commands::Upgrade.new(config, cache, args[1..-1])
        when "v", "version"
          Commands::Version.run
        else
          Logger.log "Unknown command: #{command}\n\n"
          Commands::Help.run
          exit 0
        end
      end
    end
  end
end
