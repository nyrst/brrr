require "option_parser"
require "./commands/*"
require "./lib/cache"
require "./lib/config"

module Brrr
  DEFAULT_COMMAND = "install"

  def self.run
    config = Config.new
    cache = Cache.new

    OptionParser.parse(ARGV) do |opts|
      opts.unknown_args do |args, options|
        case args[0]? || DEFAULT_COMMAND
        when "cache"
          Commands::Cache.run
        when "configure"
          Commands::Configure.run
        when "help"
          Commands::Help.run
        when "install"
          Commands::Install.run(config, cache, args.skip(1))
        when "update"
          Commands::Update.run
        when "version"
          Commands::Version.run
        end
      end
    end
  end
end
